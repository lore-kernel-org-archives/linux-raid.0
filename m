Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988A3C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 19:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8124861103
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 19:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhHRTuM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 15:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233575AbhHRTsy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Aug 2021 15:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629316098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B126DlnW1H5eYr3bEQ0UPFzOneUM9r28Y5ezX3w5gL0=;
        b=Aj7yP4mb/96b3CxibgE9X6HpX4BN3JPHg4HkNDFKp5IVKUPz1xnvEdPhnryS8l5iQF6ONP
        KxzniWxsGbMJzq3OqXZH0XnwuWhfH1KUAGVOZhZL7LQYzoXLtkKK+DA9YMNGXoNbaq+a/q
        CcWSjbgtQ5WMc7gR4Vb4WCGQFrGxZzg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-oc-4fxhSNmCaFGCin82qPg-1; Wed, 18 Aug 2021 15:48:17 -0400
X-MC-Unique: oc-4fxhSNmCaFGCin82qPg-1
Received: by mail-qv1-f71.google.com with SMTP id u11-20020a0562141c0b00b0036201580785so2935208qvc.11
        for <linux-raid@vger.kernel.org>; Wed, 18 Aug 2021 12:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:organization:user-agent:mime-version;
        bh=B126DlnW1H5eYr3bEQ0UPFzOneUM9r28Y5ezX3w5gL0=;
        b=HV0l4a/oeP0h3ZCZjPTO0EKYkMc8eDttn9asHDw1lfCB6j3Cq7nqzCt7tOXEoQf0K1
         HJ1NkDDGc8UDArH0z2MQila5M1S4UObv8auuQMVam0XY0wHmPEt23X0aKaJS9MkuSGpL
         /Vk3xr8eMG4oWs10ORRY2N3uL7ldwbCPATCh9bGoQIGxuO8C8h4lKBtLdkvJttvHajFs
         8U+9qze6BPwREG+OzXS4J76A1Q6TMkS8KZkhgW7fhYbWBUjuiTFzQBB/LXxdELkJ2ySe
         79lJpdozB2JoKEI3DXpRFjQdpkElspQr5WSay+7iilp7nJ5Go4TFXpJSWsCU2wPxpbAg
         yZng==
X-Gm-Message-State: AOAM530gT4lowuKTLZDYDKdv840Sm2hSLBh0kLxSstftJnwejqS/PVUN
        qUmK+gCtaG8+e+DIRYcScmQerbG83pKSDQFVus5oA/oq7S+JRzk5x6ABld8sml2kwb1FITVP535
        rzSdQnKQPnHiAtArlV4YoHw==
X-Received: by 2002:a37:e14:: with SMTP id 20mr7253882qko.229.1629316096609;
        Wed, 18 Aug 2021 12:48:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmdG0gSYuFskK4s5JedCkStdaEhzUuuoUXmI1SnsX9rufP3OgN4a1U65cJPu3ODeXhLSpd6g==
X-Received: by 2002:a37:e14:: with SMTP id 20mr7253867qko.229.1629316096316;
        Wed, 18 Aug 2021 12:48:16 -0700 (PDT)
Received: from linux-ws.nc.xsintricity.com (104-15-26-233.lightspeed.rlghnc.sbcglobal.net. [104.15.26.233])
        by smtp.gmail.com with ESMTPSA id q7sm418736qkm.68.2021.08.18.12.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 12:48:15 -0700 (PDT)
Message-ID: <14e078c6a52cdd05998345d0d90c860b77dac5f3.camel@redhat.com>
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS -
 AMD ROME what am I missing?????
From:   Doug Ledford <dledford@redhat.com>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        'Matt Wallis' <mattw@madmonks.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date:   Wed, 18 Aug 2021 15:48:13 -0400
In-Reply-To: <5EAED86C53DED2479E3E145969315A238585E1AD@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
         <AS8PR04MB799205817C4647DAC740DE9A91EA9@AS8PR04MB7992.eurprd04.prod.outlook.com>
         <5EAED86C53DED2479E3E145969315A2385856AD0@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856AF7@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856B25@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856B62@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A2385856B85@UMECHPA7B.easf.csd.disa.mil>
         <20210808174331.1e444db9@gofri-dell>
         <5EAED86C53DED2479E3E145969315A2385857258@UMECHPA7B.easf.csd.disa.mil>
         <5EAED86C53DED2479E3E145969315A238585E0EF@UMECHPA7B.easf.csd.disa.mil>
         <300042B9-F46F-42CF-8FD7-F1C2FE0965E5@madmonks.org>
         <5EAED86C53DED2479E3E145969315A238585E1AD@UMECHPA7B.easf.csd.disa.mil>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-do/lURXAdO7ZwLi8R5Sz"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-do/lURXAdO7ZwLi8R5Sz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-08-18 at 10:20 +0000, Finlayson, James M CIV (USA) wrote:
