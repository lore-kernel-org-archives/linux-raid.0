From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 09 Dec 2011 13:38:13 -0600
Message-ID: <4EE263A5.3010107@hardwarefreak.com>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/7/2011 2:42 PM, Eli Morris wrote:

>  I thought maybe someone could help me out. I have a 16 disk software RAID that we use for backup. This is at least the second time this happened- all at once, four of the drives report as 'removed' when none of them actually were. These drives also disappeared from the 'lsscsi' list until I restarted the disk expansion chassis where they live. 
> 
> These are the dreaded Caviar Green drives.

Eli, you masochist.  ;)

> 2) Any idea on how to stop this from happening again?

You already know the answer.  You're simply ignoring/avoiding it.  It
was given to you by a half dozen imminently qualified people over on the
XFS list when you had an entire chassis blow out many months ago, losing
many students' doctoral thesis data IIRC.  I've since used that saga
many times as evidence against using "green" drives, esp the WD models,
for anything but casual desktop storage.

The only permanent fix is to replace the drives with models meant for
your use case, such as the WD RE4 or Seagate Constellation, to name two.
 Unfortunately, right now, due to the flooding in Thailand, the price of
all drives across the board has doubled as a result of constricted
supply.  Given you don't have funds in the budget to replace them
anyway, at any price, it seems you are simply screwed in this regard.

One thing I would suggest though, if you got the vendor tech's statement
in writing WRT the WD Green drives being compatible with their RAID
chassis, I'd lean hard on them to fix the issue, as it was their rec
that prompted your purchase, causing this problem in the first place, no?

-- 
Stan
