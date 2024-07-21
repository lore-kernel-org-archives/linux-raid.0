Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657FB3A27E;
	Sun, 21 Jul 2024 10:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721557455; cv=none; b=EdWeDAPnaBcd1sp79fSsEr06RhtDYRCc+FMPEvL/Sy3t2g2fhQb75CbI2FBYgmRRDYQUdkbSBvAPfnqObRaZU6FXArotww7mRjziYok/sBzFssrZfMEWaQv2uzy5Kzp3+/fAjlK/3H0UBhARrx/XXJ0YX3KVpAKOjCJHhUD35PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721557455; c=relaxed/simple;
	bh=moEL5S8mb0PQ+V3UlseN5LdvumbantrKaGzuZ0Y7VQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EO3HcisGpFZMp8XC20yuKudFXEn7+qSIKZqzGZdVEya7tCcTsELnZHwu9k6MCoHSdUR1pgfkkatQ6ZsTL9/nd5LrfwxjD5yb+tYECdJKyZ62r9bQj4t7SVGIge+avjITIUqfVVDHZ/cetgnFgtQa5aUpDj79ZymCNILN6rf+Fys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.4] (ip5f5af54b.dynamic.kabel-deutschland.de [95.90.245.75])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5782061E5FE05;
	Sun, 21 Jul 2024 12:23:31 +0200 (CEST)
Message-ID: <8aac874e-f4f5-40a6-9e3c-1c88a8c49378@molgen.mpg.de>
Date: Sun, 21 Jul 2024 12:23:30 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH blktests v4 2/2] md: add regression test for
 "md/md-bitmap: fix writing non bitmap pages"
To: Ofir Gal <ofir.gal@volumez.com>
Cc: shinichiro.kawasaki@wdc.com, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, dwagner@suse.de, chaitanyak@nvidia.com,
 yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <20240721071121.1929422-1-ofir.gal@volumez.com>
 <20240721071121.1929422-3-ofir.gal@volumez.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240721071121.1929422-3-ofir.gal@volumez.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Ofir,


Thank you very much for submitting a test case.

Am 21.07.24 um 09:11 schrieb Ofir Gal:
> A bug in md-bitmap has been discovered by setting up a md raid on top of
> nvme-tcp devices that has optimal io size larger than the allocated
> bitmap.
> 
> The following test reproduce the bug by setting up a md-raid on top of

reproduce*s*

> nvme-tcp device over ram device that sets the optimal io size by using
> dm-stripe.

For people ignorant of the test infrastructure, maybe add a line how to 
run this one test, and maybe even paste the output of the failed test.


Kind regards,

Paul


> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> ---
>   common/brd       | 28 ++++++++++++++++
>   tests/md/001     | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/md/001.out |  3 ++
>   tests/md/rc      | 13 ++++++++
>   4 files changed, 130 insertions(+)
>   create mode 100644 common/brd
>   create mode 100755 tests/md/001
>   create mode 100644 tests/md/001.out
>   create mode 100644 tests/md/rc
> 
> diff --git a/common/brd b/common/brd
> new file mode 100644
> index 0000000..31e964f
> --- /dev/null
> +++ b/common/brd
> @@ -0,0 +1,28 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2024 Ofir Gal
> +#
> +# brd helper functions
> +
> +. common/shellcheck
> +
> +_have_brd() {
> +	_have_module brd
> +}
> +
> +_init_brd() {
> +	# _have_brd loads brd, we need to wait a bit for brd to be not in use in
> +	# order to reload it
> +	sleep 0.2
> +
> +	if ! modprobe -r brd || ! modprobe brd "$@" ; then
> +		echo "failed to reload brd with args: $*"
> +		return 1
> +	fi
> +
> +	return 0
> +}
> +
> +_cleanup_brd() {
> +	modprobe -r brd
> +}
> diff --git a/tests/md/001 b/tests/md/001
> new file mode 100755
> index 0000000..5c8c59a
> --- /dev/null
> +++ b/tests/md/001
> @@ -0,0 +1,86 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2024 Ofir Gal
> +#
> +# The bug is "visible" only when the underlying device of the raid is a network
> +# block device that utilize MSG_SPLICE_PAGES. nvme-tcp is used as the network device.
> +#
> +# Regression test for patch "md/md-bitmap: fix writing non bitmap pages" and
> +# for patch "nvme-tcp: use sendpages_ok() instead of sendpage_ok()"
> +
> +. tests/md/rc
> +. common/brd
> +. common/nvme
> +
> +DESCRIPTION="Raid with bitmap on tcp nvmet with opt-io-size over bitmap size"
> +QUICK=1
> +
> +#restrict test to nvme-tcp only
> +nvme_trtype=tcp
> +nvmet_blkdev_type="device"
> +
> +requires() {
> +	# Require dm-stripe
> +	_have_program dmsetup
> +	_have_driver dm-mod
> +	_have_driver raid1
> +
> +	_require_nvme_trtype tcp
> +	_have_brd
> +}
> +
> +# Sets up a brd device of 1G with optimal-io-size of 256K
> +setup_underlying_device() {
> +	if ! _init_brd rd_size=1048576 rd_nr=1; then
> +		return 1
> +	fi
> +
> +	dmsetup create ram0_big_optio --table \
> +		"0 $(blockdev --getsz /dev/ram0) striped 1 512 /dev/ram0 0"
> +}
> +
> +cleanup_underlying_device() {
> +	dmsetup remove ram0_big_optio
> +	_cleanup_brd
> +}
> +
> +# Sets up a local host nvme over tcp
> +setup_nvme_over_tcp() {
> +	_setup_nvmet
> +
> +	local port
> +	port="$(_create_nvmet_port "${nvme_trtype}")"
> +
> +	_create_nvmet_subsystem "${def_subsysnqn}" "/dev/mapper/ram0_big_optio" "${def_subsys_uuid}"
> +	_add_nvmet_subsys_to_port "${port}" "${def_subsysnqn}"
> +
> +	_create_nvmet_host "${def_subsysnqn}" "${def_hostnqn}"
> +
> +	_nvme_connect_subsys
> +}
> +
> +cleanup_nvme_over_tcp() {
> +	_nvme_disconnect_subsys
> +	_nvmet_target_cleanup --subsysnqn "${def_subsysnqn}"
> +}
> +
> +test() {
> +	echo "Running ${TEST_NAME}"
> +
> +	setup_underlying_device
> +	setup_nvme_over_tcp
> +
> +	local ns
> +	ns=$(_find_nvme_ns "${def_subsys_uuid}")
> +
> +	# Hangs here without the fix
> +	mdadm --quiet --create /dev/md/blktests_md --level=1 --bitmap=internal \
> +		--bitmap-chunk=1024K --assume-clean --run --raid-devices=2 \
> +		/dev/"${ns}" missing
> +
> +	mdadm --quiet --stop /dev/md/blktests_md
> +	cleanup_nvme_over_tcp
> +	cleanup_underlying_device
> +
> +	echo "Test complete"
> +}
> diff --git a/tests/md/001.out b/tests/md/001.out
> new file mode 100644
> index 0000000..23071ec
> --- /dev/null
> +++ b/tests/md/001.out
> @@ -0,0 +1,3 @@
> +Running md/001
> +disconnected 1 controller(s)
> +Test complete
> diff --git a/tests/md/rc b/tests/md/rc
> new file mode 100644
> index 0000000..96bcd97
> --- /dev/null
> +++ b/tests/md/rc
> @@ -0,0 +1,13 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2024 Ofir Gal
> +#
> +# Tests for md raid
> +
> +. common/rc
> +
> +group_requires() {
> +	_have_root
> +	_have_program mdadm
> +	_have_driver md-mod
> +}
