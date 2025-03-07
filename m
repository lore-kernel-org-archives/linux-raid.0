Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9D29408
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 01:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741310879; cv=none; b=CQlzRGctHSrsmMltogBBSrQWkTs7BFfJRiwqZOmcMMbNNnawLyNZfktf1o/jEDyvPl0VdARuSe8/Z6NMaH5NzkD0MSkMmuQNrmxGb/3mgOCQncXibVE/LZnfjtxN0JS+RxUrBIVJEDsDvOzcmZvmJxLFuAae+BZNoqthq7bOohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741310879; c=relaxed/simple;
	bh=iQUVLvFp7oDs2oJP613vtgLYAzX1gCQ2kyzJjdGZ0DQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QQ4PlPmoOeYT+TzWaMOnZ4ECBVJmHQlwqDCXHOyAB3DKSxvLRdd6mdjtwK4QEyn1Q0sBZg8b1NlPgp/nZ298H0KxGH6esRNodb4HeaYF+RFQR2WN48aId6hjNb+6vfpIQz6UaHgEoJhJznZO2O72mlufBqIIB97myLsGTWgmxkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EqzanlJ0; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EqzanlJ0"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3cfc79a8a95so4146935ab.2
        for <linux-raid@vger.kernel.org>; Thu, 06 Mar 2025 17:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741310876; x=1741915676; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B31HlszMqijJvAJtEC2IzgjdmhJOekO+iWOqYQZ5fuE=;
        b=EqzanlJ0lqta26d6KMTtOpfK1gyX40L525o5lSpY3r70Q0F0PB2tzQqJUC+mFH6rbB
         am+xeAd93Gp9QhJYCC4lNtoC34j4r3O36b5BhFVLQIgpM6XbD309iy61Y48u3330vpg2
         1lurkgKnZRzcbdPqEXYxCFuYDnNjUIAcCnzc03N3182feHEbFuWJ3/EXXtzNNN/zLNbe
         C60dna4JIc0Kw6GKKYD0CQBjxSuF50dRcQ4XGq4/omZvvv7d66ljGEg9RZWp8GLINKIg
         vXKCRyx2QH6AEhMUJUFjGaQAYUIfZXvpZxixBw278tjpN+BfuuoLLO4wdW34QcsVcre8
         Dw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741310876; x=1741915676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B31HlszMqijJvAJtEC2IzgjdmhJOekO+iWOqYQZ5fuE=;
        b=gPHQ7K4KtJooGIW6LnCbgDWQBYtznhGZy8lwnk0ReWOO+fqZV4S9Gtngm+uMNXMBF/
         CFRku/InRqmLKEoKt1wDyyxaYQgKQ5Rs4tCut9C55tdYnfMJcRZigGo9MH/GUV6IBbzG
         E0BtCkKPuT9N2gFs6fncNIC2TLTDhs9eQGbtiwN684ArkHeAlf6GeoYhy9tDySXHTUQK
         1WxE1V7wWXU5ERYVy0uqeNrp1BtxEMiY6c2GebXb/nf+9KtjECQBqHQI7FriyBQ8nTLq
         eisea2+f28Z8OGe2FMHGDsqxWFYCEZowrRZkNgwECBcghL16EiOUYKOEijphn3HHlMmV
         +aWA==
X-Gm-Message-State: AOJu0Yzt2GFOvHbyHGYdmS5zgvtG3Bkq2Da7WkiFog59nyRBCfvB4H2J
	nZpLFNzzVN1Oi5em3YXwHLza54adSxQDlxd6UjO3iNC4rSaQIszvM1sw30BUWYiHEsIBQSZMrCl
	Prh4CCFFfG+sMZw6sdLWJgs4ZBtVSgbPs
X-Gm-Gg: ASbGnctlCPJ0UrFqQi6xGoAish7mD5FjkH6Zdt+KcGBc7pjfSdhBwTI7TFav5GTrDPT
	SzWXli9kuKD5eNayZfyYrlaGbF3FAgIaPejLFGvRH0xQennkNGjjmgZiJ4yc74cvGi7KU7Y/AtL
	Twf8Lr3QuWYeeF38qla+a9aKcM
X-Google-Smtp-Source: AGHT+IFufaBeiFHJIQ8H3KNbbtAhMc+nHXc9oETDVp66YcYlYDj0GIJDms1Qo2dbOUAkUu27Dh0extNyjj7awAor+uI=
X-Received: by 2002:a05:6e02:2146:b0:3d4:3d8c:d5b4 with SMTP id
 e9e14a558f8ab-3d4419e696dmr19810675ab.11.1741310876191; Thu, 06 Mar 2025
 17:27:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
In-Reply-To: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 6 Mar 2025 19:27:45 -0600
X-Gm-Features: AQ5f1Jrbv3uYCnO2qzS0f13aX6jeFhQXvW4geu_GPZ15lb8Ej3rMnS-9sSmOZag
Message-ID: <CAAMCDefYhzMxbn8D2CAQ-XtsmykPPLsL8sjt-e0tF2QDMy=Y1A@mail.gmail.com>
Subject: Re: Need to understand error messages
To: eyal@eyal.emu.id.au
Cc: Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That is the report uncorrectable error coming back to the OS.   ie
sense key: medium error.

It looks like you had a few commands lined up (the tags) and one io
hung (2888) and eventually failed (bad sector) but it took long enough
that  is timed out on all of the other IO behind it (the SOFT_ERROR).

