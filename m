From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Thu, 6 Jan 2011 15:01:06 -0600
Message-ID: <30341381-93AE-437A-B0A3-971224BAED3C@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com> <20101221141443.5aea0b12@notabene.brown> <20110105223628.GA13164@redhat.com> <20110106214645.2bd321f4@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110106214645.2bd321f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[sorry, this msg bounced earlier today]

On Jan 6, 2011, at 4:46 AM, NeilBrown wrote:
>
> Patches 1 and 2 aren't really needed - I feel inclined not to remove  
> that
> stuff until all the dust settles..  So I'll put them at the bottom  
> of my
> queue and bring them forward in a couple of releases if that seems
> appropriate.

No problem.

> Patch 3 I'll push out through my tree shortly.

thanks

> The rest I am happy with going out through 'dm' to -next and beyond  
> whenever
> you like.
>
> However I will take this opportunity to suggest that the raid  
> parameters
> might need a bit of review before they are finalised.
>
> The possible parameters are as follows:
> <chunk_size>		Chunk size in sectors.
> [[no]sync]		Force/Prevent RAID initialization
> [rebuild <idx>]	Rebuild the drive indicated by the index
> [daemon_sleep <ms>]	Time between bitmap daemon work to clear bits
> [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
> [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
> [max_write_behind <value>]		See '-write-behind=' (man mdadm)
> [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
>
>
> 'rebuild idx' only allows one device to be rebuilt at a time.  With  
> RAID6 it
> is possible that two devices can be ready for rebuild, in which case  
> we would
> want to rebuild both of them.

In which case, you can specify the parameter twice:
"... rebuild 0 rebuild 1..."
No problem there, I think.

> Also if you stop an array during a rebuild you really want to start  
> again
> where you were up to.

This is kept in the superblock (forthcoming patches).  In the case  
where metadata devices are not specified (or can't be specified, as in  
this initial set of patches), the user has two choices: 1) allow the  
array to completely resync, or 2) specify [no]sync.

> Most general solution would be to combine the rebuild information  
> with the
> list of component devices - either a sector number or something to  
> indicate
> that the rebuild it complete (which could be just a v.big sector  
> number).

Is there something more to this, or is the above comment suitable for  
this also?

> I'd much prefer 'daemon_sleep' to be in seconds, we decimals  
> supported if
> needed.

I had this in seconds originally, but device-mapper tables already  
have a precedent for specifying things in ms.  We don't want to have  
each target pick their own units.  (A similar thing can be said for  
values given in sectors.  We may have wanted kiB or B, but sectors is  
the standard.)

>
> Also:
>
> 3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>
>
> This doesn't allow offsets into the various devices like dm-stripe,
> dm-linear, dm-raid1 all do.

This is a conscious choice.  The offset was discarded because it is  
unneeded.

  brassow
