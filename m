Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B815B1ACEBF
	for <linux-raid@vger.kernel.org>; Tue, 28 Jan 2025 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738077670; cv=none; b=mAE29dhzNtVKA0CxH62oNvwrLAgmvUPTpTAkpyAZhedVQSbQsX45/Lm5/XY7YljmufIJX0J0D+Xz1jyLFDCuxKMwPjCPcrJ3vtl4nLIIJrycpp1enDQTpuvE1ewS64dskE9CEOolVkJpgGbIkfxFwTh/lQ1CDhj4U9xqNHfooL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738077670; c=relaxed/simple;
	bh=0GJ+8BG95Gq5afqlMNXT2V0QF6zSWpm6IvKwGUZ/azY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tjsbWuXRyIYUSTDYNGjoPQ1L7h8ZHSt/C6IwapXgtTJwrS50XPcshB96zDV1FfCBSMClsFnWLWTArKkT0EGKvfdY+YgAkwSiL50i6Miv/VHYxdrrdenMJb4l9MYyXwU7x8G6M9RjZoisMv95OnCK1FGPy3jbhOO0kUrmBR9fKM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U18Ne5WV; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U18Ne5WV"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e549dd7201cso10421521276.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Jan 2025 07:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738077667; x=1738682467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUBc9kfVU8hBFhr/ip/EIM2/FW7GPu6ZEoW3UYjC9bY=;
        b=U18Ne5WVhfqO+D7hDN4+h+oMAQb8fGe0uEgiv2EdXpljJ2w4LrIW/9I+UH+xP+QqXc
         Pas9P0aS6MGF84W+T/dLXeY+r0T5PH+sh/KCNvcAe8pl5GlhK8rSQfPACVyFYfIlhxcr
         DpE7k/xNsmBne/cg+Pv03Sd0mLX6oRY7v6e9UCzPIxj1pZDX1awCb/jN6nGBt2PTQLHD
         llgB0UxSIFIBHfnFVHLZt3v9oQgESuh+J96tFPwOCRahJdSwzKwygpGx2tOr7d+q+H/N
         s4dpUdtst/ef53HvKs3wdLOhXwnKCnqihmGplG6ET4HV38s7YUq1SFgnMj3ftJ79p8Y/
         GPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738077667; x=1738682467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUBc9kfVU8hBFhr/ip/EIM2/FW7GPu6ZEoW3UYjC9bY=;
        b=MBNm1oWt0bL+dCk1h0i3URSIsftPxiwHhzI9raAZu91hDDT3mbADnByPHc6aXlIm0l
         mOdzo7bLW3RQLYxagFbmVShWvcEEY/tSlKly5H0jy/4oojNXAl+YcrDtVJqJwUDZ39H3
         zxX8leYhSImFDLX/HDAWFVX9lR2ERxATFASIAfYLN8jDPMB/pX4GAEI3wMZvEDRyHqT0
         S4eMOg3xBiPPElI40RWsVPLmPHZqR18/WOZCib6652IhSsvz2ovyXIS+UTPWVDlwU4UH
         lFuWD4rzIn+kGCGNAvhk9H0HwGi2eljAbm+07IVSz+7eR6izNwq9tD63qAsZso4tjbfk
         BbLQ==
X-Gm-Message-State: AOJu0Yx9G2NGng2cp80ZzmFpOBhRNHO1ImFqaqQYC0lHYVv0f4gbUMdT
	M1WaNBHLBRGt7YV05wo+hrGNm2eveqd2fVDyM8NXOLWIfC2nUpJS5qV8q8/bOIdybdXLAEg8DHO
	n6fPzlvV2/f4KJAVcGQ+WT/HOam18Q9Fe
X-Gm-Gg: ASbGnctkV7SR3j+uo5/ZBr7BqReqU0AlxGj9899mn6379Qj+VT53gjykS/ldfWu1ZHJ
	nvAO8+uq7NYrjqKCfx83vC0tFpyfOBjO7LqHKGzfMZKt1oTT9IrKO6e6sFP7BjSnu4YdrwNUgqQ
	==
