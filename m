From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 clean?
Date: Mon, 4 Jun 2007 16:59:11 +1000
Message-ID: <18019.47167.814394.650255@notabene.brown>
References: <H00000670006c6c4.1180913607.www.korstad.net@MHS>
	<200706040647.l546ldc14291@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy Watkins on Monday June 4
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday June 4, linux-raid@watkins-home.com wrote:
> I have a RAID6 array.  1 drive is bad and now un-plugged because the system
> hangs waiting on the disk.
> 
> The system won't boot because / is "not clean".  I booted a rescue CD and
> managed to start my arrays using --force.  I tried to stop and start the
> arrays but they still required --force.  I then used "echo repair >
> sync_action" to make the arrays "clean".  I can now stop and start the RAID6
> array without --force.  I can now boot normally with 1 missing disk.
> 
> Is there an easier method?  Some sort of boot option?  This was a real pain
> in the @$$.
> 
> It would be nice if there was an array option to allow an "un-clean" array
> to be started.  An option that would be set in the md superblock.

Documentation/md.txt

search for 'clean' - no luck.
search for 'dirty'

|
|So, to boot with a root filesystem of a dirty degraded raid[56], use
|
|   md-mod.start_dirty_degraded=1
|

NeilBrown

