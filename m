From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 04:39:41 -0600
Message-ID: <4D1C616D.8030904@hardwarefreak.com>
References: <20101230082356.GC2986@bitwizard.nl> <4D1C470E.4080406@crc.id.au> <20101230094230.GE2986@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101230094230.GE2986@bitwizard.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rogier Wolff put forth on 12/30/2010 3:42 AM:
> On Thu, Dec 30, 2010 at 07:47:10PM +1100, Steven Haigh wrote:
>> Maybe I'm not quite understanding right, however you can easily do RAID6 
>> with 4 drives. That will give you two redundant, effectively give you 
>> RAID5 if I drive fails, and save buttloads of messing around...
> 
> Steven, My friend has a server where the drives take up to a third of
> a second to respond. When asking for help, everybody pounced on us:
> - NEVER use raid5 for a server doing small-file-io like a mailserver.
>   (always use RAID10). 
> 
> So apparently RAID5 (and by extension RAID6) is not an option for some
> systems.
> 
> I'm willing to tolerate the RAID4 situation during the time that it
> takes me to replace the drive.

Any RAID scheme that uses parity is less than optimal, and up to
horrible, for heavy random IO loads.  As always, this depends on "how
heavy" the load is.  For up to a few hundred constant IOPS you can get
away with parity RAID schemes.  If you need a few thousand or many
thousand IOPS, better stay away from parity RAID.

This includes RAID 3 and 4.  Both of these are now defunct because using
a dedicated disk for storing parity information for an array yields the
same or very slightly higher reliability than using a single disk (I
don't have the equation in front me to give exact probability of
failure).  Regardless, if the RAID 3/4 parity disk fails you lose the array.

If your friend's web server isn't going to see a ton of traffic, why
does he need anything beyond a 2 way mirror with a spare?  Paraniod?  Do
a 3 way mirror.  A mirrored pair of 10k RPM SATA drives should be more
than sufficient for most webservers, which typically gain their
performance from lots of buffer cache, not from fast disks.

If would help if we knew more about the specific web app he's hosting,
its IO patterns, and anticipated load once in production.  Unless he's
got a super complex (read inefficient) cgi/database back end my
recommendation of a pair of mirrored drives, stands.  7.2k would
probably be fine, 10k gives a little wiggle room if you underestimate
your load target, or the app turns out to be even less efficient that
anticipated.

-- 
Stan
