From: Alvin Oga <aoga@mail.Linux-Consulting.com>
Subject: Re: raid5 - failed disks
Date: Fri, 1 Apr 2005 03:04:21 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050401025816.30940A-100000@Maggie.Linux-Consulting.com>
References: <20050401105538.GI82728@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050401105538.GI82728@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Fri, 1 Apr 2005, Andy Smith wrote:

> This seems like an awful lot of disks to have in a raid 5 with no
> hot spares, to me, but then I am fairly new to RAID issues so maybe
> I am wrong.. but I would much rather have raid 10.

i'd say its an over kill .. but thats what they have ..
 
> Technically it's screwed but it could be possible to recover it with
> some losses.. I've fortunately never yet had to do that, maybe
> someone who has could answer more fully.

unfortunately for me, i'm always inheriting broken systems
and told to "fix it" with no budget, etc, etc..

> > - i think 4x 300GB ide disks is better ( less likely to fail ?? )
> 
> Hard to say.. the typical IDE disk is usually regarded as less
> reliable than the typical SCSI disk, and also there are then less
> spindles per array so the performance may be worse.

i alwyas try to have 2 live copies of the same data on 
different servers... different cities if possible ...
	- the bigger the data, 1TB, 10TB, 50TB, the more
	copies i would have locally 

for me, i've had good luch with ide disks

for me, all my failed disk subsystems has all ( say 75% ) been scsi
... and i kept all the dead disks to show it
	- and for fairness, we'll have to ignore the superbad
	ibm deathstars

> If you're running the disks in an environment that is too hot for
> them then I think you are wasting money by just throwing more disks
> (of any sort) at it.

well ... yup.. but some people like "name brand" and live with their
"bad" rules given out by "name brand"  vs using something that is better
from not-so-big-of-a-name-brand including office/colo spaces
that is better
	- it's a bad office bldg in terms of computer's livelyhood

- give it time ... 

c ya
alvin 