> All,
> I'm happy to be in the position to pioneer some of this "tuning" if
> nobody has done this prior.

Here's what I would be interested to know: how does btrfs do using these
drives bare in raid5 mode?  You have to do the metadata in raid1 mode,
but you can tear down and retest btrfs filesystems on this in a matter
of minutes because it doesn't have to initialize the array.  So you
could try a btrfs per NUMA node, one big btrfs, or other configurations.

Now, let me explain why I think this would be interesting.  I'm a long
time user and developer on the MD raid stack, going all the way back to
the first SSE implementation of the raid5 xor operations.  I've always
used mdraid, and later lvm + mdraid, to build my boxes.  But I've come
to believe that there is an inherint weakness to the mdraid + lvm +
filesystem stack that btrfs (and zfs) overcome by building their raid
code into the filesystem itself.  The inherint weakness is that the
filesystem is the source of truth for what blocks on the device have or
have not been allocated, and what their contents should be.  The mdraid
stack therefore has to do things like initialize the array because it
doesn't know what's written and what isn't.  This also impacts
reconstruction and error recovery similarly.  But, more importantly, it
means that in an attempt to avoid always having huge latency penalties
caused by read-modify-write cycles, the mdraid subsystem maintains its
own cache layer (the stripe cache) separate from the official page cache
of the kernel.  Although I haven't instrumented things to see for sure
if I'm right, my suspicion is that the stripe cache sometimes gets
blocked up under memory pressure and stalls writes to the array.  The
symptom I see is that when I'm copying a large file to the server via
10Gig Ethernet, it will start at 900MB/s and may stay that fast for the
entire operation, but other times the copy will stall, sometimes going
all the way to 0MB/s, for a random period of time.  My suspicion is that
when this happens, there is memory pressure and the raid5 code is having
trouble reading in blocks for read-modify-write operations when the
write it needs to perform is not a full stripe wide write.  This is
avoided when the filesystem is aware of the multi drive layout and
issues the reads itself.  So I strongly suspect that when I build my
next iteration of my home server, it's going to be btrfs (in fact, I
have a test install on it already, but I haven't had the time to do all
the testing needed to confirm it actually solves the problem of the
previous generation of my server).

