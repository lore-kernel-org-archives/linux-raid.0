Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE48518B47E
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726667526; cv=none; b=OhDQ1PDCyi6I0dr2Q1X99F7KaYOKuNpxTz2AGyo5BDGpFiuTaYNp5EnVbNTJAGu9PLPiKGkZqVc+sqHYeVuDCtKdNEuzQxo0QenVJlX+iS5kNT2z2xSZ34rDEsuSyiYSDUSQHYi5u8fUWl5JOChqwfwgEZwAbNcSPTyUYYTkEkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726667526; c=relaxed/simple;
	bh=xO0zrjb5pqsdBVZWjcAGs2B+R0rwBYYLP480YyV+GLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JiCTeaJg6Eih8Asj+QkYy7wF1ZrIC8KFeEElnbRGCgab9kEhdtXUeuZ5E3yHfu2m2BtGIz9wO6JEjCSYVmw6+3evnQAF29D1CAlHjrG5WXpeuaxemIj1AwitKx2pe/W25a/VahqpzToCPiBDTOekHIMKrVws3YK9mVFXq2ZY5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/N5rmIa; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/N5rmIa"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6b747f2e2b7so54677977b3.3
        for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 06:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726667524; x=1727272324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pod04VUtVBCaPWZ6yqWTH76Gqq9nGso63jeiAft+wak=;
        b=l/N5rmIa9RPWimGWw0Klfug5qEBIozSDGi/o3eik8V6UcRYXihyKgEYmYedOuT0Mrz
         ENDkJVNrwpyQlkMXNoxJbtSSHLeWSwIgRLosyiSA+bDE8OCjpYxT0CrvPWsWTFJ4HVpl
         +9bij07TadMwL6g2NzBhg+1hSpfZZQ1Cly3MiWJjC0k6vJNjDfPyGl+kPktqXeshsmEk
         LoyGI7Y+/RqIKa+pEKgHeJRW7DPjlWZVgsgAa7QMEtX9eg9uhSwGlq3tYAS69nC+DsjO
         aF+rZTMYHLhHlVnHnVCBWLMKnA94l6tsY5iDBtxtpdLEe+bdzfDKYDknXrfXU25f+2wW
         GYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726667524; x=1727272324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pod04VUtVBCaPWZ6yqWTH76Gqq9nGso63jeiAft+wak=;
        b=GCX8yfPouHTNJhS57cka3IytD9kTV4WsopkW5WDvalVlVIlAJLGYX+ev88PzbsHdAj
         9IqveXoIzsf8QKT27DcbJeiF94rVSY5kJvbTe5u5LpnQheGSGZIk5hs6VRCO3N+eECr7
         ttKWqpJmi6e77rb//sRysptAsROaT7OvnKSXfqr6VPEO0FPDvpMsgIDxzn8D5Lf4001W
         UeXA0BMfQFY5iEz+uZK0bfqDOk9gC9Mf5HG+E2t9OzleRqrY+WMG2/+Xyy4vRVZqq9eb
         8X0Pe8iprghlfeRowk8IO5OFyQWNbWAai0XgOXdt9rY55SgN/CNkLxO7WlSKyeXhs+FY
         /K7g==
X-Gm-Message-State: AOJu0YweR4wYlXexZtkeOGH3qxZrMpSN8el0A2KSi73VusXMD7msv39O
	aUy1inFCzhOqhoNoSLFtQOaopb+dNHO358RInVIt2DBBHtjOqYzQPjxXCrPW1+gfgnddmavnCm5
	3H5iv/5O6caxifG5hAx9TOU9SlEw=
X-Google-Smtp-Source: AGHT+IFqV/gsikJlNtwyy/ayVrRPvhvnAgcVQRuBkEuRu62S+FACs6LLvrIwUrXfo/hy5L2VWeYUAZbkUtppktizyGU=
X-Received: by 2002:a05:690c:b1d:b0:6db:cd39:4dae with SMTP id
 00721157ae682-6dbcd3952b6mr157950207b3.33.1726667523753; Wed, 18 Sep 2024
 06:52:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com> <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com>
In-Reply-To: <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Wed, 18 Sep 2024 08:51:52 -0500
Message-ID: <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 1:09=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:

>
> Perhaps can you try latest kernel?(6.11)
>
I'm on 6.11
>
> You should assemble the array as read-only, so that the reshape won't
> start, and you'll able to copy the data.
>
It is read only now, but it isn't mounting...
>
> Thanks,
> Kuai
>

Thank you for the suggestions. Currently I am already on kernel 6.11:

bill@bill-desk:~$ sudo uname -a
Linux bill-desk 6.11.0-061100-generic #202409151536 SMP
PREEMPT_DYNAMIC Sun Sep 15 16:01:12 UTC 2024 x86_64 x86_64 x86_64
GNU/Linux

I've noticed that sometimes when I reboot, the array automatically
assembles in read-only mode:

bill@bill-desk:~$ cat /proc/mdstat
Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid10 sdb1[1] sdd1[3] sdc1[2] sda1[0]
      15627786240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/117 pages [0KB], 65536KB chunk

md127 : active (auto-read-only) raid10 sdh1[3] sdn1[5] sdf1[1] sdk1[8]
sdg1[2] sdl1[9] sdj1[7] sdm1[4] sde1[0] sdi1[6]
      46877236224 blocks super 1.2 512K chunks 2 near-copies [10/10]
[UUUUUUUUUU]
          resync=3DPENDING
      bitmap: 0/88 pages [0KB], 262144KB chunk

unused devices: <none>

(note md1 is an unrelated array that is working just fine)

Here is my fstab file:

bill@bill-desk:~$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID=3D as a more robust way to name device=
s
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/nvme0n1p1 during installation
UUID=3D291e31b9-fe93-4ca2-a55e-925bd52e22ce /               ext4
errors=3Dremount-ro 0       1
# /boot/efi was on /dev/sda1 during installation
UUID=3D3D01-0380  /boot/efi       vfat    umask=3D0077      0       1
/swapfile                                 none            swap    sw
           0       0

# /dev/md1
UUID=3D8f645711-4d2b-42bf-877c-a8c993923a7c    /media/bill/ARRAY2
ext4    defaults,nofail    0    2

# /dev/md2
UUID=3D1c11229a-df0f-4642-b7ea-a86a31d2339e    /media/bill/ARRAY3
ext4    defaults,nofail    0    2

Note that before the reshape, the array in question was /dev/md2 but
now it is called /dev/md127. I don't know why that happened or whether
it needs to be fixed.

Here is my mdadm.conf:

bill@bill-desk:~$ cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# !NB! Run update-initramfs -u after updating this file.
# !NB! This will ensure that initramfs has an uptodate copy.
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, us=
ing
# wildcards if desired.
#DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR therealbrewer@gmail.com
MAILFROM therealbrewer@gmail.com

# definitions of existing MD arrays
ARRAY /dev/md/1  metadata=3D1.2 UUID=3D00cb57fc:23e1ccd3:af14db43:98b61d97
name=3Dbill-desk:1
ARRAY /dev/md/2  metadata=3D1.2 UUID=3D8a321996:5beb9c15:4c3fcf5b:6c8b6005
name=3Dbill-desk:2

# This configuration was auto-generated on Sun, 06 Sep 2020 17:31:04
-0500 by mkconf

Should I just try to mount md127 manually?

Thanks for the help.
Bill
