Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB252E093F
	for <linux-raid@vger.kernel.org>; Wed, 30 Jul 2025 17:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753898215; cv=none; b=Dk4nyrGASo9zreP/YdT4+XU9yn2XFwZb/dgtqYGmhYMgtGxp5fcUonPFB9N84cRFT1rUNTtwPGAq0Y7BnWA6XxudNlNm3JlP71QBZbIIkPUZq2p4siXWgwr7iWsB9lzWT+1AIpZRssFaajHSgud+R2Fu/Mx/jpt43qpiKzr9PcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753898215; c=relaxed/simple;
	bh=Mp6dXqgKAJBETRJ1mEYNmav6dGnuTL111q2o7kQBkTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3vqCLPV5IEKc/yuOoZkTYGDOxwos3bOyYgkvAu2B03Fdsz4jBoezNE0eIkUol0JRqfxeeH3ptDBz1lJUq4hT2LhYmtQFfSvi9lvFTX+d9sDjdp8me71viJn+WHYJJN7I2VTv1TlCPLBKG0BzQ+Dkt+9QLsSUhVF1kjxGNlSxpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwEfFCcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwEfFCcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB7BC4CEEB;
	Wed, 30 Jul 2025 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753898215;
	bh=Mp6dXqgKAJBETRJ1mEYNmav6dGnuTL111q2o7kQBkTs=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JwEfFCcSIfVR3Ce+yuZeI39oJCPE2doNXkH/26fZjeQ5L9Y4+1YZkAglzj2EHto7D
	 OJZmdPAJn6iUB+rMFQfcaFrm6tJ9KA4nI0/VFit1gmp4qI3TCeDinWa4dArzul9vPk
	 HFV0gLybrxt089UK4hkxOJY3iv1C/4oKaQ/MnI2HzRFZC1lN2Up/LBw/EO+Swk5XKl
	 w0KNIt747b+5CCOT1DWlxu/rOu9Mk7K3wwlS84vSBc3+w7E8FRM4loBUI1t/H3AyfE
	 4mJz9vYnoEcInbrbX5V/07CxpJ3wCJsLcBYGxD19QyiXBTrhU2QO2LTC6OuhT/3CCp
	 fE2vNhLce5I8Q==
Message-ID: <89714c42-fe6e-4251-b148-387285044185@kernel.org>
Date: Thu, 31 Jul 2025 01:56:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH] md/md-cluster: handle REMOVE message earlier
To: Heming Zhao <heming.zhao@suse.com>, song@kernel.org,
 yukuai1@huaweicloud.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org
References: <20250728042145.9989-1-heming.zhao@suse.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250728042145.9989-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/7/28 12:21, Heming Zhao 写道:
> Commit a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for
> HOT_REMOVE_DISK ioctl") introduced a regression in the md_cluster
> module. (Failed cases 02r1_Manage_re-add & 02r10_Manage_re-add)
>
> Consider a 2-node cluster:
> - node1 set faulty & remove command on a disk.
> - node2 must correctly update the array metadata.
>
> Before a1fd37f97808, on node1, the delay between msg:METADATA_UPDATED
> (triggered by faulty) and msg:REMOVE was sufficient for node2 to
> reload the disk info (written by node1).
> After a1fd37f97808, node1 no longer waits between faulty and remove,
> causing it to send msg:REMOVE while node2 is still reloading disk info.
> This often results in node2 failing to remove the faulty disk.
>
> == how to trigger ==
>
> set up a 2-node cluster (node1 & node2) with disks vdc & vdd.
>
> on node1:
> mdadm -CR /dev/md0 -l1 -b clustered -n2 /dev/vdc /dev/vdd --assume-clean
> ssh node2-ip mdadm -A /dev/md0 /dev/vdc /dev/vdd
> mdadm --manage /dev/md0 --fail /dev/vdc --remove /dev/vdc
>
> check array status on both nodes with "mdadm -D /dev/md0".
> node1 output:
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         1     254       48        1      active sync   /dev/vdd
> node2 output:
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         1     254       48        1      active sync   /dev/vdd
>
>         0     254       32        -      faulty   /dev/vdc
>
> Fixes: a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl")
> Signed-off-by: Heming Zhao<heming.zhao@suse.com>
> ---
>   drivers/md/md.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
Applied to md-6.17
Thanks