> =C2=A0=C2=A0 After updating this thread and then providing a status repor=
t to my
> leadership, it hit me on what we're really balancing is "how many
> mdraid kernel worker threads" it takes to hit max IOPS.=C2=A0 I'll go fin=
d
> that out.=C2=A0=C2=A0=C2=A0=C2=A0 If real world testing becomes my contri=
bution , so be
> it.=C2=A0=C2=A0=C2=A0=C2=A0 I was an O/S developer originally working in =
the I/O
> subsystem, but early in my career that effort was deprecated, so I've
> only been an integrator of COTS and open source for the last 30 years
> and my programming skills have minimized to just perl and bash.=C2=A0=C2=
=A0 I
> don't have the skills necessary to make coding contributions.
>=20
> Where I'd like mdraid to get is such that we don't need to do this,
> but this is a marathon, not a sprint.
>=20
> As far as the PCIe lanes, AMD has situations where 160 gen 4 lanes are
> available (deleting 1 XGMI2 socket to socket interconnect).=C2=A0=C2=A0 I=
f you
> have NUMA awareness, the box seems highly capable.=C2=A0=C2=A0=C2=A0=20
>=20
> Regards,
> Jim
>=20
>=20
>=20
> -----Original Message-----
> From: Matt Wallis <mattw@madmonks.org>=20
> Sent: Tuesday, August 17, 2021 8:45 PM
> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Cc: linux-raid@vger.kernel.org
> Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread
> IOPS - AMD ROME what am I missing?????
>=20
> Hi Jim,
>=20
> Awesome stuff. I=E2=80=99m looking to get access back to a server I was u=
sing
> before for my tests so I can play some more myself.
> I did wonder about your use case, and if you were planning to present
> the storage over a network to another server, or intended to use it as
> local storage for an application.
>=20
> The problem is basically that we=E2=80=99re limited no matter what we do.
> There=E2=80=99s no way with current PCIe+networking to get that bandwidth
> outside the box, and you don=E2=80=99t have much compute left inside the =
box.
>=20
> You could simplify the configuration a little bit by using a parallel
> file system like BeeGFS. Parallel file systems like to stripe data
> over multiple targets anyway, so you could remove the LVM layer, and
> simply present 64 RAID volumes for BeeGFS to write to.=C2=A0=20
>=20
> Normal parallel file system operation is to export the volumes over a
> network, but BeeGFS does have an alternate mode called BeeOND, or
> BeeGFS on Demand, which builds up dynamic file systems using the local
> disks in multiple servers, you could potentially look at a single
> server BeeOND configuration and see if that worked, but I suspect
> you=E2=80=99d be exchanging bottlenecks.
>=20
> There=E2=80=99s a new parallel FS on the market that might also be of
> interest, called MadFS. It=E2=80=99s based on another parallel file syste=
m but
> with certain parts re-written using the Rust language which
> significantly improved it=E2=80=99s ability to handle higher IOPs.=20
>=20
> Hmm, just realised the box I had access to before won=E2=80=99t help, it =
was
> built on an older Intel platform so bottlenecked by PCIe lanes. I=E2=80=
=99ll
> have to see if I can get something newer.
>=20
> Matt.
>=20
> > On 18 Aug 2021, at 07:21, Finlayson, James M CIV (USA) <
> > james.m.finlayson4.civ@mail.mil> wrote:
> >=20
> > All,
> > A quick random performance update (this is the best I can do in
> > "going for it" with all of the guidance from this list) - I'm
> > thrilled.....
> >=20
> > 5.14rc4 kernel Gen 4 drives, all AMD Rome BIOS tuning to keep I/O
> > from power throttling,=C2=A0 SMT turned on (off yielded higher
> > performance but left no room for anything else),=C2=A0 15.36TB drives c=
ut
> > into 32 equal partitions,=C2=A0 32 NUMA aligned raid5 9+1s from the sam=
e
> > partition on NUMA0 combined with an LVM concatenating all 32 RAID5's
> > into one volume.=C2=A0=C2=A0=C2=A0 I then do the exact same thing on NU=
MA1.
> >=20
> > 4K random reads, SMT off, sustained bandwidth of > 90GB/s, sustained
> > IOPS across both LVMs, ~23M - bad part, only 7% of the system left
> > to=20
> > do anything useful 4K random reads, SMT on, sustained bandwidth of >
> > 84GB/s, sustained IOPS across both LVMs, ~21M - 46.7% idle (.73%
> > users, 52.6% system time) Takeaway - IMHO, no reason to turn off
> > SMT, it helps way more than it hurts...
> >=20
> > Without the partitioning and lvm shenanigans, with SMT on, 5.14rc4=20
> > kernel, most AMD BIOS tuning (not all), I'm at 46GB/s, 11.7M IOPS ,=20
> > 42.2% idle (3% user, 54.7% system time)
> >=20
> > With stock RHEL 8.4, 4.18 kernel, SMT on, both partitioning and LVM=20
> > shenanigans, most AMD BIOS tuning (not all), I'm at 81.5GB/s, 20.4M=20
> > IOPS, 49% idle (5.5% user, 46.75% system time)
> >=20
> > The question I have for the list, given my large drive sizes, it
> > takes me a day to set up and build an mdraid/lvm configuration.=C2=A0=
=C2=A0=C2=A0
> > Has anybody found the "sweet spot" for how many partitions per
> > drive?=C2=A0=C2=A0=C2=A0 I now have a script to generate the drive part=
itions, a
> > script for building the mdraid volumes, and a procedure for
> > unwinding from all of this and starting again.=C2=A0=C2=A0=C2=A0=20
> >=20
> > If anybody knows the point of diminishing return for the number of
> > partitions per drive to max out at, it would save me a few days of
> > letting 32 run for a day, reconfiguring for 16, 8, 4, 2, 1....I
> > could just tear apart my LVMs and remake them with half as many RAID
> > partitions, but depending upon how the nvme drive is "RAINed" across
> > NAND chips, I might leave performance on the table.=C2=A0=C2=A0 The res=
earcher
> > in me says, start over, don't make ANY assumptions.
> >=20
> > As an aside, on the server, I'm maintaining around 1.1M=C2=A0 NUMA awar=
e
> > IOPS per drive, when hitting all 24 drives individually without
> > RAID, so I'm thrilled with the performance ceiling with the RAID, I
> > just have to find a way to make it something somebody would be
> > willing to maintain.=C2=A0=C2=A0 Somewhere is a sweet spot between
> > sustainability and performance.=C2=A0=C2=A0 Once I find that I have to =
figure
> > out if there is something useful to do with this new toy.....
> >=20
> >=20
> > Regards,
> > Jim
> >=20
> >=20
> >=20
> >=20
> > -----Original Message-----
> > From: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> > Sent: Monday, August 9, 2021 3:02 PM
> > To: 'Gal Ofri' <gal.ofri@volumez.com>; 'linux-raid@vger.kernel.org'=20
> > <linux-raid@vger.kernel.org>
> > Cc: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> > Subject: RE: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe
> > randomread IOPS - AMD ROME what am I missing?????
> >=20
> > Sequential Performance:
> > BLUF, 1M sequential, direct I/O=C2=A0 reads, QD 128=C2=A0 - 85GiB/s acr=
oss
> > both 10+1+1 NUMA aware 128K striped LUNS.=C2=A0=C2=A0 Had the imbalance
> > between NUMA 0 44.5GiB/s and NUMA 1 39.4GiB/s but still could be
> > drifting power management on the AMD Rome cores.=C2=A0=C2=A0=C2=A0 I tr=
ied a 1280K
> > blocksize to try to get a full stripe read, but Linux seems so
> > unfriendly to non-power of 2 blocksizes.... performance decreased
> > considerably (20GiB/s ?) with the 10x128KB blocksize....=C2=A0=C2=A0 I =
think I
> > ran for about 40 minutes with the 1M reads...
> >=20
> >=20
> > socket0-md: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-
> > 1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D128 ...
> > socket1-md: (g=3D1): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-
> > 1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D128 ...
> > fio-3.26
> > Starting 128 processes
> >=20
> > fio: terminating on signal 2
> >=20
> > socket0-md: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D1645360: Mon Aug=
=C2=A0 9=20
> > 18:53:36 2021
> > =C2=A0read: IOPS=3D45.6k, BW=3D44.5GiB/s (47.8GB/s)(114TiB/2626961msec)
> > =C2=A0=C2=A0 slat (usec): min=3D12, max=3D4463, avg=3D24.86, stdev=3D15=
.58
> > =C2=A0=C2=A0 clat (usec): min=3D249, max=3D1904.8k, avg=3D179674.12, st=
dev=3D138190.51
> > =C2=A0=C2=A0=C2=A0 lat (usec): min=3D295, max=3D1904.8k, avg=3D179699.0=
7, stdev=3D138191.00
> > =C2=A0=C2=A0 clat percentiles (msec):
> > =C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0=C2=A0=C2=A0 3],=C2=A0 5.00t=
h=3D[=C2=A0=C2=A0=C2=A0 5], 10.00th=3D[=C2=A0=C2=A0=C2=A0 7], 20.00th=3D[=
=C2=A0=C2=A0
> > 17],
> > =C2=A0=C2=A0=C2=A0 | 30.00th=3D[=C2=A0 106], 40.00th=3D[=C2=A0 116], 50=
.00th=3D[=C2=A0 209], 60.00th=3D[=C2=A0
> > 226],
> > =C2=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0 236], 80.00th=3D[=C2=A0 321], 90=
.00th=3D[=C2=A0 351], 95.00th=3D[=C2=A0
> > 372],
> > =C2=A0=C2=A0=C2=A0 | 99.00th=3D[=C2=A0 472], 99.50th=3D[=C2=A0 481], 99=
.90th=3D[ 1267], 99.95th=3D[
> > 1401],
> > =C2=A0=C2=A0=C2=A0 | 99.99th=3D[ 1586]
> > =C2=A0 bw (=C2=A0 MiB/s): min=3D=C2=A0 967, max=3D114322, per=3D8.68%, =
avg=3D45897.69,
> > stdev=3D330.42, samples=3D333433
> > =C2=A0 iops=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : min=3D=C2=A0 92=
9, max=3D114304, avg=3D45879.39, stdev=3D330.41,
> > samples=3D333433
> > =C2=A0lat (usec)=C2=A0=C2=A0 : 250=3D0.01%, 500=3D0.01%, 750=3D0.05%, 1=
000=3D0.06%
> > =C2=A0lat (msec)=C2=A0=C2=A0 : 2=3D0.49%, 4=3D4.36%, 10=3D9.43%, 20=3D7=
.52%, 50=3D3.48%
> > =C2=A0lat (msec)=C2=A0=C2=A0 : 100=3D2.70%, 250=3D47.39%, 500=3D24.25%,=
 750=3D0.09%,
