From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 refuses to accept replacement drive.
Date: Thu, 26 Oct 2006 07:25:27 +1000
Message-ID: <17727.54855.468131.528457@cse.unsw.edu.au>
References: <200610251652.k9PGq5tt032608@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from greg@enjellic.com on Wednesday October 25
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 25, greg@enjellic.com wrote:
> Good morning to everyone, hope everyone's day is going well.
> 
> Neil, I sent this to your SUSE address a week ago but it may have
> gotten trapped in a SPAM filter or lost in the shuffle.

Yes, resending is always a good idea if I seem to be ignoring you.

(people who are really on-the-ball will probably start telling me it is a
resend the first time they mail me. I probably wouldn't notice.. :-)

> 
> I've used MD based RAID since it first existed.  First time I've run
> into a situation like this.
> 
> Environment:
> 	Kernel: 2.4.33.3
> 	MDADM:  2.4.1/2.5.3
> 	MD:	Three drive RAID5 (md3)

Old kernel, new mdadm.  Not a tested combination unfortunately.  I
guess I should try booting 2.4 somewhere and try it out...

> 
> A 'silent' disk failure was experienced in a SCSI hot-swap chassis
> during a yearly system upgrade.  Machine failed to boot until 'nobd'
> directive was given to LILO.  Drive was mechanically dead but
> electrically alive.
> 
> Drives were shuffled to get the machine operational.  The machine came
> up with md3 degraded.  The md3 device refuses to accept a replacement
> partition using the following syntax:
> 
> mdadm --manage /dev/md3 -a /dev/sde1
> 
> No output from mdadm, nothing in the logfiles.  Tail end of strace is
> as follows:
> 
> open("/dev/md3", O_RDWR)                = 3
> fstat64(0x3, 0xbffff8fc)                = 0
> ioctl(3, 0x800c0910, 0xbffff9f8)        = 0

Those last to lines are a called to md_get_version. 
Probably the one in open_mddev

> _exit(0)                                = ?

But I can see no way that it would exit...

Are you comfortable with gdb?
Would you be interested in single stepping around and seeing what path
leads to the exit?

Another option is to use mdadm-1.9.0.  That is likely to be more
reliable.

NeilBrown
