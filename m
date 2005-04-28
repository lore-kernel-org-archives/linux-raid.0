From: Stefan Muenkner <stefan.muenkner@web.de>
Subject: ATA Raid on a Dual Boot (Win 2K and Linux [kernel 2.6])?
Date: Thu, 28 Apr 2005 16:40:22 +0200
Message-ID: <4270F5D6.2060004@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

lately my hard disks started reaching a fill level where I consider
buying some new ones.  Linux has been flawlessly running on a SW raid-1
for almost 5 years now (thanks a bunch to all the ones who contributed),
but I always felt the lack of having such a solution under win 2K.
Since there are some rather inexpensive (S-)ATA-Raid  cards around I
thought about buying one of those to finally mirror the Win-Partitions
(I know the cards suck re preformance and all the rest of it).  As far
as I know, using kernel 2.6 (probably SuSE 9.2/9.3), there will be only
dmraid supporting ataraid, but I actually could also live very well with
a sw-raid solution (in fact I did for quite some time) and not be seeing
the Windows partitions from Linux at all. So my question is the following:

Has anybody experience with the following setup:

- I would like to set up the two disks as a mirror raid set using the
ATA-Raid card.
- A reasonable portion of the raid-set will then be partionend and used
by windows.
- (Probably) I would actually use a DOS/Win based program to
pre-partition the rest of the mirrored disks for Linux
- the remaining Linux partitions will then be used as a SW-Raid-1 set
(with a LVM on top of it?).

As far as I know, Linux should be seeing all the partitions made for the
"hardware" raid windows setup as being separate partitions on the two
hard disks (identical layout). So I should be able to mirror them using
sw-raid.

Has anybody done that? Is there anything that looks like it will be
impossible to do? Any hardware I should avoid?

I am aware that I will probably do a lot of manual tweaking during the
first Linux install, but I think I can handle that :-).  Before buying
all that stuff and put in the effort it would be reassuring if I knew
it's feasible....

Thanks in advance,

  Stefan