> > 1000=3D0.01%
> > =C2=A0lat (msec)=C2=A0=C2=A0 : 2000=3D0.15%
> > =C2=A0cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : usr=
=3D0.07%, sys=3D1.83%, ctx=3D77483816, majf=3D0,
> > minf=3D37747
> > =C2=A0IO depths=C2=A0=C2=A0=C2=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0=
.1%, 16=3D0.1%, 32=3D0.1%,
> > >=3D64=3D100.0%
> > =C2=A0=C2=A0=C2=A0 submit=C2=A0=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%,
> > >=3D64=3D0.0%
> > =C2=A0=C2=A0=C2=A0 complete=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=
=3D0.0%, 32=3D0.0%, 64=3D0.0%,
> > >=3D64=3D0.1%
> > =C2=A0=C2=A0=C2=A0 issued rwts: total=3D119750623,0,0,0 short=3D0,0,0,0=
 dropped=3D0,0,0,0
> > =C2=A0=C2=A0=C2=A0 latency=C2=A0=C2=A0 : target=3D0, window=3D0, percen=
tile=3D100.00%, depth=3D128
> > socket1-md: (groupid=3D1, jobs=3D64): err=3D 0: pid=3D1645424: Mon Aug=
=C2=A0 9=20
> > 18:53:36 2021
> > =C2=A0read: IOPS=3D40.3k, BW=3D39.4GiB/s (42.3GB/s)(101TiB/2627054msec)
> > =C2=A0=C2=A0 slat (usec): min=3D12, max=3D57137, avg=3D23.77, stdev=3D2=
7.80
> > =C2=A0=C2=A0 clat (usec): min=3D130, max=3D1746.1k, avg=3D203005.37, st=
dev=3D158045.10
> > =C2=A0=C2=A0=C2=A0 lat (usec): min=3D269, max=3D1746.1k, avg=3D203029.2=
3, stdev=3D158045.27
> > =C2=A0=C2=A0 clat percentiles (usec):
> > =C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0=C2=A0=C2=A0 570],=C2=A0 5.0=
0th=3D[=C2=A0=C2=A0=C2=A0 693], 10.00th=3D[=C2=A0=C2=A0 2573],
> > =C2=A0=C2=A0=C2=A0 | 20.00th=3D[=C2=A0 21103], 30.00th=3D[ 102237], 40.=
00th=3D[ 143655],
> > =C2=A0=C2=A0=C2=A0 | 50.00th=3D[ 204473], 60.00th=3D[ 231736], 70.00th=
=3D[ 283116],
> > =C2=A0=C2=A0=C2=A0 | 80.00th=3D[ 320865], 90.00th=3D[ 421528], 95.00th=
=3D[ 455082],
> > =C2=A0=C2=A0=C2=A0 | 99.00th=3D[ 583009], 99.50th=3D[ 608175], 99.90th=
=3D[1061159],
> > =C2=A0=C2=A0=C2=A0 | 99.95th=3D[1166017], 99.99th=3D[1367344]
> > =C2=A0 bw (=C2=A0 MiB/s): min=3D=C2=A0 599, max=3D124821, per=3D-3.40%,=
 avg=3D40571.79,
