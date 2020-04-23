#!/usr/bin/env python
# script to make tar balls of folders
import subprocess
import glob
import sys
import argparse
import tarfile

def ignore_files(files, ignore):
    '''
    files = list of files to filter
    ignore = list of files to ignore
    '''
    j = 0
    while j < len(files):
        for i in ignore:
            if i in files[j]:
                print('removed', files[j])
                del files[j]
                j-=1
                break
        j+=1

def keep_files(files, keep):
    out = []
    for f in files:
        for k in keep:
            if k in f:
                print('keeping ',f)
                out.append(f)
                break
    return out

def reset(tarinfo):
    tarinfo.uid = tarinfo.gid = 0
    tarinfo.uname = tarinfo.gname = "root"
    return tarinfo

# setup arguments to parse
parser = argparse.ArgumentParser(description='Packs target folders into a tarball')
parser.add_argument('-i', help='Input directory to make tarballs')

# parse the arguments
args = parser.parse_args()

# check if parameters are set
if args.i==None:
    print('Input file not set')
    sys.exit(1)
print('building tarball for ',args.i)


# build tars only of these modules
modules = ['rebind','visualization','nupack-draw','armadillo','backward-cpp','cmake-modules','gecode','find-tbb','lilwil']
mod_files = glob.glob(args.i+'/external/*')
mod_files = keep_files(mod_files, modules)

# build tars of src from these files
src_folder = ['CMakeLists.txt','README.md','cmake','nupack/nupack','dev','test','executables','parameters','package','python']
src_files = glob.glob(args.i+'/*')
src_files = keep_files(src_files, src_folder)

# files to not packup
ignore = ['README.md','LICENSE','.git','.pdf','.png','.html']

for f in mod_files:
    # make the tarfile object
    print('building tarball for',f)
    fname = f.split('/')[-1]
    tar = tarfile.open(fname+'.tar.gz', mode='w:gz')
    
    # add things to the archive
    flist = glob.glob(f+'/*')
    ignore_files(flist, ignore)
    
    for k in flist:
        print('adding',k)
        arcname = './'+k.split('external/')[-1]
        tar.add(k, arcname=arcname, filter=reset)
    tar.close()

tar = tarfile.open('src.tar.gz', mode='w:gz')
for k in src_files:
    print('adding ',k)
    if 'nupack/nupack' in k:
        arcname = './nupack/nupack'
    else:
        arcname = './nupack/'+k.split('/nupack/')[-1]
    tar.add(k, arcname=arcname, filter=reset)
tar.close()
