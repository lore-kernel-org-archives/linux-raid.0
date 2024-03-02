Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F36FBE
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709369476; cv=pass; b=WslHXNLAdusqbN5OfQXWzBjFPPRvOawsjVD1wPu9TeP6tV7mr6sWi4ATufOyFd41AzQnCD+BOvhImZFCbVcZF1Zr5CZmLqrDYFsHWSbv8WmhKa16rQnckusjclHzD9dPbUX8PHLRnorWQflImJIvaphyUbhjcwb916rbnR/Z/xE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709369476; c=relaxed/simple;
	bh=k2ddZ20IxTwZwckXg/oY2wQwDGj9yI8rKKin6EhCyI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S53+P2oGJzdnC+l2FiFABFxf7JcQyxuqK8PZ14gDWWTa/IRrnF8UBxyn/W9rJILIoGvVS5hYZIaBGqt5janVerklcTsf0Sfvw25Xeph+Qu87bSKtiBuxoeIYZWA08xbgvU9x62qUnbNkmWvEzpQjYP334VLU++YNbSID3FempZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=J1Px6z8M; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="J1Px6z8M"
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: tovi)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4TmzFg5V3tz49Q3D
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 10:51:03 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1709369463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZB/SdJU24r2Hq4NsrvxhtmMoivmXokY0f+HLpPrFLYQ=;
	b=J1Px6z8M8ey6D7RIhvuD2O7YuDEt5X+Rv7dQZkoiFMHBTaeHt4lYs9a16tSOe8ElMos80R
	2jwb/3FYfO1cFc3QtK/Z+yyo6bKcjG/ExpSpStdn/4c/4mn3S7ve622SqG7y6qOwkQjECt
	ym+ZNWr7frRoNVmvtCwMQGcnWFzZL0en2zJewaK46aXqwfOvAq9RFaFFTmab3/YYHx4t7f
	Sv55tGmmOBTF/U+ovMHN0D/KJPdHl6D/KH7ME3eMFBi8PTo6pNDpsnYn5HrH9lOl/y9Kn0
	AoLtYm3bkw+XmvYc2Vm3WLTwPGKwaCIKmQBDRMqDOwlMt6Ith6BBO5G6VLQoDQ==
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1709369463; a=rsa-sha256;
	cv=none;
	b=KGy8qcr+QJs/LkZDP+F0hnIPyCiRj9ICc/wuOIGy4Te9TGDsN6eb/xAiITkv7NoXvK5Mt7
	s15ZIBMr92+DIAzUZ1Brj7wYtW20SzNKPPkGWBDZgIxgrPQ07ezmB92AVyJS71eUFm5nVs
	QssItjFN2hDy58J+6rHHvK8bPZ4QlGP4f9WcI6CsldVFxvMDUHl0IHMeIS3ahBqT2iiaZd
	5XeEMGqF/9w4kg80A5HJmBwvKtLAh5cPNSI5J/r0lKJwM1PmUB88mxqkrQff2UpnR/TzIX
	riW5+IM90NoGTGqShq7O32Fjoq8u93fxApswLlwSfZCP6kvs6jbl7YlSKfOGNQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=tovi smtp.mailfrom=tovi@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1709369463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZB/SdJU24r2Hq4NsrvxhtmMoivmXokY0f+HLpPrFLYQ=;
	b=vxyQs6ZKpUJrqNJHI1+2iLharaVWFaE1oeyI20SyZmxgCapeiNQRU6q5lL4Q2dSRzQPje/
	FJBZKPJkTf+QcJmHrcIKZ+7ZhCPdi1IOUkYsH+55xLmTQOBKet34ZqnTG03TycvLOTiCs0
	Q/Dz60TmcxSPPuV2T6dEpMHCpIdo9GcfMe/7JN3e2PjOdbNkLwPqmaW1hDOJwV3tKoR/Q5
	BcVhVSC21ZGkIvQgQ6wrlJgCupnCy0B7CqYiymDk35prcP58wS/cup22z7s0Hprj/oWGeg
	wcdonRm7/oj6UPc9qFWoU6C40TrRrNQsHvtZFx4ZpMBI9nFM8G/8rRic7fO/aQ==
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e55731af5cso2385318b3a.0
        for <linux-raid@vger.kernel.org>; Sat, 02 Mar 2024 00:51:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXi2+qw2eN93+kMmyp9NHA+NDLRzchHU9NFyEPClfVdEho1bsdzEWWPTtND7IaoLzQpmOEujevQMDf3uJt3eTP2PJBHZU8oei/XgA==
