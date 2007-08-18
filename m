From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: RAID6 clean?
Date: Sat, 18 Aug 2007 01:40:38 -0400
Message-ID: <200708180540.l7I5eh007322@www.watkins-home.com>
References: <18019.47167.814394.650255@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18019.47167.814394.650255@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Neil Brown
} Sent: Monday, June 04, 2007 2:59 AM
} To: Guy Watkins
} Cc: 'linux-raid'
} Subject: Re: RAID6 clean?
} 
} On Monday June 4, linux-raid@watkins-home.com wrote:
} > I have a RAID6 array.  1 drive is bad and now un-plugged because the
} system
} > hangs waiting on the disk.
} >
} > The system won't boot because / is "not clean".  I booted a rescue CD
} and
} > managed to start my arrays using --force.  I tried to stop and start the
} > arrays but they still required --force.  I then used "echo repair >
} > sync_action" to make the arrays "clean".  I can now stop and start the
} RAID6
} > array without --force.  I can now boot normally with 1 missing disk.
} >
} > Is there an easier method?  Some sort of boot option?  This was a real
} pain
} > in the @$$.
} >
} > It would be nice if there was an array option to allow an "un-clean"
} array
} > to be started.  An option that would be set in the md superblock.
} 
} Documentation/md.txt
} 
} search for 'clean' - no luck.
} search for 'dirty'
} 
} |
} |So, to boot with a root filesystem of a dirty degraded raid[56], use
} |
} |   md-mod.start_dirty_degraded=1
} |
} 
} NeilBrown
} 

Neil,
	I had this happen again.  The above worked, thanks.

	Feature request...  Allow us to set a start_dirty_degraded bit in
the superblock so we can set it and forget it.  This way it can be automatic
and per array.  What do you think?

Thanks,
Guy

