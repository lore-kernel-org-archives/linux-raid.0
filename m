From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: replace disk in raid5 without linux noticing?
Date: Fri, 21 Apr 2006 19:25:18 -0300
Message-ID: <17481.23502.962814.840550@fisica.ufpr.br>
References: <200604191631.04305.Dexter.Filmore@gmx.de>
	<e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
	<200604212023.30855.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200604212023.30855.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore (Dexter.Filmore@gmx.de) wrote on 21 April 2006 20:23:
 >Am Mittwoch, 19. April 2006 18:31 schrieb Shai:
 >> On 4/19/06, Dexter Filmore <Dexter.Filmore@gmx.de> wrote:
 >> > Let's say a disk in an array starts yielding smart errors but is still
 >> > functional.
 >> > So instead of waiting for it to fail completely and start a sync and
 >> > stress the other disks, could I clone that disk to a fresh one, put the
 >> > array offline and replace the disk?
 >>
 >> Hi,
 >>
 >> Why can't you just mark that drive as failed, remove it and hotadd a
 >> new drive to replace the failed drive?
 >
 >Well, resync stresses the other disks a lot. If that can be avoided, I'd 
 >rather do so.

I'm not sure I understand what you want but you certainly can:

stop the array
dd warning disk => new one
remove warning disk
assemble the array again with the new disk

The inconvenience is that you don't have the array during the copy.

Perhaps you could also just change the first step to "put the array in
read-only mode". This of course means your filesystem must be mounted
ro but at least you can read from it. For this to work md must not
make any changes to the disks, in particular it must not change the
superblocks if a disk fails. I don't know if this is what happens.
