From: klink@clouddancer.com (Colonel)
Subject: (unknown)
Date: Thu,  6 Jun 2002 11:10:55 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020606181055.4CDB38350@phoenix.clouddancer.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Colonel <klink@clouddancer.com>
To: linux-raid@vger.kernel.org
In-reply-to: <3CFF4E0D.518D9089@aitel.hist.no> (message from Helge Hafting on
	Thu, 06 Jun 2002 13:57:01 +0200)
Subject: Re: RAID-6 support in kernel?
Reply-to: klink@clouddancer.com
References: <Pine.GSO.4.21.0206051716530.16571-100000@gecko.roadtoad.net> <3CFF1D2C.5861132C@daimi.au.dk> <3CFF4E0D.518D9089@aitel.hist.no>

   Date:	Thu, 06 Jun 2002 13:57:01 +0200
   From: Helge Hafting <helgehaf@aitel.hist.no>

   Kasper Dupont wrote:
   > 
   > Derek Vadala wrote:
   > >
   > >   RAID-1 --------> RAID-5 (D0,D1,D2,D3,P0)
   > >               |--> RAID-5 (D0,D1,D2,D3,P0)
   > >    (four disks used for data, only one from each RAID-5 can fail)
   > 
   > Wrong, any three disks can fail. If the one RAID has only
   > one faulty disk, the other RAID can have any number of
   > faulty disks without loosing data.
   > 
   This is a bit excessive, you waste more than half your disks
   for 3-disk safety.  Consider raid-5 on top of raid-5.

SLOW

   I'm not sure about the write performance for such
   a beast, but it should be fine for reading.  I.e.
   a safe archive.

Generally, non-RAID5 designs are interested in speed, the reliability
bonuses that come from particlar architectures are merely iceing on
the cake.  RAID5 write operations require parity computation and
store, which involve more disks than these designs -- thus slow
(relatively speaking, you need the load to notice the difference).