> > stdev=3D319.36, samples=3D333904
> > =C2=A0 iops=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : min=3D=C2=A0 56=
8, max=3D124809, avg=3D40554.92, stdev=3D319.34,
> > samples=3D333904
> > =C2=A0lat (usec)=C2=A0=C2=A0 : 250=3D0.01%, 500=3D0.14%, 750=3D6.31%, 1=
000=3D2.60%
> > =C2=A0lat (msec)=C2=A0=C2=A0 : 2=3D0.58%, 4=3D2.04%, 10=3D4.17%, 20=3D3=
.82%, 50=3D3.71%
> > =C2=A0lat (msec)=C2=A0=C2=A0 : 100=3D5.91%, 250=3D32.86%, 500=3D33.81%,=
 750=3D3.81%,
> > 1000=3D0.10%
> > =C2=A0lat (msec)=C2=A0=C2=A0 : 2000=3D0.14%
> > =C2=A0cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : usr=
=3D0.05%, sys=3D1.56%, ctx=3D71342745, majf=3D0,
> > minf=3D37766
> > =C2=A0IO depths=C2=A0=C2=A0=C2=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0=
.1%, 16=3D0.1%, 32=3D0.1%,
> > >=3D64=3D100.0%
> > =C2=A0=C2=A0=C2=A0 submit=C2=A0=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%,
> > >=3D64=3D0.0%
> > =C2=A0=C2=A0=C2=A0 complete=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=
=3D0.0%, 32=3D0.0%, 64=3D0.0%,
> > >=3D64=3D0.1%
> > =C2=A0=C2=A0=C2=A0 issued rwts: total=3D105992570,0,0,0 short=3D0,0,0,0=
 dropped=3D0,0,0,0