X-Gm-Message-State: AOJu0Yy5fJOzUunG96SOEhdiQuoP70OWyWc9U+kgubhixf6BT9RVAZt6
	65QOLMAbRKRU5DD4cC4lPJNoQeLklQd/By/TgzzgSmfAomfw7j3+fZTeiM2OmCtFjeY6iPqA03M
	Jxg24fOIVA7ETRHwCtEo3SAz8hXI=
X-Google-Smtp-Source: AGHT+IEKeMGm2vxNOf48YI08Wn3Ja+xXym6VL3XlNTttaBTyEtc1SDaYy+ChvN42dWisIle/87MjWVh3YMreEFZIF44=
X-Received: by 2002:a05:6a20:c887:b0:1a0:e128:60ad with SMTP id
 hb7-20020a056a20c88700b001a0e12860admr3904694pzb.46.1709369461911; Sat, 02
 Mar 2024 00:51:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com> <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org>
In-Reply-To: <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org>
From: Topi Viljanen <tovi@iki.fi>
Date: Sat, 2 Mar 2024 10:50:53 +0200
X-Gmail-Original-Message-ID: <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
Message-ID: <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
Subject: Re: Requesting help with raid6 that stays inactive
To: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I have actually noticed some of those messages during the server
startup. They were something like "primary GPT missing but secondary
found -> using that".

Most likely that other system I used for testing was not just using
the secondary but overwrote the tables.

After I hopefully get the data readable again I'll create two backups
of the data and the old raid will get into bit heaven.
Then I might even try to reproduce that wrong setup and maybe play
with it a bit to see how things work.

I was able to get the order of the devices from old syslog file
(smartd) and then created the array again:

root@NAS-server:~# mdadm --create --assume-clean --level=6
--raid-devices=6 --size=3906887168 --chunk=512K --data-offset=254976s
/dev/md0 /dev/mapper/sdc /dev/mapper/sda /dev/mapper/sde
/dev/mapper/sdd /dev/mapper/sdb /dev/mapper/sdf
mdadm: partition table exists on /dev/mapper/sdc
mdadm: partition table exists on /dev/mapper/sdc but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sda
mdadm: partition table exists on /dev/mapper/sda but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sde
mdadm: partition table exists on /dev/mapper/sde but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sdd
mdadm: partition table exists on /dev/mapper/sdd but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sdb
mdadm: partition table exists on /dev/mapper/sdb but will be lost or
       meaningless after creating array
mdadm: /dev/mapper/sdf appears to be part of a raid array:
       level=raid6 devices=6 ctime=Thu May 18 22:56:47 2017
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

Running fsck caused so many errors that the mounted ext4 was empty.
I reset the overlay array and now I'm running analyze with testdisk.
It will take a long time

Thanks for the help.
Best Regards,
Topi

On Fri, 1 Mar 2024 at 20:46, Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:
>
> On 01/03/2024 at 17:27, Roger Heflin wrote:
> >
> > Do "fdisk -l /dev/sd[a-h]", given 4tb devices they are probably GPT partitions.
>
> Not "probably". "type ee" means GPT protective MBR.
>
> > Do not recreate the array, to do that you must have the correct device
> > order and all other parameters for the raid correct.
> >
> > You will also need to determine how/what created the partitions.
> > There are reports that some motherboards will "fix" disks without a
> > partition table.  if you dual boot into windows I believe it also
> > wants to "fix" it.
>
> For now there are two competing theories:
> a) if the disk has no partition table, then the BIOS creates a new
> partition table;
> b) if the disk has a backup GPT partition table but a missing or
> corrupted primary GPT partition table, then the BIOS restores the
> primary partition table from the backup partition table.
>
> Theory a) implies that even if you manage to re-create the RAID
> superblocks, they will be overwritten again at next boot. Your options are:
> - back-up the data before the next boot, re-create the RAID array in
> partitions instead of whole disks and restore tha data;
> - or back-up the data before the next boot and re-create the RAID array
> in partitions with --data-offset value set so that the data area remains
> at the same disk offset.
>
> Theory b) implies that if you manage to re-create the RAID superblocks,
> they will be overwritten again at next boot unless you also erase the
> protective MBR and primary and backup GPT partition table signatures
> with wipefs.
>
> > You should likely also read the last 2-4 weeks of this group's
> > archive.  Another guy with a very similar partition table accident
> > recovered his array and posted some about the recovery steps he
> > needed.
>
> The discussion subject was "Requesting help recovering my array" and
> started in January.
> <https://marc.info/?t=170595323800003&r=1&w=2>
>
