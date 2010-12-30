From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 10:42:30 +0100
Message-ID: <20101230094230.GE2986@bitwizard.nl>
References: <20101230082356.GC2986@bitwizard.nl> <4D1C470E.4080406@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D1C470E.4080406@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 30, 2010 at 07:47:10PM +1100, Steven Haigh wrote:
> Maybe I'm not quite understanding right, however you can easily do RAID6 
> with 4 drives. That will give you two redundant, effectively give you 
> RAID5 if I drive fails, and save buttloads of messing around...

Steven, My friend has a server where the drives take up to a third of
a second to respond. When asking for help, everybody pounced on us:
- NEVER use raid5 for a server doing small-file-io like a mailserver.
  (always use RAID10). 

So apparently RAID5 (and by extension RAID6) is not an option for some
systems.

I'm willing to tolerate the RAID4 situation during the time that it
takes me to replace the drive.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
