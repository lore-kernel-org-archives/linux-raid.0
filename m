Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC981386D7
	for <linux-raid@vger.kernel.org>; Wed,  3 Jul 2024 08:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994164; cv=none; b=lU7FwhBhOb15cywzIfumI+s7iIj/8O52IUTTvbEC9ov2SYwW3fi4U1Tgyg/H4J3H1yZdYfuX0M/K5XaKAnwLLRlqiDFl9pl9OUYrurpeRf7RT57j5UpF9Bh1GvW3HYkEmFjF8jKmxrYHNycPgvGzQAeOUvrsm4EfvNFee8Qq2VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994164; c=relaxed/simple;
	bh=cfarFSx2N19sMZYv/UvHpw3mR7l9DrP14k01hUzjqIY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOiyY+khID0p94yXQIVqM9hl2RhQvE0+CqCSarZfwSNzEVSrTpGoF3ASrfZfben3AliNPSIc7FWWEXE+BwJZJTN3GCIXdCJEgNzk+d945+Cmu+uP6LxuAOUWqaJNR3twK3RGxtW+TRZUUxnuxk96upQwcNfIiCfqF4eZdHtXA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EeWexKNT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EeWexKNT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719994162; x=1751530162;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cfarFSx2N19sMZYv/UvHpw3mR7l9DrP14k01hUzjqIY=;
  b=EeWexKNT6OsgD1kEUNKTsEq2PXOx9k9ek34N24BFsUEHrrWI6hBa2M6r
   ZgvXNOECbGhCJlqD33uzpc+uLp1F344IlJpfP9zZNI0r4RroxF3KlLv9f
   0BR1V6tcla3SSZ6nxixHZaCh/6KtID/fXaM4mW4Tbx3d3fNnz9NtdKPDJ
   qUtteJpODSycbn/W6rPm4OcfvT2AHI0Ounx28XmFHybNjhkvth3g5rRSq
   APMcPsr7y8WTuOcjIUCE68zE9nKLo6k60yK2NWNG2bYLHaUF2dS51a9Aj
   vRyURkuLJoqAPulpx3p8Xg2oz0/VPVBNkx7ZQpruvTmgV+RV6K2VeCRvw
   g==;
X-CSE-ConnectionGUID: nujcx7OGTsKH1RAGCcZgTw==
X-CSE-MsgGUID: CP2kyWu+QmWGJIw9LQn4aQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="20975317"
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="20975317"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 01:09:21 -0700
X-CSE-ConnectionGUID: xenGCQtERqmTbV7BtIdwWg==
X-CSE-MsgGUID: 1uUVvYnbT/2OHBwsK4RODg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="46185979"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 01:09:20 -0700
Date: Wed, 3 Jul 2024 10:09:16 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: MD: drive removal hangs with freshly created partition
Message-ID: <20240703100916.000035d8@linux.intel.com>
In-Reply-To: <5db667c7-56dc-4283-9205-9bfde1affd5d@linux.intel.com>
References: <5db667c7-56dc-4283-9205-9bfde1affd5d@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jul 2024 16:57:38 +0200
Mateusz Kusiak <mateusz.kusiak@linux.intel.com> wrote:

> Hello,
> I'm back with another regression found in SLES15SP6.
> 
> The scenario is as follows:
> 1.Create RAID 1 volume with native metadata.
> # mdadm -CR /dev/md126 -l1 -n2 /dev/nvme[0-1]n1 --assume-clean --size=5G
> 
> 2. Create partition and filesystem on raid volume.
> # parted -a optimal /dev/md126 mktable gpt mkpart primary ext4 0% 100% -s
> # mkfs.ext4 -F /dev/md126p1
> 
> 3. Remove device via "--incremental --fail".
> # mdadm -If nvme0n1
> 
> Result:
> Mdadm hangs and hung task info from mutliple components starts appearing on
> serial.
> 
> Few notes:
> * Issue does not reproduce without creating partition and filesystem.
> * If array is stopped and reassembled before step 3, the issue does not
> reproduce.
> * If partition is "reused" (metadata was cleared, new raid volume created,
> partition left in tact, no recreating partition) the issue does not reproduce.
> * If "--set-faulty" and then "--remove" used (instead of "--incremental
> --fail") "--set-faulty" succeeds, "--remove" hangs.
> * I verified this is not mdadm issue by installing mdadm-4.2 (SLES15SP6 has
> mdadm-4.3 inbox) and rerunning the test. Outcome is the same.
> * Writing "remove" to sysfs directly has same result.
> 
> Thanks,
> Mateusz
> 

More info:
As Mateusz said echo "remove" >/sys/block/md126/md/rd0/state hangs. Same hang
is observed with HOT_REMOVE_DISK ioctl. We can simulate the scenario by:

echo "faulty" >/sys/block/md126/md/rd0/state
echo "remove" >/sys/block/md126/md/rd0/state

This is really interesting that it is only happening with partitions and only
after their creation.

Mariusz
