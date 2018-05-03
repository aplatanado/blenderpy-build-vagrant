from setuptools import setup
import os

BLENDER_VERSION = os.environ.get('BLENDER_VERSION')

def get_extra_files():
    data_dirs = [BLENDER_VERSION] if BLENDER_VERSION else []
    return [os.path.join(dirpath, f) for data_dir in data_dirs
            for dirpath, subdirs, files in os.walk(data_dir) for f in files]

setup(name='bpy',
      version=BLENDER_VERSION,
      description='Blender as Python module',
      packages=[''],
      packages_dir={'': '.'},
      package_data={'': ['bpy.so'] + get_extra_files()},
      )
