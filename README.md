# Hugging Face Dataset Structurer

Hugging Face Dataset Structurer is a Python wrapper to simplify the process of deploying multi-config datasets to the Hugging Face Hub. We developed this tool because we found the official documentation to be lacking in detail and creating the perception the process requires a manual step to develop a dataset loading script. You don't need to do that! This tool will do it for you. 


### Installation

```bash
pip install -U hf-dataset-structurer
```

### Quickstart

In this example, we will create a bundle for Portuguese NER. Official HuggingFace HAREM dataset [entry](https://huggingface.co/datasets/harem) it's true name is "first-HAREM". We will create a bundle attaching the second-HAREM available [here](https://www.linguateca.pt/LivroSegundoHAREM/). This dataset has two labelling schemes, DEFAULT and SELECTIVE. Selective is just a coarse-grained version of DEFAULT. These two schemes turn this dataset a good candidate to demonstrate the power of this tool.

```python
from datasets import load_dataset, concatenate_datasets, DatasetDict 
from hf_dataset_structurer.DatasetStructure import DatasetStructure

structurer = DatasetStructure("<<TARGET Hugging Face Dataset Name>>")

# Iterate both Labelling Schemes
for config in ["default", "selective"]:
    # Load Official HAREM Dataset
    primeiro_harem = load_dataset("harem", config)
    
    # Start Structuring Process
    structurer.add_dataset(primeiro_harem['train'], f"primeiro_harem_{config}", split="train")

# Load Second HAREM Datasets

second_harem_default = load_dataset("arubenruben/segundo_harem_default")
second_harem_selective = load_dataset("arubenruben/segundo_harem_selective")

# Notice the function used now is add_dataset_dict. A [DatasetDict](https://huggingface.co/docs/datasets/v2.15.0/en/package_reference/main_classes#datasets.DatasetDict) is a native HuggingFace object that represents a dictionary of datasets.
structurer.add_dataset_dict(second_harem_default, "segundo_harem_default")
structurer.add_dataset_dict(second_harem_selective, "segundo_harem_selective")

# Create Dataset Card to describe the dataset
structurer.attach_dataset_card(
    language="pt",
    license="cc-by-4.0",
    annotations_creators=["expert-generated"],
    task_categories=["token-classification"],
    tasks_ids=["named-entity-recognition"],
    pretty_name="HAREM",
    multilinguality='monolingual'
)

# Push to Hugging Face Hub
structurer.push_to_hub()

```

### API Reference

```python

# Initializes a new instance of the DatasetStructure class.
__init__(self, repo_name: str) -> None

# Accepts a DatasetDict and a config_name and adds it to the dataset structure.
add_dataset_dict(self, dataset_dict: DatasetDict, config_name: str) -> None

# Similar to add_dataset_dict, but accepts a Dataset and a split. Internally, it creates a DatasetDict and calls add_dataset_dict.
add_dataset(self, dataset: Dataset, config_name: str, split: str = "train") -> None

# Attaches a dataset card to the dataset structure.
attach_dataset_card(self, language: str,
                    license: str,
                    annotations_creators: str,
                    task_categories: str,
                    tasks_ids: str,
                    pretty_name: str,
                    multilinguality: str = 'monolingual') -> None

# Pushes the dataset structure and dataset card to the Hugging Face Hub.
push_to_hub(self, private: bool = False) -> None
```

### Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

### License

[MIT](https://choosealicense.com/licenses/mit/)

### Acknowledgements

This tool was developed by [Ruben Almeida](https://www.linkedin.com/in/almeida-ruben/) as part of the Project [PT-Pump-Up](http://pt-pump-up.inesctec.pt/). PT-Pump-Up is a project funded by INESC TEC and the Portuguese Government through the Fundação para a Ciência e a Tecnologia (FCT) that aims to build Portuguese NLP resources and tools to support the development of NLP applications for Portuguese.

### References

* [HF Official Docs - Structure your repository](https://huggingface.co/docs/datasets/repository_structure#define-your-splits-in-yaml)

* [HF Official Docs - Dataset Card](https://huggingface.co/docs/datasets/add_dataset_card)