> > =C2=A0=C2=A0=C2=A0 latency=C2=A0=C2=A0 : target=3D0, window=3D0, percen=
tile=3D100.00%, depth=3D128
> >=20
> > Run status group 0 (all jobs):
> > =C2=A0 READ: bw=3D44.5GiB/s (47.8GB/s), 44.5GiB/s-44.5GiB/s=20
> > (47.8GB/s-47.8GB/s), io=3D114TiB (126TB), run=3D2626961-2626961msec
> >=20
> > Run status group 1 (all jobs):
> > =C2=A0 READ: bw=3D39.4GiB/s (42.3GB/s), 39.4GiB/s-39.4GiB/s=20
> > (42.3GB/s-42.3GB/s), io=3D101TiB (111TB), run=3D2627054-2627054msec
> >=20
> > Disk stats (read/write):
> > =C2=A0=C2=A0 md0: ios=3D960804546/0, merge=3D0/0, ticks=3D1844674407228=
8672424/0,=20
> > in_queue=3D18446744072288672424, util=3D100.00%, aggrios=3D0/0,=20
> > aggrmerge=3D0/0, aggrticks=3D0/0, aggrin_queue=3D0, aggrutil=3D0.00%
> > =C2=A0nvme0n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme3n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme6n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme11n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme9n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme2n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme5n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme10n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme8n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme1n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme4n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme7n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0=C2=A0 md1: ios=3D850399203/0, merge=3D0/0, ticks=3D2118156441/0,=
=20
> > in_queue=3D2118156441, util=3D100.00%, aggrios=3D0/0, aggrmerge=3D0/0,=
=20
> > aggrticks=3D0/0, aggrin_queue=3D0, aggrutil=3D0.00%
> > =C2=A0nvme15n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme18n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme20n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme23n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme14n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme17n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme22n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme13n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme19n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme21n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme12n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> > =C2=A0nvme24n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%
> >=20
> > -----Original Message-----
> > From: Gal Ofri <gal.ofri@volumez.com>
> > Sent: Sunday, August 8, 2021 10:44 AM
> > To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> > Cc: 'linux-raid@vger.kernel.org' <linux-raid@vger.kernel.org>
> > Subject: Re: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe
> > randomread IOPS - AMD ROME what am I missing?????
> >=20
> > On Thu, 5 Aug 2021 21:10:40 +0000
> > "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
> > wrote:
> >=20
> > > BLUF upfront with 5.14rc3 kernel that our SA built - md0 a 10+1+1
> > > RAID5 - 5.332 M IOPS 20.3GiB/s, md1 a 10+1+1 RAID5, 5.892M IOPS
> > > 22.5GiB/s=C2=A0 - best hero numbers I've ever seen on mdraid=C2=A0 RA=
ID5
> > > IOPS.=C2=A0=C2=A0 I think the kernel patch is good.=C2=A0 Prior was=
=C2=A0 socket0
> > > 1.263M IOPS 4934MiB/s, socket1 1.071M IOSP, 4183MiB/s....=C2=A0=C2=A0=
 I'm
