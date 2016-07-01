#!/usr/bin/env python
# -*- coding: utf-8 -*-

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup
from setuptools.command.test import test as TestCommand


class PyTest(TestCommand):

    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        # import here, cause outside the eggs aren't loaded
        import pytest
        self.test_args.append('-rx')
        self.test_args.append('--runxfail')
        errno = pytest.main(self.test_args)
        raise SystemExit(errno)


with open('README.md') as readme_file:
    readme = readme_file.read()


history = ''


install_requires = set(x.strip() for x in open('requirements.txt'))
install_requires_replacements = {
    'https://github.com/HydraChain/hydrachain/tarball/develop': 'hydrachain',
}

install_requires = [install_requires_replacements.get(r, r) for r in install_requires]

test_requirements = []

version = '0.0.1'  # preserve format, this is read from __init__.py

setup(
    name='raiden',
    version=version,
    description="",
    long_description=readme + '\n\n' + history,
    author="HeikoHeiko",
    author_email='heiko@brainbot.com',
    url='https://github.com/heikoheiko/raiden',
    packages=[
        'raiden'
    ],
    include_package_data=True,
    license="BSD",
    zip_safe=False,
    keywords='raiden',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        "Programming Language :: Python :: 2",
        'Programming Language :: Python :: 2.7',
    ],
    cmdclass={'test': PyTest},
    install_requires=install_requires,
    tests_require=test_requirements,
    entry_points='''
    [console_scripts]
    raiden=raiden.app:app
    '''
)
