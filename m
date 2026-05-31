Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15731202F70
	for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780228217; cv=none; b=rRltlUi30en7WIgvg+vmLsBirqWGQRDWPjZjrxPnsVMJGNOzLrYquOuJ5TttqXsdIjojKu3qynlvqWea2r56gTQ/4IgNQaNPHi0wdUhiWfS0wVZO/Ln8izR0K/lY7avbB8sawhPXNyhS1xEi6aLhiJ0WSl54TBWC5Lvegqvo8yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780228217; c=relaxed/simple;
	bh=xNWqdsjDnRXDgZn3eZWA0CNENK8+H22wEBKqkPdd4dQ=;
	h=From:Date:Message-Id:References:In-Reply-To:To:Cc:Subject:
	 Mime-Version:Content-Type; b=A2YzQwKlxbkBDsFat62+DAM21rbHarbRFdgYWnoA6wSb/VvTIYj0j5Im5H13RMq4sIy29bCQVa5BruxdNX0kBDa0dZsS6CDucQOUwZklDMFUDBDvIorp/HT7y69775uEPkNIRWmC/5sRKfgQ/CzM/f1Rq7xj+3hQmrCukVGqv9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=D+n5pN2G; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="D+n5pN2G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780228209;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6hqPdNngo9AC3AqZI/vNVAxdL175t8PfQFvrrIHUDug=;
 b=D+n5pN2GvUfjyXjy+Ro8Oe/YelbBlTmxlZiVHqSKQBDvHBbMZGAZYBCr9PiALGNRVP6seG
 7Hs2H7kfNuh5W3rbYi3TjvHCStNHPa02hieDFqflXT/mRIQ5T6mPTlGPhzMOGip2ZqRnJm
 x6w+f5hJCubJpL27IZ+CUHgiEV6BdY/+dT7lRNyS6MxUZcKBfw/uzxp3PjIEMV8UjvYcFV
 Jy3xCteM4dLm5X9puosYct8mlvtcHU6H9FCjyQghIXcXa1+UbYk6Ew/h/s9Bfmae5OxgFk
 MZ0cvdoPB+kUQbEr8ZvKpqrcmsynFKVYTNDfMRafFE+d3/GXZ/2rjN/G0JEmTA==
From: "Yu Kuai" <yukuai@fygo.io>
Date: Sun, 31 May 2026 19:50:05 +0800
Message-Id: <0e101637-2926-401e-870c-fa6cb3704469@fygo.io>
References: <CAAiJnjpPAur30W4FO2sTZcYWc24yFafKWGR=BZWZsh2JnbrRpQ@mail.gmail.com> <5d4b72d7-7e03-463c-82a1-63adcae20344@fygo.io> <CAAiJnjoh9rTHh4gRu2=7A4C7EFP4yfBED94qmeS_ATDyB0yevQ@mail.gmail.com>
In-Reply-To: <CAAiJnjoh9rTHh4gRu2=7A4C7EFP4yfBED94qmeS_ATDyB0yevQ@mail.gmail.com>
Content-Language: en-US
To: "Anton Gavriliuk" <antosha20xx@gmail.com>
X-Lms-Return-Path: <lba+26a1c2070+231650+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.134]) by smtp.larksuite.com with ESMTPS; Sun, 31 May 2026 11:50:08 +0000
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fygo.io>
Subject: Re: --bitmap=lockless across server reboot
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/5/25 23:08, Anton Gavriliuk =E5=86=99=E9=81=93:
> Hhmm.... I just re-checked it with latest kernel (7.1-rc5) on Fedora
> Server 44, and now it works, log below.  I don't remember on which
> kernel I saw that issue (7.1-rc3 or 7.1-rc4)

If the latest kernel works well, then it's fine. llbitmap is still
under experimental stage, and there will be patches for bug fix and
features.

>
> BTW, earlier you mentioned that you are working on raid5 performance
> improvements,
>
> "=E2=80=9CBTW we're working on performance
> improvement for large raid5 arrays for at most 64 disks, results looks gr=
eat.
> However, it might take sometime before we push our work to upstream.=E2=
=80=9D
>
> Are there any progress ?, I'm very interested to test on PCIe 5.0 NVMe dr=
ives.

Yes, but we'll keep those improvements downstream for sometime. We have pla=
ns
to push them to upstream but it'll wait for about 1 or 2 years :)

