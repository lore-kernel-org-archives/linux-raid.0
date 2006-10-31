From: greg@enjellic.com
Subject: Re: RAID5 refuses to accept replacement drive.
Date: Tue, 31 Oct 2006 13:27:57 -0600
Message-ID: <200610311927.k9VJRvlD019580@wind.enjellic.com>
References: <neilb@suse.de>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Neil Brown <neilb@suse.de>
       "Re: RAID5 refuses to accept replacement drive." (Oct 26,  7:25am)
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Oct 26,  7:25am, Neil Brown wrote:
} Subject: Re: RAID5 refuses to accept replacement drive.

Hi Neil, hope your week is going well, thanks for the reply.

> > Environment:
> > 	Kernel: 2.4.33.3
> > 	MDADM:  2.4.1/2.5.3
> > 	MD:	Three drive RAID5 (md3)

> Old kernel, new mdadm.  Not a tested combination unfortunately.  I
> guess I should try booting 2.4 somewhere and try it out...

Based on what I found, its probably an old library issue as much as
anything.

More below.

> > Drives were shuffled to get the machine operational.  The machine came
> > up with md3 degraded.  The md3 device refuses to accept a replacement
> > partition using the following syntax:
> > 
> > mdadm --manage /dev/md3 -a /dev/sde1
> > 
> > No output from mdadm, nothing in the logfiles.  Tail end of strace is
> > as follows:
> > 
> > open("/dev/md3", O_RDWR)                = 3
> > fstat64(0x3, 0xbffff8fc)                = 0
> > ioctl(3, 0x800c0910, 0xbffff9f8)        = 0

> Those last to lines are a called to md_get_version. 
> Probably the one in open_mddev
> 
> > _exit(0)                                = ?
> 
> But I can see no way that it would exit...
> 
> Are you comfortable with gdb?
> Would you be interested in single stepping around and seeing what path
> leads to the exit?

My apologies for not being quicker on the draw, I should have gone
grovelling with gdb first.

The problem appears to be due to what must be a broken implementation
of getopt_long in the version of the installed C library.  Either that
or the reasonably complex.... :-) option parsing in mdadm is tripping
it up.

As I noted before the following syntax fails:

	mdadm --manage /dev/md3 -a /dev/sde1

After poking around a bit and watching the option parsing in gdb I
noticed that the following syntax should work:

	mdadm /dev/md3 -a /dev/sde1

I tried the latter command outside of GDB and things worked
perfectly.  The drive was added to the RAID5 array and synchronization
proceeded properly.

I then failed out a drive element on one of the other MD devices on
the machine and was able to repeat the problem.  The following refused
to work:

	mdadm --manage /dev/md1 -a /dev/sdb2

While the following worked:

	mdadm /dev/md1 -a /dev/sdb2

The getopt_long function is not picking up on the fact that -a should
have optarg set to /dev/sdb2 when the option is recognized.  Instead
optarg is set to NULL and devs_found is left at 1 rather than 2.  That
results in mdadm simply exiting without saying anything.

I know the 1.x version of mdadm we were using before processed the
'mdadm --manage' syntax properly.  This must have been the first time
we had to add a drive element back into an MD device since we upgraded
mdadm.

I would be happy to chase this a bit more or send you a statically
linked binary if you want to see what it is up to.  At the very least
it may be worthwhile to issue a warning message on exit if mdadm has
an MD device specification, a mode specification and no devices.

I remember trying to build a statically linked copy of mdadm with
dietlibc and ran into option parsing problems.  The resultant binary
would always exit complaining that a device had not been specified.  I
remember the dietlibc documentation noting that the GNU folks had an
inconsistent world view when it came to getopt processing
semantics... :-)

I suspect there is a common thead involved in both cases.

> NeilBrown

Hope the above is useful.  Let me know if you have any
questions/issues.

Happy Halloween.

Greg

}-- End of excerpt from Neil Brown

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Fools ignore complexity.  Pragmatists suffer it.  Some can avoid it.
Geniuses remove it.
                                -- Perliss' Programming Proverb #58
                                   SIGPLAN National, Sept. 1982
