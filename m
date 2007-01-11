From: Neil Brown <neilb@suse.de>
Subject: Re: FailSpare event?
Date: Fri, 12 Jan 2007 09:23:41 +1100
Message-ID: <17830.47341.560158.521091@notabene.brown>
References: <eo6cn8$5se$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike on Thursday January 11
Sender: linux-raid-owner@vger.kernel.org
To: Mike <mikee@mikee.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 11, mikee@mikee.ath.cx wrote:
> Can someone tell me what this means please? I just received this in
> an email from one of my servers:
> 
....

> 
> A FailSpare event had been detected on md device /dev/md2.
> 
> It could be related to component device /dev/sde2.

It means that mdadm has just noticed that /dev/sde2 is a spare and is faulty.

You would normally expect this if the array is rebuilding a spare and
a write to the spare fails however...

> 
> md2 : active raid5 sdf2[4] sde2[5](F) sdd2[3] sdc2[2] sdb2[1] sda2[0]
> 560732160 blocks level 5, 256k chunk, algorithm 2 [5/5] [UUUUU]

That isn't the case here - your array doesn't need rebuilding.
Possible a superblock-update failed.  Possibly mdadm only just started
monitoring the array and the spare has been faulty for some time.

> 
> Does the email message mean drive sde2[5] has failed? I know the sde2 refers
> to the second partition of /dev/sde. Here is the partition table

It means that md thinks sde2 cannot be trusted.  To find out why you
would need to look at kernel logs for IO errors.

> 
> I have partition 2 of drive sde as one of the raid devices for md. Does the (S)
> on sde3[2](S) mean the device is a spare for md1 and the same for md0?
> 

Yes, (S) means the device is spare.  You don't have (S) next to sde2
on md2 because (F) (failed) overrides (S).
You can tell by the position [5], that it isn't part of the array
(being a 5 disk array, the active positions are 0,1,2,3,4).

NeilBrown
