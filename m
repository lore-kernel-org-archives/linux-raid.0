From: Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: RAID-6 support in kernel?
Date: Thu, 06 Jun 2002 13:57:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CFF4E0D.518D9089@aitel.hist.no>
References: <Pine.GSO.4.21.0206051716530.16571-100000@gecko.roadtoad.net> <3CFF1D2C.5861132C@daimi.au.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Kasper Dupont <kasperd@daimi.au.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

You're still safe from any-3 failure, and the overhead
in percent can be made arbitrarily small. 
Using nxm disks, you get (n-1)(m-1) data disks, and
(n+m-1) parity disks.
(The overhead (n+m-1)/((n-1)(m-1)) approach
0 as noth n and m grows towards infinity.

Using many few-disk arrays to build the big array
gives good chances to survive 4-disk failures too,
as few of the many 4-disk combinations take out 
two small arrays simultaneously.

I'm not sure about the write performance for such
a beast, but it should be fine for reading.  I.e.
a safe archive.

Helge Hafting
