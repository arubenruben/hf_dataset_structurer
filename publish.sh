python setup.py sdist bdist_wheel

twine upload dist/* --verbose

sleep 5