>
> This is Fedora Server 44 (up to date) with compiled kernel 7.1-rc5
>
> [root@qdevice ~]# cat /etc/*release
> Fedora release 44 (Forty Four)
> NAME=3D"Fedora Linux"
> VERSION=3D"44 (Server Edition)"
> RELEASE_TYPE=3Dstable
> ID=3Dfedora
> VERSION_ID=3D44
> VERSION_CODENAME=3D""
> PRETTY_NAME=3D"Fedora Linux 44 (Server Edition)"
> ANSI_COLOR=3D"0;38;2;60;110;180"
> LOGO=3Dfedora-logo-icon
> CPE_NAME=3D"cpe:/o:fedoraproject:fedora:44"
> HOME_URL=3D"https://fedoraproject.org/"
> DOCUMENTATION_URL=3D"https://docs.fedoraproject.org/en-US/fedora/f44/"
> SUPPORT_URL=3D"https://ask.fedoraproject.org/"
> BUG_REPORT_URL=3D"https://bugzilla.redhat.com/"
> REDHAT_BUGZILLA_PRODUCT=3D"Fedora"
> REDHAT_BUGZILLA_PRODUCT_VERSION=3D44
> REDHAT_SUPPORT_PRODUCT=3D"Fedora"
> REDHAT_SUPPORT_PRODUCT_VERSION=3D44
> SUPPORT_END=3D2027-05-19
> VARIANT=3D"Server Edition"
> VARIANT_ID=3Dserver
> Fedora release 44 (Forty Four)
> Fedora release 44 (Forty Four)
> [root@qdevice ~]#
> [root@qdevice ~]# uname -a
> Linux qdevice 7.1.0-rc5 #1 SMP PREEMPT_DYNAMIC Mon May 25 15:02:20
> EEST 2026 x86_64 GNU/Linux
> [root@qdevice ~]#
> [root@qdevice mdadm]# lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
> nvme6n1     259:1    0 447.1G  0 disk
> =E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part /boot/efi
> =E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part /boot
> =E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part /
> =E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
> =E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
> nvme3n1     259:10   0   2.9T  0 disk
> nvme1n1     259:11   0   2.9T  0 disk
> nvme0n1     259:12   0   2.9T  0 disk
> nvme4n1     259:16   0   2.9T  0 disk
> nvme2n1     259:17   0   2.9T  0 disk
> nvme5n1     259:18   0   2.9T  0 disk
> [root@qdevice mdadm]#
> [root@qdevice mdadm]# mdadm --create --verbose /dev/md0 --level=3D6
> --bitmap=3Dlockless --raid-devices=3D6 /dev/nvme0n1 /dev/nvme1n1
> /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
> mdadm: Experimental lockless bitmap, use at your own risk!
> mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
> mdadm: /dev/nvme0n1 appears to be part of a raid array:
>         level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme1n1 appears to be part of a raid array:
>         level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme2n1 appears to be part of a raid array:
>         level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme3n1 appears to be part of a raid array:
>         level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme4n1 appears to be part of a raid array:
>         level=3Draid6 devices=3D5 ctime=3DWed May 20 12:45:26 2026
> mdadm: /dev/nvme5n1 appears to be part of a raid array:
>         level=3Draid6 devices=3D6 ctime=3DWed May 20 11:45:38 2026
> mdadm: size set to 3125484544K
> Continue creating array [y/N]? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> [root@qdevice mdadm]#
> [root@qdevice mdadm]# lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
> nvme6n1     259:1    0 447.1G  0 disk
> =E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
> =E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
> =E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
> =E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
> =E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
> nvme3n1     259:10   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme1n1     259:11   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme0n1     259:12   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme4n1     259:16   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme2n1     259:17   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme5n1     259:18   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> [root@qdevice mdadm]#
> [root@qdevice mdadm]# reboot
> [root@qdevice mdadm]#
>
> After reboot,
>
> [root@qdevice ~]# lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
> nvme6n1     259:1    0 447.1G  0 disk
> =E2=94=9C=E2=94=80nvme6n1p1 259:2    0     1G  0 part  /boot/efi
> =E2=94=9C=E2=94=80nvme6n1p2 259:3    0     1G  0 part  /boot
> =E2=94=9C=E2=94=80nvme6n1p3 259:4    0   220G  0 part  /
> =E2=94=9C=E2=94=80nvme6n1p4 259:5    0     1G  0 part
> =E2=94=94=E2=94=80nvme6n1p5 259:6    0   220G  0 part
> nvme2n1     259:9    0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme1n1     259:10   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme4n1     259:15   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme0n1     259:16   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme3n1     259:17   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> nvme5n1     259:18   0   2.9T  0 disk
> =E2=94=94=E2=94=80md0         9:0    0  11.6T  0 raid6
> [root@qdevice ~]#
>
>
> Anton
>
> =D0=BF=D0=BD, 25 =D0=BC=D0=B0=D1=8F 2026=E2=80=AF=D0=B3. =D0=B2 08:32, Yu=
 Kuai <yukuai@fnnas.com>:
>> Hi,
>>
>> =E5=9C=A8 2026/5/20 1:28, Anton Gavriliuk =E5=86=99=E9=81=93:
>>> Hi
>>>
>>> Does md-raid lockless bitmap support server's reboot ?
>> Yes, of course it should support reboot.
>>
>>> I don't see md-raid6 created with --bitmap=3Dlockless after reboot.
>> Do you check kernel log if there is any failure log? And do you try
>> mdadm -a manually?
>>
>> BTW, pPlease report with your environment and test script in details,
>> especially kernel version and mdadm version.
>>
>>> Anton
>>>
>> --
>> Thansk,
>> Kuai

--=20
Thansk,
Kuai
