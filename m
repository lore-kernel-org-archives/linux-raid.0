Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8552AF4E3
	for <linux-raid@vger.kernel.org>; Thu, 28 Dec 2023 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TS/IUFYY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703775168; x=1735311168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ihlio8ttL5GJWE3GjPFxvPKBAByWA9lL1mrihrI6lTI=;
  b=TS/IUFYYsf9jZHGVzVJTpvaQMSTHV+dQWv4+toNKel0gnJ/5EJ9wXg4I
   n5RPGl2pLBUt4CcW/+W4ROysE3RHBZaUcxnzREHRYIv/w/d0dpZCj3O8c
   us/tOUSYitqbUXhGCiSyQi0OB/DZWP4K3BBqN3PvMgmNnoV6mChow3UVc
   ZjR85WoA3zDiCRt7Z36nqNtVni37xS2yrFobOyXH+ygf3P2haJK2Qy1j0
   1AAwmbL3Rngncjv6DkLeGjwdrpWG9N1AVW9HBGPEXC8IsebbaDwabGyoB
   ZNb+njJ7GTBlVH8Pl/V1RBUF0LXhZBnxe0aaBmEpXkigPWGqHdSJHSboq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="3349202"
X-IronPort-AV: E=Sophos;i="6.04,312,1695711600"; 
   d="scan'208";a="3349202"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 06:52:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10936"; a="754750186"
X-IronPort-AV: E=Sophos;i="6.04,312,1695711600"; 
   d="scan'208";a="754750186"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.213.30.67]) ([10.213.30.67])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 06:52:45 -0800
Message-ID: <b6fbcd89-fa46-4b7c-a495-d0c87cf491f0@linux.intel.com>
Date: Thu, 28 Dec 2023 15:52:43 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mdadm] tests: Gate tests for linear flavor with variable
 LINEAR
Content-Language: pl, en-US
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org
References: <20231221013914.3108026-1-song@kernel.org>
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
In-Reply-To: <20231221013914.3108026-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.12.2023 02:39, Song Liu wrote:

> linear flavor is being removed in the kernel [1], so tests for the linear
> flavor will fail. Gate tests for linear flavor with LINEAR=yes, so that we
> can still run these tests for older kernels.
>
> [1] https://lore.kernel.org/linux-raid/20231214222107.2016042-1-song@kernel.org/
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   tests/00linear     | 5 +++++
>   tests/00names      | 8 +++++++-
>   tests/00raid0      | 4 ++++
>   tests/00readonly   | 8 +++++++-
>   tests/02lineargrow | 5 +++++
>   tests/03assem-incr | 8 +++++++-
>   tests/03r0assem    | 4 ++++
>   tests/04r0update   | 6 ++++++
>   8 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/tests/00linear b/tests/00linear
> index e3ac6555c9dd..5a1160851af2 100644
> --- a/tests/00linear
> +++ b/tests/00linear
> @@ -1,6 +1,11 @@
>   
>   # create a simple linear
>   
> +if [ "$LINEAR" != "yes" ]; then
> +  echo -ne 'skipping... '
> +  exit 0
> +fi
> +
>   mdadm -CR $md0 -l linear -n3 $dev0 $dev1 $dev2
>   check linear
>   testdev $md0 3 $mdsize2_l 1
> diff --git a/tests/00names b/tests/00names
> index 7a066d8fb2b7..d996befc5e8b 100644
> --- a/tests/00names
> +++ b/tests/00names
> @@ -4,7 +4,13 @@ set -x -e
>   conf=$targetdir/mdadm.conf
>   echo "CREATE names=yes" > $conf
>   
> -for i in linear raid0 raid1 raid4 raid5 raid6
> +levels=(raid0 raid1 raid4 raid5 raid6)
> +
> +if [ "$LINEAR" == "yes" ]; then
> +  levels+=( linear )
> +fi
> +
> +for i in ${levels[@]}
>   do
>     mdadm -CR --config $conf /dev/md/$i -l $i -n 4 $dev4 $dev3 $dev2 $dev1
>     check $i
> diff --git a/tests/00raid0 b/tests/00raid0
> index 9b8896cbdc52..6407c320fd65 100644
> --- a/tests/00raid0
> +++ b/tests/00raid0
> @@ -16,6 +16,10 @@ check raid0
>   testdev $md0 5 $size 512
>   mdadm -S $md0
>   
> +if [ "$LINEAR" != "yes" ]; then
> +  echo -ne 'skipping... '
> +  exit 0
> +fi
>   
>   # now same again with different chunk size
>   for chunk in 4 32 256
> diff --git a/tests/00readonly b/tests/00readonly
> index afe243b3a0b0..80b63629e4f9 100644
> --- a/tests/00readonly
> +++ b/tests/00readonly
> @@ -1,8 +1,14 @@
>   #!/bin/bash
>   
> +levels=(raid0 raid1 raid4 raid5 raid6 raid10)
> +
> +if [ "$LINEAR" == "yes" ]; then
> +  levels+=( linear )
> +fi
> +
>   for metadata in 0.9 1.0 1.1 1.2
>   do
> -	for level in linear raid0 raid1 raid4 raid5 raid6 raid10
> +	for level in ${levels[@]}
>   	do
>   		if [[ $metadata == "0.9" && $level == "raid0" ]];
>   		then
> diff --git a/tests/02lineargrow b/tests/02lineargrow
> index 595bf9f20802..d17e2326d13f 100644
> --- a/tests/02lineargrow
> +++ b/tests/02lineargrow
> @@ -1,6 +1,11 @@
>   
>   # create a liner array, and add more drives to to.
>   
> +if [ "$LINEAR" != "yes" ]; then
> +  echo -ne 'skipping... '
> +  exit 0
> +fi
> +
>   for e in 0.90 1 1.1 1.2
>   do
>     case $e in
> diff --git a/tests/03assem-incr b/tests/03assem-incr
> index f10a1a48ee5c..38880a7fed10 100644
> --- a/tests/03assem-incr
> +++ b/tests/03assem-incr
> @@ -6,7 +6,13 @@ set -x -e
>   # Here just test that a partly "-I" assembled array can
>   # be completed with "-A"
>   
> -for l in 0 1 5 linear
> +levels=(raid0 raid1 raid5)
> +
> +if [ "$LINEAR" == "yes" ]; then
> +  levels+=( linear )
> +fi
> +
> +for l in ${levels[@]}
>   do
>     mdadm -CR $md0 -l $l -n5 $dev0 $dev1 $dev2 $dev3 $dev4 --assume-clean
>     mdadm -S md0
> diff --git a/tests/03r0assem b/tests/03r0assem
> index 44df06456233..f7c29e8c1ab6 100644
> --- a/tests/03r0assem
> +++ b/tests/03r0assem
> @@ -64,6 +64,10 @@ mdadm --assemble --scan --config=$conf $md2
>   $tst
>   mdadm -S $md2
>   
> +if [ "$LINEAR" != "yes" ]; then
> +  echo -ne 'skipping... '
> +  exit 0
> +fi
>   
>   ### Now for version 0...
>   
> diff --git a/tests/04r0update b/tests/04r0update
> index b95efb06c761..c495f34a0a79 100644
> --- a/tests/04r0update
> +++ b/tests/04r0update
> @@ -1,5 +1,11 @@
>   
>   # create a raid0, re-assemble with a different super-minor
> +
> +if [ "$LINEAR" != "yes" ]; then
> +  echo -ne 'skipping... '
> +  exit 0
> +fi
> +
>   mdadm -CR -e 0.90 $md0 -llinear -n3 $dev0 $dev1 $dev2
>   testdev $md0 3 $mdsize0 1
>   minor1=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
Hi Song, this approach looks a bit dirty to me as it's omitting what's 
already in the test suite. I would prefer adding additional param rather 
than setting environment variable, so test execution flow stays unified 
(as far as I'm aware we do not use flags for now). Adding param is also 
a good excuse to explain why linear is not tested by default in "--help".

Another thing is "--raidtype=linear" option, is probably redundant now.

Thanks, Mateusz

