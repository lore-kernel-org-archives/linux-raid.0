From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 16:13:12 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16243.55544.424789.503682@notabene.cse.unsw.edu.au>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomi Orava on Friday September 26
To: Tomi Orava <tomimo+linux-raid@ncircle.nullnet.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 26, tomimo+linux-raid@ncircle.nullnet.fi wrote:
> 
> Hi everybody,
> 
> I have a slight problem here with my RAID 1+0 setup.
> One of the discs just failed and I'm unable to figure
> out why (for example) mdadm is unable to start the
> particular RAID1 (/dev/md4-submirror, failed disc is /dev/sdd).
,,,
> 
> The problem occurred while resynccing the /dev/md4 RAID1-mirror
> and of course the "master" device was the faulty one.
> The question now is, is someone capable of describing how to get
> this /dev/md4-mirror started so that I can continue copying data
> out of RAID1+0 (dev/md5) mirror ?

You need to assemble the array before it can run, so maybe:

   mdadm --assemble /dev/md4 --uid=d5c2d1f7:cf7cb245:2d9e7057:097ec133  /dev/sd*

then
   mdadm --assemble /dev/md5 /dev/md3 /dev/md4

If now, what errors do you get, and what does "cat /proc/mdstat" show?

NeilBrown
