# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/cuDNN"

SRC_URI="http://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.2-linux-x64-v7.6.5.32.tgz"

SLOT="0/7"
KEYWORDS="~amd64"
LICENSE="NVIDIA-cuDNN"
QA_PREBUILT="*"

IUSE="+cuda10-2 cuda10-1"
REQUIRED_USE="^^ ( cuda10-2 cuda10-1 )"

S="${WORKDIR}"

DEPEND="cuda10-2? ( =dev-util/nvidia-cuda-toolkit-10.2* )
	cuda10-1? ( =dev-util/nvidia-cuda-toolkit-10.1* )"
RDEPEND="${DEPEND}"

src_install() {
	insinto /opt/cuda
	doins cuda/NVIDIA_SLA_cuDNN_Support.txt

	insinto /opt/cuda/targets/x86_64-linux/include
	doins -r cuda/include/*

	insinto /opt/cuda/targets/x86_64-linux/lib
	doins -r cuda/lib*/*
}