> > > willing to help push this as hard as we can until we hit a
> > > bottleneck outside of our control.
> > That's great !
> > Thanks for sharing your results.
> > I'd appreciate if you could run a sequential-reads workload
> > (128k/256k) so that we get a better sense of the throughput
> > potential here.
> >=20
> > > In my strict numa adherence with mdraid, I see lots of variability
> > > between reboots/assembles.=C2=A0=C2=A0=C2=A0 Sometimes md0 wins, some=
times md1
> > > wins, and in my earlier runs md0 and md1 are notionally
> > > balanced.=C2=A0=C2=A0 I change nothing but see this variance.=C2=A0=
=C2=A0 I just
> > > cranked up a week long extended run of these 10+1+1s under the
> > > 5.14rc3 kernel and right now=C2=A0=C2=A0 md0 is doing 5M IOPS and md1=
 6.3M=20
> > Given my humble experience with the code in question, I suspect that
> > it is not really optimized for numa awareness, so I find your
> > findings quite reasonable. I don't really have a good tip for that.
> >=20
> > I'm focusing now on thin-provisioned logical volumes (lvm - it has a
> > much worse reads bottleneck actually), but we have plans for=20
> > researching
> > md/raid5 again soon to improve write workloads.
> > I'll ping you when I have a patch that might be relevant.
> >=20
> > Cheers,
> > Gal

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0=C2=A0=C2=A0=C2=A0GPG KeyID: B826A3330E572FDD
=C2=A0=C2=A0=C2=A0=C2=A0Fingerprint =3D AE6B 1BDA 122B 23B4 265B=C2=A0=C2=
=A01274 B826 A333 0E57 2FDD

--=-do/lURXAdO7ZwLi8R5Sz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmEdY/0ACgkQuCajMw5X
L90YTRAAhR68+3sAtkknleexm0w4rhP1Ax8T+r+JRFK4du307EqCvLSBuwdGFRxT
g2MtGLI1MOirpVYT5vMzamS3H4pQN3CONCz09X5wuD3BVZ/3gAKshZVJI+CgzphU
AMvz8a6apEafAuQ+WryTgDAcgOdRowiz+NiNpYsMd7mTqr3S0XmvWKtwndG5/znN
TRoVMKBOFKwRJ8MBU5GRBOQj/Hr7F7PaF47hKjs4gR3m/8Dgzcyxz8bwLPj0F1AD
7ZTT4R3el2Bh8DIcH+oxQ4B4qJEZUJ94Zl471wgvjme0cikAgTuR/FFQc8C07482
DiB2x53YwUpRVhmw0X6iTlJi5Ycuw1VJ19HBhmWyBig8s+Wl6+Db3/OZkKaneOMt
VvWr8Z5Q73I+tD+BQUjYVk+kO4FF7cgp+4WIOV+T3fUbo0E4mHo9UlsyZsTLlN61
jcwcBiUvk5rO7WcG8HXGwIdFXEvXTKOF4c+p9LSeXtRF9+xKR72oeN81+1suRI15
wHFT89ZZTQ2NDeHaM7fx82c5L7w8gOJilaYCHOaAHncqxeI3rIXfYyWI5fHj3kBA
p1mAFUxIv5tDkVoIIwG/JbpMzuMwwmok3n/ZEC4ozUeKwqN7fIOM/0jRSQX4h0Oc
OnnaBj4R/Ra26ERoDS41TX7B4DZgJQqsRWhhcts8xTxuB3ti+zo=
=TDns
-----END PGP SIGNATURE-----

--=-do/lURXAdO7ZwLi8R5Sz--

