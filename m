From: Derek Vadala <derek@cynicism.com>
Subject: RE: Growing an Array?
Date: Wed, 6 Nov 2002 11:56:17 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021106165617.656343B811@jaded.cynicism.com>
References: <A506359028CAD21191C10008C75D895C040B8844@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A506359028CAD21191C10008C75D895C040B8844@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
To: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Cc: 'Alistair Riddell' <ali@gwc.org.uk>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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


