From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: RAID10-reshape crashed due to memory allocation problem
Date: Fri, 8 Aug 2014 18:46:52 +0200
Message-ID: <201408081646.s78GkqtA017996@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

thanks for the info about set meaning of set-A, the difference
between Device-ID and RaidDevice.

> > Number   Major   Minor   RaidDevice State
> >    0       8       16        0      active sync set-A   /dev/sdb
> >    1       8      160        1      active sync set-B   /dev/sdk
> >    2       8       32        2      active sync set-A   /dev/sdc
> >    3       8      176        3      active sync set-B   /dev/sdl
> >    4       8       48        4      active sync set-A   /dev/sdd
> >    5       8      192        5      active sync set-B   /dev/sdm
> >    6       8       64        6      active sync set-A   /dev/sde
> >    7       8      208        7      active sync set-B   /dev/sdn
> >    8       8       80        8      active sync set-A   /dev/sdf
> >    9       8      224        9      active sync set-B   /dev/sdo
> >   10       8       96       10      active sync set-A   /dev/sdg
> >   11       8      240       11      active sync set-B   /dev/sdp
> >   12       8      112       12      active sync set-A   /dev/sdh
> >   14       8      128       13      active sync set-B   /dev/sdi
> >   13      65        0       14      active sync set-A   /dev/sdq
> >   15      65       16       15      active sync set-B   /dev/sdr
> 
> It's not "sync set-A", it is "active" and "sync" and  "set-A".
> When you have a RAID10 that can be seen as two sets of devices where one set
> is mirrored to the other, they are labels as "set-A" and  "set-B", just like
> you assumed.

The first time I noticed "set-A" and "set-B" in mdadm -D output
was after the reshape operation started. If I understand you
correct the real reason for these information to appear was not
the reshape operation but growing the array from an odd number
of drives (13) to an even number (16)

> > What's the difference between column 1 and column 4 in
> > mdadm -D output?
>
> column 1 identified the device.  column 4 give the role that the device plays
> in the array.
> This seemed to make sense once, but it could be more confusing than helpful.

What irritates me most is the fact that /proc/mdstat output
lists the device id. For a raid10-array with near-2 layout and
an even number of drives I was under the impression that the data
is mirrored between all drives with even and all drives with odd
numbers. In my case this is wrong: drives 0,2,4,6,8,10,12,13
are mirrored with drives 1,3,5,7,9,11,14,15.

Spare-Drives are not shown with their number but with their role
within the array (namely (S) ). So why not printing the role
for all drives instead of their device-id. I would also suggest
adding the set to mdstat-output, i.e:

md5 : active raid10 sdb[A0] sdr[B7] sdq[A7] sdi[B6] sdh[A6] sdp[B5] sdg[A5] sdo[B4] sdf[A4] sdn[B3] sde[A3] sdm[B2] sdd[A2] sdl[B1] sdc[A1] sdk[B0]

Is there any way to change the device-id?

Kind regards

Peter Koch
