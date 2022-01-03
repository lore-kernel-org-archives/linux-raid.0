Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11407C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jan 2022 17:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiACRUJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 12:20:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:32170 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbiACRUJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 3 Jan 2022 12:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641230409; x=1672766409;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=79+aLAI1MDXUHRAeOJNfrT48S/QRhOWztwh/TNMnzfw=;
  b=WmML90fCu1V1rhGzBo7lONylGg1YddWAtDirC66l6UT0SYNNHbi4TJ31
   ddYMqiLlSL23lD1UOvOb75UpNmt5OULDMK7HGj7UEvu8dXNabd2qkyq8b
   ajlPbU0K06rAzByAYeU+TOk2WSGDZlo4GTwtuIGHbSKJxpLYXEVwXoB7n
   e6Vcs5PEGHEjJfOfVxsUWhsmDvaULpipGSTqTzB9dOHzE5eMgMELi5Ou1
   R3w8u65Wdy3zmkcqiYxbzZlrZCjpsfGz9O+OmVa+i/rrsIxf0Mp9VXVt/
   8c/hEs6y7zHjtGEDJ7jVM3Sr6cfAX9etdWeKu4SdXeTa2Pxva0S5Lt498
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10215"; a="239637061"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="239637061"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 09:20:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525663935"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.26.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 09:20:07 -0800
Date:   Mon, 3 Jan 2022 18:20:02 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jani Partanen <jiipee@sotapeli.fi>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Strange behavior when I grow raid0
Message-ID: <20220103182002.0000520f@linux.intel.com>
In-Reply-To: <e349ad6a-f5f7-df22-9753-bca4605e561d@sotapeli.fi>
References: <e349ad6a-f5f7-df22-9753-bca4605e561d@sotapeli.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jani,

On Sat, 11 Dec 2021 00:25:14 +0200
Jani Partanen <jiipee@sotapeli.fi> wrote:

> Hello,
>=20
> I recently migrated from btrfs raid-5 to md raid-5 and because I
> didn't have enough drives to go directly md raid-5, I basicly did
> this:
> - 2 disks raid-0
> - added 3rd disk with grow when I had moved data, still raid-0
> - added 4th disk with grow when I had moved more data, still raid-0
> - added 5th disk with grow and converted to raid-5
>=20
> Everything went fine other than I could not add internal bitmap
> because array was created as raid-0 originally but thats not an
> issue, I'll store bitmap to my /boot, it's raid-1 on SSD and ext4.
>=20
> Today I noticed that my array parity layout is parity-last and I
> started to wonder why is that, then I did remember that there was
> some strange things happening when I did add 4th drive and I made
> testing and was able to replicate what happened.
>=20
> [root@nas ~]# mdadm -C /dev/md/testraid -l 0 -n 2 -N testraid=20
> /dev/loop21 /dev/loop22
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/testraid started.
>=20
>=20
> [root@nas ~]# mdadm -D /dev/md/testraid
> /dev/md/testraid:
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
>  =A0=A0=A0=A0 Creation Time : Fri Dec 10 22:52:01 2021
>  =A0=A0=A0=A0=A0=A0=A0 Raid Level : raid0
>  =A0=A0=A0=A0=A0=A0=A0 Array Size : 98304 (96.00 MiB 100.66 MB)
>  =A0=A0=A0=A0=A0 Raid Devices : 2
>  =A0=A0=A0=A0 Total Devices : 2
>  =A0=A0=A0=A0=A0=A0 Persistence : Superblock is persistent
>=20
>  =A0=A0=A0=A0=A0=A0 Update Time : Fri Dec 10 22:52:01 2021
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
>  =A0=A0=A0 Active Devices : 2
>  =A0=A0 Working Devices : 2
>  =A0=A0=A0 Failed Devices : 0
>  =A0=A0=A0=A0 Spare Devices : 0
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : -unknown-
>  =A0=A0=A0=A0=A0=A0=A0 Chunk Size : 512K
>=20
> Consistency Policy : none
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : nas:testraid=A0 (local to=
 host nas)
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : b6e0c60a:da4c6fb1:9dc5ff0=
7:adeda371
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 0
>=20
>  =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 21=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop21
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 22=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop22
>=20
>=20
> [root@nas ~]# mdadm --grow /dev/md/testraid -n 3 -l 0 --add
> /dev/loop23 mdadm: level of /dev/md/testraid changed to raid4
> mdadm: added /dev/loop23
>=20
>=20
> [root@nas ~]# mdadm -D /dev/md/testraid
> /dev/md/testraid:
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
>  =A0=A0=A0=A0 Creation Time : Fri Dec 10 22:52:01 2021
>  =A0=A0=A0=A0=A0=A0=A0 Raid Level : raid0
>  =A0=A0=A0=A0=A0=A0=A0 Array Size : 147456 (144.00 MiB 150.99 MB)
>  =A0=A0=A0=A0=A0 Raid Devices : 3
>  =A0=A0=A0=A0 Total Devices : 3
>  =A0=A0=A0=A0=A0=A0 Persistence : Superblock is persistent
>=20
>  =A0=A0=A0=A0=A0=A0 Update Time : Fri Dec 10 22:53:33 2021
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
>  =A0=A0=A0 Active Devices : 3
>  =A0=A0 Working Devices : 3
>  =A0=A0=A0 Failed Devices : 0
>  =A0=A0=A0=A0 Spare Devices : 0
>=20
>  =A0=A0=A0=A0=A0=A0=A0 Chunk Size : 512K
>=20
> Consistency Policy : none
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : nas:testraid=A0 (local to=
 host nas)
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : b6e0c60a:da4c6fb1:9dc5ff0=
7:adeda371
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 18
>=20
>  =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 21=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop21
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 22=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop22
>  =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 23=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop23
>=20
>=20
> [root@nas ~]# mdadm --grow /dev/md/testraid -n 4 -l 0 --add
> /dev/loop24 mdadm: level of /dev/md/testraid changed to raid4
> mdadm: added /dev/loop24
> mdadm: Need to backup 6144K of critical section..
>=20
>=20
> [root@nas ~]# mdadm -D /dev/md/testraid
> /dev/md/testraid:
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
>  =A0=A0=A0=A0 Creation Time : Fri Dec 10 22:52:01 2021
>  =A0=A0=A0=A0=A0=A0=A0 Raid Level : raid4
>  =A0=A0=A0=A0=A0=A0=A0 Array Size : 196608 (192.00 MiB 201.33 MB)
>  =A0=A0=A0=A0 Used Dev Size : 49152 (48.00 MiB 50.33 MB)
>  =A0=A0=A0=A0=A0 Raid Devices : 5
>  =A0=A0=A0=A0 Total Devices : 4
>  =A0=A0=A0=A0=A0=A0 Persistence : Superblock is persistent
>=20
>  =A0=A0=A0=A0=A0=A0 Update Time : Fri Dec 10 22:59:56 2021
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean, degraded
>  =A0=A0=A0 Active Devices : 4
>  =A0=A0 Working Devices : 4
>  =A0=A0=A0 Failed Devices : 0
>  =A0=A0=A0=A0 Spare Devices : 0
>=20
>  =A0=A0=A0=A0=A0=A0=A0 Chunk Size : 512K
>=20
> Consistency Policy : resync
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : nas:testraid=A0 (local to=
 host nas)
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : b6e0c60a:da4c6fb1:9dc5ff0=
7:adeda371
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 39
>=20
>  =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 21=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop21
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 22=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop22
>  =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 23=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop23
>  =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 24=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop24
>  =A0=A0=A0=A0=A0=A0 -=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 removed
>=20
>=20
> [root@nas ~]# mdadm --grow /dev/md/testraid -n 5 -l 5 --add
> /dev/loop25 mdadm: level of /dev/md/testraid changed to raid5
> mdadm: added /dev/loop25
>=20
>=20
> [root@nas ~]# mdadm -D /dev/md/testraid
> /dev/md/testraid:
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
>  =A0=A0=A0=A0 Creation Time : Fri Dec 10 22:52:01 2021
>  =A0=A0=A0=A0=A0=A0=A0 Raid Level : raid5
>  =A0=A0=A0=A0=A0=A0=A0 Array Size : 196608 (192.00 MiB 201.33 MB)
>  =A0=A0=A0=A0 Used Dev Size : 49152 (48.00 MiB 50.33 MB)
>  =A0=A0=A0=A0=A0 Raid Devices : 5
>  =A0=A0=A0=A0 Total Devices : 5
>  =A0=A0=A0=A0=A0=A0 Persistence : Superblock is persistent
>=20
>  =A0=A0=A0=A0=A0=A0 Update Time : Fri Dec 10 23:00:39 2021
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
>  =A0=A0=A0 Active Devices : 5
>  =A0=A0 Working Devices : 5
>  =A0=A0=A0 Failed Devices : 0
>  =A0=A0=A0=A0 Spare Devices : 0
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Layout : parity-last
>  =A0=A0=A0=A0=A0=A0=A0 Chunk Size : 512K
>=20
> Consistency Policy : resync
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : nas:testraid=A0 (local to=
 host nas)
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : b6e0c60a:da4c6fb1:9dc5ff0=
7:adeda371
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Events : 59
>=20
>  =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 21=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop21
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 22=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop22
>  =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 23=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop23
>  =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 24=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop24
>  =A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 25=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/loop25
>=20
>=20
> Notice how array stay at raid4 degraded after I add 4th drive. Why is=20
> this happening? It doesn't happen when I added 3rd drive, it did
> reshape it through raid-4 but when it was finished it returned raid-0.

When you are starting reshape of raid0 then array level is temporarily
changed to level4 for simple reason, reshape algorithm is already
implemented there. After migration it goes back to raid0. raid4 is
degraded because we don't have parity disk.

Reshape is managed by userspace. The process is working in background
(fork or systemd service). After the reshape it should switch
level back to raid0 but it failed in your case.

Please find out how reshape is managed in all cases (fork or
systemd service: mdadm-grow-continue). I think that there should
be only one grow process waiting/working to reshape end.
>=20
> I also did another test where I made extra step after adding 4th disk:
>=20
> [root@nas ~]# mdadm --grow /dev/md/testraid -n 4 -l 0
> mdadm: level of /dev/md/testraid changed to raid0
> [root@nas ~]# cat /proc/mdstat
> Personalities : [raid1] [raid0] [linear] [raid6] [raid5] [raid4]
> md118 : active raid0 loop24[4] loop23[3] loop22[1] loop21[0]
>  =A0=A0=A0=A0=A0 196608 blocks super 1.2 512k chunks
>=20
>=20
> And when I did add 5th drive and converted array to raid-5, it
> correctly defaults layout to left-symmetric.

If arrays stays as degraded raid4 then it is same as raid5 with
'parity-last' consistency policy, this is why you have "parity-last"
layout. It is caused by wrong level.

> Is this some sort of bug or working as intented? Also why is this
> "Need to backup 6144K of critical section.." happening when I add 4th
> disk but not when I add 3rd disk?
>
It could be related with first problem, if mdadm decides to run fork,
then it could produce this message. As above, please check first how
reshape is managed in all cases.

> distro: Fedora 35
> kernel:=A0 5.15.6
> mdadm:=A0 v4.2-rc2
>=20

Thanks,
Mariusz
