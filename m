From: Neil Brown <neilb@suse.de>
Subject: Re:  sdc1 does not have a valid v0.90 superblock, not importing!
Date: Wed, 11 Aug 2010 21:06:03 +1000
Message-ID: <20100811210603.065284c8@notabene>
References: <835034.72836.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <835034.72836.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: jd_hardcastle@yahoo.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 Aug 2010 02:55:44 -0700 (PDT)
Jon Hardcastle <jd_hardcastle@yahoo.com> wrote:

> (my first attempt appears to have been bounced as the spam checker thought it had HTML in it?!)

odd... came through ok for me the first time.

> 
> Help!
> 
> Long story short - I was watching a movie off my RAID6 array. Got a smart error warning

> Aug 10 22:00:07 mangalore kernel: raid5: cannot start dirty degraded array for md4

This is the current problem.  The array is dirty and degraded so there could
theoretically be undetectable corruption.  Chance is quite low but it is
there so md won't start with out you acknowledging the risk by giving the
--force flag to mdadm --assemble.
Only do that if you are confident that your hardware is working correctly.

> It appears sdc has an invalid superblock?
> 
> This is the 'examine' from sdc1 (note the checksum)
> 
> /dev/sdc1:
.....
>       Checksum : b335b4e3 - expected b735b4e3

Single bit error.  That isn't good as it means some bit of memory or some bit
on some bus somewhere cannot be trusted.
It could be a transient thing and will never happen again.  Or maybe not.
Given the smart errors and the fact that you have had problems with the drive
before it seem very likely that the problem is in that drive.  I suggest
unplugging it and leaving it unplugged.  Some memory buffer in the drive is
probably marginal.  I don't think they use ECC memory.

> 
> Anyways... I am ASSUMING mdadm has not assembled the array to be on the safe side? i have not done anything.. no force... no assume clean.. I wanted to be sure?

You assume correctly.

> 
> Should i remove sdc1 from the array? It should then assemble? I have 2 spare drives that I am getting around to using to replace this drive and the other 500GB.. so should I remove sdc1... and try and re-add or just put the new drive in?
> 
> atm I have 'stop'ped the array and got badblocks running....
> 

Remove sdc and assemble the array with --force, and get a new device to
replace /dev/sdc as soon as possible.

NeilBrown
