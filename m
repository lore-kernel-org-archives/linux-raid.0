From: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Subject: RE: Growing an Array?
Date: Wed, 06 Nov 2002 12:08:40 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A506359028CAD21191C10008C75D895C040B884A@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Derek Vadala' <derek@cynicism.com>, Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


One point of clarification that probably makes no difference.  I am not trying to go 

From:   6 X 73GB    To:   7 x 73GB  

but rather

From:	  6 X 73GB 	  To:   6 x 180GB  



-----Original Message-----
From: Derek Vadala [mailto:derek@cynicism.com]
Sent: Wednesday, November 06, 2002 11:56 AM
To: Huntress Gary B NPRI
Cc: 'Alistair Riddell'; 'linux-raid@vger.kernel.org'
Subject: RE: Growing an Array?


On Wed, 6 Nov 2002, Huntress Gary B NPRI wrote:

> My array is currently 6 X 73GB.
>
> I think you are saying that I can do this now using resize2fs?  I think
> I pessimistically assumed that tool was destructive.

Sort of...

Alistair's point was that growing an array takes a long time, so the
backup and restore process might not be as slow as you think. I suspect it
will take the better part of a day to do what you have proposed (add a
disk to a 6x73GB RAID-5).

The first step is to use raidreconf to grow the array (add a disk). This
is the slow part of the process.

Get raidreconf here http://unthought.net/raidreconf/

It also ships with RedHat 8.0 (raidtools-1.00.2, anyone know why this
version of raidtools still hasn't shown up in the usual spots???)

Once the array is resized, you then need to resize the filesystem. This
typically takes very little time and is done using the utility
appropriate for your FS. So for ext2 you us resize2fs.

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

