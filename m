From: Gordon Henderson <gordon@drogon.net>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 21:19:37 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306272111500.32150-100000@unicorn.drogon.net>
References: <3841.208.48.139.163.1056738220.squirrel@www.greenhydrant.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3841.208.48.139.163.1056738220.squirrel@www.greenhydrant.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 Jun 2003, David Rees wrote:

> Gordon Henderson said:
> >
> > Eg. the PC I'm currently typing this email on is 100 miles away and I
> > don't particularly want to drive to it to fix it if a disk fails...
> >
> > gordon @ unicorn: df -h /
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/md0              236M   20M  204M   9% /
> >
> > gordon @ unicorn: cat /proc/mdstat
> > ...
> > md0 : active raid1 hdc1[1] hda1[0]
> >       249856 blocks [2/2] [UU]
> > ...
>
> So what do you do when /dev/hda fails and the computer won't reboot?  Have
> you managed to get it to boot off /dev/hdc when /dev/hda isn't available?

Yes. Works a treat. No point doing stuff if you don't test it enough to
trust it.

You do need a modern mobo/BIOS combination that will boot off something
other than the first IDE drive, but thats been fairly standard for a few
years now IIRC.

I've recently built another system with 5 IDE drives; hde,g,i,k,m and it
boots off e which is mirrored on i and that boots also when e isn't
present.

> Not having to worry about these sorts of things is one reason it's nice to
> have hardware RAID for at least the boot device.

You do have a valid point there though, especially on older system that
can't do this. Maybe SCSI too - I haven't had a chance to build an
all-SCSI system for some time, but I get a chance in a few weeks time, so
that'll be nice to experiment with.

Gordon

