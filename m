From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: RAID5 recoverability - Was: Interesting article
Date: Thu, 15 Jan 2009 13:51:08 +0200
Message-ID: <20090115115108.GG5643@mea-ext.zmailer.org>
References: <496E44DE.7090200@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <496E44DE.7090200@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 14, 2009 at 01:02:38PM -0700, Maurice Hilarius wrote:
> 
> I read this today:
> http://blogs.zdnet.com/storage/?p=162
> 
> Would anyone who knows enough about this care to comment?
> 
> Thanks in advance for any thoughts..

Simplistic recovery strategy is indeed to fault entire disk upon read-fail,
and then sync everything from other disks to it.   Linux does this at least
on RAID-1, my RAID-5 systems are controllers with internal software to handle
the recovery.

Smarter approach is to use RAID5(or 1) recovery from other disks on given
block, _and_ write the failed block immediately.  It is surprising how often
this makes the problem to go away!

Disk would hard-fault and drop out of array only when that fixup write, or
subsequent verifying read fails.

Even such soft-fault should raise alarm -- "Disk 5 has soft-faulted 200
times in past hour."

(Somebody has patented all of this, no doubt...)


Enhancing Linux MD to do things like I outlined above would be beneficial.


Adding periodic self-activated low-IO-priority read-scanner on array logics
would also do a world of good on array reliabilities.  But then some people
want to keep their arrays sleeping, and start them only occasionally.
Perhaps it would be better to have explicite  mdadm  option to do such scan,
and recommend adding it to crontab.

> -- 
> With our best regards,
> 
> //Maurice W. Hilarius         Telephone: 01-780-456-9771/
> /Hard Data Ltd.               FAX:       01-780-456-9772/
> /11060 - 166 Avenue           email:maurice@harddata.com/
> /Edmonton, AB, Canada/
> /     T5X 1Y3/

  /Matti Aarnio
