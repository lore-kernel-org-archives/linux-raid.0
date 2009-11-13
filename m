From: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 00:22:57 -0600
Message-ID: <200911130022.57620.lrhorer@satx.rr.com>
References: <200911122253.01626.lrhorer@satx.rr.com> <200911122314.13426.lrhorer@satx.rr.com> <19196.63471.532066.743149@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.63471.532066.743149@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 13 November 2009 12:08:47 am you wrote:
> On Thursday November 12, lrhorer@satx.rr.com wrote:
> > On Thursday 12 November 2009 11:12:30 pm you wrote:
> > > On Friday November 13, neilb@suse.de wrote:
> > > > 1/ show us what the result of --examine was.
> > > > 2/ add -vvv to the --assemble and report the result of that.
> > >
> > >   3/ report the output of "mdadm -X /dev/list-of-devices"
> >
> > RAID-Server:/etc/cron.d# mdadm --examine /dev/sd[a-j]
> > /dev/sda:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
> >            Name : RAID-Server:0  (local to host RAID-Server)
>
> Strangely this line is unique.  Every other device has:
> >            Name : 'RAID-Server':0
>
> Where do those "'"s come from???

	I have no idea.

> What exactly is listed in mdadm.conf for /dev/md0??

cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE /dev/sd[b-j]

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR lrhorer@satx.rr.com

# definitions of existing MD arrays
# ARRAY /dev/md0 level=raid6 num-devices=10 
UUID=f3b19017:f584ad54:4cb502e9:37bde716

# This file was auto-generated on Fri, 21 Nov 2008 22:35:30 -0600
# by mkconf $Id$
PROGRAM /usr/bin/mdadm_notify
ARRAY /dev/md/0 level=raid6 metadata=1.2 num-devices=10 
UUID=5ff10d73:a096195f:7a646bba:a68986ca name=RAID-Server:0

I just spotted something not quite right.  Line 7 is missing a drive 
(/dev/sda).   That shouldn't prevent it from assembling, though.

> Other than that everything looks OK.  The array hasn't been marked as
> having a bitmap, but the bitmap seems to have been created correctly,
> but not activated yet.
>
> And you didn't provide the output of
>    mdadm --assemble -vvv ....

	Oh, sorry!  I thought the fact I got it to assemble meant I didn't need to 
issue the command again...

	Indeed, it won't let me issue it again.  it says:

RAID-Server:/etc/cron.d# mdadm -A /dev/md0 /dev/sd[a-j] -vvv
mdadm: device /dev/md0 already active - cannot assemble it

	Should I stop the arraya nd re-assemble it with -vvv?

	Also, what about my question about the bitmap?  Should I delete it, despite 
the fact mdadm says there isn't one, or should I attempt to add it again, or 
should I wait until I do the checkarrray?


