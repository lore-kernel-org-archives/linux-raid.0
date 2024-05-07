Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97E04A07
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 07:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715067180; cv=none; b=k1uDr1CfckROAz4tvwksHhWXFrmEHjwRrJRjqLFIrem81MTfEPei6R8EW05VHbv2DyObx3jvw3tLTtJ4pr1lM3xi10xYZwy/v0TgrLUev84W8VqtxQLCfjEUVoet4D7cTKZXFb7YjirZYpTlzSQ3gEiXFmZeLJqse5E9CQnAAmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715067180; c=relaxed/simple;
	bh=shcWprw500OeCLoMIcKzK92JoDuAx9Nv4nr7rlEqP7w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IQVcUcciz7ms7WCfMNixLd4Cj7xzjVmSxDd3VNLrfbLqNIFHlQig8yGxRsSyJAlINH4YNbPdzn0QkMDr65gPjqCcv+IKqlXOjNdXvPLPeVXwNga6roqwv8/U8QVNcNIX7Jzd7VqReOoiRtqVTW9u23FWWiTWiVlSnd8V5Lq4Nio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EFKuzCR8; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EFKuzCR8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715067179; x=1746603179;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=shcWprw500OeCLoMIcKzK92JoDuAx9Nv4nr7rlEqP7w=;
  b=EFKuzCR8Bnua4F35kO5yWF04g62CCtvYhgYi09RWALEixmrVyKICmL5C
   vr8A0AEE4HFxfa17q3ANGAKuCQ/L/h6qJX81pVbIA6bjjxOQf/HkGcJe4
   YIQRHxWjXwAqt93fyv7ELXjz7Rl01QFlMG6UIfRXQuvCJYsig1MXZl4Qz
   21hdzwlMKt93Ma84QsC6O5HIrip5GO6R0MXixe9PZ6PsvWBWOKzYWxA6A
   Mcc6fxx6ESRTfHDe0e/DBM6MvUv3QAFCdMbCUUOQZW0Kg5Rw37pn5WMUh
   vskJ62l+Tj2JwzgrNEspVXXBU+bWHzr/iKXL2QQ8Wa7brWdjQ+az/jNQN
   Q==;
X-CSE-ConnectionGUID: LK62ELV6RyOYMDZxgG+oDQ==
X-CSE-MsgGUID: rZ6WmR/5RJ6hx2I8ynh8kg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21452528"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="21452528"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 00:32:59 -0700
X-CSE-ConnectionGUID: waAK2KdGTVinJIEtUcndiw==
X-CSE-MsgGUID: H09MnyB3RXqEoJaj0gOytg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="32940801"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 00:32:56 -0700
Date: Tue, 7 May 2024 09:32:52 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Sven =?ISO-8859-1?Q?K=F6hler?= <sven.koehler@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: regression: drive was detected as raid member due to metadata
 on partition
Message-ID: <20240507093252.000032c2@linux.intel.com>
In-Reply-To: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Apr 2024 01:31:35 +0200
Sven K=F6hler <sven.koehler@gmail.com> wrote:

> I strongly believe that mdadm should ignore any metadata - regardless of=
=20
> the version - that is at a location owned by any of the partitions.=20

That would require mdadm to understand gpt parttable, not only clone it.
We have gpt support to clone the gpt metadata( see super-gpt.c).
It should save us from such issues so you have my ack if you want to do thi=
s.

But... GPT should have secondary header located at the end of the device, so
your metadata should be not at the end. Are you using gpt or mbr parttable?
Maybe missing secondary gpt header is the reason?

> While I'm not 100% sure how to implement that, the following might also=20
> work: first scan the partitions for metadata, then ignore if the parent=20
> device has metadata with a UUID previously found.

No, it is not an option. In udev world, you should only operate on device y=
ou
are processing so we should avoid referencing the system.

BTW. To avoid this issue you can left few bytes empty at the end of disk, s=
imply
make your last partition ended few bytes before end of the drive. With that
metadata will not be recognized directly on the drive. That is at least wha=
t I
expected but I'm not native experienced so please be aware of that.

> I did the right thing and converted my RAID arrays to metadata 1.2, but=20
> I'd like to save other from the adrenaline shock.

There are reasons why we introduced v1.2 located at the begging of device.
You can try to fix it but I think that you should just follow upstream and
choose 1.2 if you can.

As we are more and more with 1.2 that naturally we care less about 0.9,
especially of workarounds in other utilities. We cannot control
if legacy workarounds are still there (the root cause of this change may be
outside md/mdadm, you never know :)).

So the cases like that will always come. It is right to use 1.2 now to be
better supported if you don't have strong need to stay with 0.9.

Anyway, patches are always welcomed!
Thanks,
Mariusz

