From: Stef Telford <stef@chronozon.artofdns.com>
Subject: Re: 2.5.62 oops and Raid-5
Date: 20 Feb 2003 19:42:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1045788141.20059.18.camel@Indra.hades>
References: <20030218001930.AFB21457CC@chronozon.artofdns.com>
	 <15953.51012.470042.33785@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15953.51012.470042.33785@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil wrote:
> Hmm... I cannot see how recent changes would have affected this, but
> does the following patch help?

actually, believe it or not but the patch made things
worse ?! that being said, i removed isapnp (as that 
was also mentioned in one of the symoops) and the
oops on mount went away. Notice that the oops on
mount didnt stop the raid5 from being mounted
and accessible, jst it was annoying to see
an oops on mount. I can understand the 
hotplug causing problems with raid (sudden
appearance of an entire 240gig raid5 disk
could cause hotplug to 'fire events' :) but
isapnp ? very curious indeed.

This of course means that i cant use my isa NIC, but
i can live without it. so no problem there.

one last thing that i noticed going from 2.5.58 to
2.5.62, if i do a cat /proc/mdstat it will stop at
around md198 (from md255 down to and including md198)
and the syslog will generate this error:

Feb 19 14:48:50 survivor kernel: proc_file_read: Apparent buffer
overflow!

This isnt really a 'major problem' for me, and i should
point out that even though md0 is mounted, it is currently
in degraded status and is being rebuilt. Incase that
makes any difference (jst in case ;)

regards
Stef