X-Google-Smtp-Source: AGHT+IFNxCFreH7kzSBy2YkWpvBA4luw5EbRfKfsVTiKX1Yxw/UV489awol6ALCm1H2u1x+O5PfbL/8s2+ZFbQvtPVs=
X-Received: by 2002:a05:690c:4983:b0:6f6:d40a:5dfb with SMTP id
 00721157ae682-6f6eb942d37mr333513607b3.38.1738077666128; Tue, 28 Jan 2025
 07:21:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjojkqPOE9B1NH3F05znW8bGGMK+OMChXXaexHXJP63Few@mail.gmail.com>
 <CALtW_ahaops_C1XikG1iGOTF47ZC3aVo973vTW1-15DSijvvYg@mail.gmail.com>
In-Reply-To: <CALtW_ahaops_C1XikG1iGOTF47ZC3aVo973vTW1-15DSijvvYg@mail.gmail.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Tue, 28 Jan 2025 17:20:54 +0200
X-Gm-Features: AWEUYZn4pjzHyI5cfqaySsoJ-VdCXE7rQV3JdH6Ox8MrwYc4jqiSCbyz8IrWc38
Message-ID: <CAAiJnjr3+6p0X_Be-DBJScVniNWVCY-B1CEJYm6SyiLf01bkrg@mail.gmail.com>
Subject: Re: Add spare disk to raid50
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Read the man page (spare-group parameter), mdadm allows for one spare
> drive to be used
> for multiple arrays.

I have read the manuals, but it doesn't work as described, or likely I
do something wrong.  Are there any working examples ?

My config is simple -

[root@memverge2 anton]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md118 : active raid5 nvme0n1[4] nvme3n1[0](S) nvme7n1[3] nvme5n1[1]
      3125362688 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [U=
UU]
      bitmap: 0/12 pages [0KB], 65536KB chunk

md117 : active raid5 nvme6n1[4] nvme4n1[1] nvme2n1[0]
      3125362688 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [U=
UU]
      bitmap: 0/12 pages [0KB], 65536KB chunk

unused devices: <none>
[root@memverge2 anton]#
[root@memverge2 anton]# cat /etc/mdadm.conf
ARRAY /dev/md/117 level=3Draid5 num-devices=3D3 metadata=3D1.2
UUID=3D0fab82cd:36301f6c:6ec78c95:7f092d4c spare-group=3Dgroup1
   devices=3D/dev/nvme2n1,/dev/nvme4n1,/dev/nvme6n1
ARRAY /dev/md/118 level=3Draid5 num-devices=3D3 metadata=3D1.2 spares=3D1
UUID=3D2d7290e5:c3ccbfe9:004cb182:3e325714 spare-group=3Dgroup1
   devices=3D/dev/nvme0n1,/dev/nvme3n1,/dev/nvme5n1,/dev/nvme7n1
[root@memverge2 anton]#
[root@memverge2 anton]# systemctl restart mdmonitor
[root@memverge2 anton]#
[root@memverge2 anton]# mdadm /dev/md117 --fail /dev/nvme6n1
[root@memverge2 anton]#
[root@memverge2 anton]# mdadm -D /dev/md117
/dev/md117:
           Version : 1.2
     Creation Time : Tue Jan 28 11:08:21 2025
        Raid Level : raid5
        Array Size : 3125362688 (2.91 TiB 3.20 TB)
     Used Dev Size : 1562681344 (1490.29 GiB 1600.19 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Tue Jan 28 15:29:47 2025
             State : clean, degraded
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

              Name : memverge2:117  (local to host memverge2)
              UUID : 0fab82cd:36301f6c:6ec78c95:7f092d4c
            Events : 849

    Number   Major   Minor   RaidDevice State
       0     259        5        0      active sync   /dev/nvme2n1
       1     259        0        1      active sync   /dev/nvme4n1
       -       0        0        2      removed

       4     259        1        -      faulty   /dev/nvme6n1
[root@memverge2 anton]#

And there is no raid117 recovering using spare from raid118.

Anton

=D0=BF=D0=BD, 27 =D1=8F=D0=BD=D0=B2. 2025=E2=80=AF=D0=B3. =D0=B2 23:18, Dra=
gan Milivojevi=C4=87 <galileo@pkm-inc.com>:
>
> Read the man page (spare-group parameter), mdadm allows for one spare
> drive to be used
> for multiple arrays.
>
> On Mon, 27 Jan 2025 at 15:15, Anton Gavriliuk <antosha20xx@gmail.com> wro=
te:
> >
> > How to add a spare disk to raid50 which consists of several raid5
> > (7+1) ? It would be more economical and flexible than adding spare
> > disks to each raid5 in raid50.
> >
> > Anton
> >