The scsi layer should have retried the SOFT ones I would think.

You might want to check to see what smartctl -l scterc says the disks
timeout is and what the OS level scsi timeout is.  I set the disk
timeouts as low as the disk will allow and leave my OS timeouts
default (30 sec typically).

I would have though there would be a md rewrite.  It will look like this:

Feb 16 13:44:16 bm-server kernel: mpt2sas_cm0: log_info(0x31080000):
originator(PL), code(0x08), sub_code(0x0000)
Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 FAILED
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 Sense Key
: Medium Error [current] [descriptor]
Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 Add.
Sense: Unrecovered read error
Feb 16 13:44:16 bm-server kernel: sd 6:0:1:0: [sdf] tag#923 CDB:
Read(16) 88 00 00 00 00 01 5d 47 6b 08 00 00 00 f8 00 00
Feb 16 13:44:16 bm-server kernel: critical medium error, dev sdf,
sector 5859928904 op 0x0:(READ) flags 0x0 phys_seg 23 prio class 0
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866416 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866424 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866432 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866440 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866448 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866312 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866320 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866328 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866336 on sdf6)
Feb 16 13:44:16 bm-server kernel: md/raid:md16: read error corrected
(8 sectors at 1445866344 on sdf6)F


On Thu, Mar 6, 2025 at 6:38=E2=80=AFPM Eyal Lebedinsky <eyal@eyal.emu.id.au=
> wrote:
>
> I am on fedora 40 with
>         Linux e7.eyal.emu.id.au 6.13.5-100.fc40.x86_64 #1 SMP PREEMPT_DYN=
AMIC Thu Feb 27 15:10:07 UTC 2025 x86_64 GNU/Linux
>
> It seems that there was an issue with a disk [sdg] which is part of a 7-d=
isk raid6. OK. See messages at the bottom.
>
> I want to know what those mpt2sas_cm0 messages are.
> I think that they come from the raid controller (LSI SAS9211 8i, in non-r=
aid mode).
> Q) I see 9 messages, then 9 I/O errors. Are the two numbers related?
> After the errors I note that smart shows:
>           5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    48
>         187 Reported_Uncorrect      -O--CK   099   099   000    -    1
> These are new (were 0).
>
> BTW, at this time (5:10AM) my system collects some stats which include "m=
dadm --misc --{query,detail,examine}".
> Q) May this be related?
>
> Q) Noting the very low sector numbers, I wonder which area they are in (s=
ee --examine below).
>
> You then can see a single such message later at night without any I/O err=
or. smart attributes did not change then.
>
> Looking at the system log I can see such messages from time to time.
> Q) Do these messages indicate that the controller encountered a problem w=
hich it resolved?
> Q) I saw no md messages, so I assumed that they never propagated to this =
layer.
>
> TIA,
>         Eyal
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D supporting info =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2889 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2889 CDB: Read(16=
) 88 00 00 00 00 00 00 00 24 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 9224 op 0x0:=
(READ) flags 0x80700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2890 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2890 CDB: Read(16=
) 88 00 00 00 00 00 00 00 28 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 10248 op 0x0=
:(READ) flags 0x84700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2891 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2891 CDB: Read(16=
) 88 00 00 00 00 00 00 00 2c 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 11272 op 0x0=
:(READ) flags 0x80700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2892 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2892 CDB: Read(16=
) 88 00 00 00 00 00 00 00 30 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 12296 op 0x0=
:(READ) flags 0x84700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2893 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2893 CDB: Read(16=
) 88 00 00 00 00 00 00 00 34 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 13320 op 0x0=
:(READ) flags 0x80700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2894 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2894 CDB: Read(16=
) 88 00 00 00 00 00 00 00 38 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 14344 op 0x0=
:(READ) flags 0x84700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2895 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2895 CDB: Read(16=
) 88 00 00 00 00 00 00 00 3c 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 15368 op 0x0=
:(READ) flags 0x80700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2896 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2896 CDB: Read(16=
) 88 00 00 00 00 00 00 00 40 08 00 00 04 00 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 16392 op 0x0=
:(READ) flags 0x84700 phys_seg 128 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2897 FAILED Resul=
t: hostbyte=3DDID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2897 CDB: Read(16=
) 88 00 00 00 00 00 00 00 44 08 00 00 02 18 00 00
> 2025-03-06T05:10:10+11:00 kernel: I/O error, dev sdg, sector 17416 op 0x0=
:(READ) flags 0x80700 phys_seg 67 prio class 2
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 FAILED Resul=
t: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D6s
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 Sense Key : =
Medium Error [current]
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 Add. Sense: =
Unrecovered read error
> 2025-03-06T05:10:10+11:00 kernel: sd 6:0:5:0: [sdg] tag#2888 CDB: Read(16=
) 88 00 00 00 00 00 00 00 20 08 00 00 04 00 00 00
>
> 2025-03-06T22:53:50+11:00 kernel: mpt2sas_cm0: log_info(0x31080000): orig=
inator(PL), code(0x08), sub_code(0x0000)
>
> $ sudo mdadm --misc --examine /dev/sdg1
> /dev/sdg1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
>
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D262064 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : b1732c74:a34e121d:8347018e:c42b5085
>
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Fri Mar  7 10:19:13 2025
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : f201a5c9 - correct
>           Events : 5156938
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>     Device Role : Active device 5
>     Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
>
