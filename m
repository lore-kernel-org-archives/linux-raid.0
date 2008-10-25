From: Neil Brown <neilb@suse.de>
Subject: Re: HELP! my raid5 ate my data!
Date: Sat, 25 Oct 2008 17:49:30 +1100
Message-ID: <18690.49530.642690.438271@notabene.brown>
References: <9512192b0810210915xa27061bkdc37e212f17c944b@mail.gmail.com>
	<5d96567b0810210930r5bc4d068mef57dcfb4a237603@mail.gmail.com>
	<9512192b0810210940v77675287od420f7ea36fbf2de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Morgan Wahl on Tuesday October 21
Sender: linux-raid-owner@vger.kernel.org
To: Morgan Wahl <morgy.wahl@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 21, morgy.wahl@gmail.com wrote:
> these lines are the only uncommented ones in mdadm.conf:
> DEVICE /dev/sd[abcd]1
> ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
> 
> mdadm -Q /dev/md0
> mdadm --examine /dev/sda1
> mdadm --examine /dev/sdb1
> mdadm --examine /dev/sdc1
> mdadm --examine /dev/sdd1
> 
> mdadm /dev/md0 --remove /dev/sdc1

If the array was not running (as I think was implied in your other
email) then this will have done nothing.

> 
> mdadm -A /dev/md0

This should have worked.  What do you get from

  mdadm -Av /dev/md0
??

> 
> mdadm --readonly /dev/md0

This is a sensible precaution.

> 
> mount /dev/md0 /mnt/temp
> (this return an error)
> e2fsck -n /dev/md0
> (lots of errors)

It does sound like it is a mess, but there is nothing obvious in
your description which would have caused it.
Maybe if you could include the output of all the "mdadm --examine"
commands?

NeilBrown
