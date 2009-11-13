From: Neil Brown <neilb@suse.de>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 18:03:00 +1100
Message-ID: <19197.1188.481294.873723@notabene.brown>
References: <200911122253.01626.lrhorer@satx.rr.com>
	<200911122314.13426.lrhorer@satx.rr.com>
	<19196.63471.532066.743149@notabene.brown>
	<200911130022.57620.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from lrhorer@satx.rr.com on Friday November 13
Sender: linux-raid-owner@vger.kernel.org
To: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org, Debian mdadm maintainers <pkg-mdadm-devel@lists.alioth.debian.org>
List-Id: linux-raid.ids


(cced: to debian mdadm maintainers as I there is a problem caused by
an older version of the mdadm package that you should be aware of).

On Friday November 13, lrhorer@satx.rr.com wrote:
> On Friday 13 November 2009 12:08:47 am you wrote:
> > On Thursday November 12, lrhorer@satx.rr.com wrote:
> > > On Thursday 12 November 2009 11:12:30 pm you wrote:
> > > > On Friday November 13, neilb@suse.de wrote:
> > > > > 1/ show us what the result of --examine was.
> > > > > 2/ add -vvv to the --assemble and report the result of that.
> > > >
> > > >   3/ report the output of "mdadm -X /dev/list-of-devices"
> > >
> > > RAID-Server:/etc/cron.d# mdadm --examine /dev/sd[a-j]
> > > /dev/sda:
> > >           Magic : a92b4efc
> > >         Version : 1.2
> > >     Feature Map : 0x0
> > >      Array UUID : 5ff10d73:a096195f:7a646bba:a68986ca
> > >            Name : RAID-Server:0  (local to host RAID-Server)
> >
> > Strangely this line is unique.  Every other device has:
> > >            Name : 'RAID-Server':0
> >
> > Where do those "'"s come from???
> 
> 	I have no idea.

Well we need to find out because I think they are the problem.
This is Debian, isn't it???

> 
> > What exactly is listed in mdadm.conf for /dev/md0??
> 
> cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE /dev/sd[b-j]

As you note, this a problem.  mdadm will only look at these devices,
not at /dev/sda.
And...

> ARRAY /dev/md/0 level=raid6 metadata=1.2 num-devices=10 
> UUID=5ff10d73:a096195f:7a646bba:a68986ca name=RAID-Server:0

/dev/sda is the only one called
      RAID-Server:0
The others are all called
      'RAID-Server':0

so they won't match.  That is why it won't find these devices.

I can see how this happened now.
There Debian mdadm package (not the most recent, but some fairly
recent) has 

extra_args="--homehost='$MD_HOMEHOST' --auto-update-homehost"
in
/usr/share/initramfs-tools/scripts/local-top/mdadm

This shows a misunderstanding of shell quoting and exactly caused your
problem.  It updated the homehost on all device that were listed in
mdadm.conf to be   'RAID-Server'.  So b-j got updated but a did not.
Presumably the last time you booted /dev/sda didn't get included, so
you had to add it by hand.


> 
> I just spotted something not quite right.  Line 7 is missing a drive 
> (/dev/sda).   That shouldn't prevent it from assembling, though.
> 
> > Other than that everything looks OK.  The array hasn't been marked as
> > having a bitmap, but the bitmap seems to have been created correctly,
> > but not activated yet.
> >
> > And you didn't provide the output of
> >    mdadm --assemble -vvv ....
> 
> 	Oh, sorry!  I thought the fact I got it to assemble meant I didn't need to 
> issue the command again...

I didn't realise that you had got it to assemble.   There is no need
to repeat the command as I see exactly what is happening.
However to fix it you will need to stop the array and assemble with
   --update=homehost


> 
> 	Indeed, it won't let me issue it again.  it says:
> 
> RAID-Server:/etc/cron.d# mdadm -A /dev/md0 /dev/sd[a-j] -vvv
> mdadm: device /dev/md0 already active - cannot assemble it
> 
> 	Should I stop the arraya nd re-assemble it with -vvv?
> 
> 	Also, what about my question about the bitmap?  Should I delete it, despite 
> the fact mdadm says there isn't one, or should I attempt to add it again, or 
> should I wait until I do the checkarrray?
> 

There is nothing to delete.  Just try to add it again.
Though I would really like to know why it hangs.  If that happens
again, see if alt-sysrq-T shows anything useful.


NeilBrown
