From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0 of 8] Various MD patches to support device-mapper
 interaction
Date: Wed, 8 Jun 2011 15:21:34 +1000
Message-ID: <20110608152134.04e4c925@notabene.brown>
References: <1307486733.31279.4.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307486733.31279.4.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 07 Jun 2011 17:45:33 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
> 
> Please consider	the following patches for inclusion:

Mostly looks good. 
The last two require some changes which I have commented on separately.
If you get me updated versions of those I will put them all at least into
-next, and then see if Linus is willing to include them in -rc3.

Thanks,
NeilBrown


> 
> 1) md-no-integrity-register-if-no-gendisk.patch
> E-mail received 5/24/2011 of patch application, but it has not yet
> landed in 3.0.0-rc2
> 
> 2) md-no-sync-IO-while-suspended.patch
> E-mail received 5/24/2011 of patch application, but it has not yet
> landed in 3.0.0-rc2
> 
> 3) md-possible-typo.patch
> You mentioned you might	take this one if I changed the message instead
> of the parameter value.  I've s/ blocks/k/ - better?
> 
> 4) md-move-thread-wakeups-into-resume.patch
> No comments on this yet.
> 
> 5) md-raid1-changes-to-allow-use-by-device-mapper.patch
> No comments on this yet.
> 
> 6) md-add-sync_super-to-mddev_t-struct.patch
> This is	the patch I'm proposing	as the substitute to the 'analyze_sbs'
> patches I had originally posted.  We add a function pointer that can be
> called from device-mapper for the purposes of updating the superblock.
> (This way, the superblock and 'super_types' functions can be in
> dm-raid.c.)
> 
> 7) md-add-bitmap-support.patch
> Bitmap support for device-mapper created arrays.
> 
> 8) md-raid5-do-not-set-fullsync.patch
> A somewhat hackish way around the problem of RAID5 setting fullsync on a
> device that merely suffered a transient failure.
> 
> Thanks,
>  brassow
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

