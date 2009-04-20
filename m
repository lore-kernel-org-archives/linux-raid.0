From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 15:58:08 +1000
Message-ID: <18924.3824.677493.129885@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown>
	<51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	<18919.64597.426128.498393@notabene.brown>
	<D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	<20090417183952.GA6090@lazy.lzy>
	<20090418075436.GA2124@maude.comedia.it>
	<20090418083609.GA4436@lazy.lzy>
	<20090418101954.GA1448@maude.comedia.it>
	<20090418130656.GA3344@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Piergiorgio Sartor on Saturday April 18
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 18, piergiorgio.sartor@nexgo.de wrote:
> On Sat, Apr 18, 2009 at 12:19:54PM +0200, Luca Berra wrote:
> > i believe the num-devices is redundant since this value is already
> > stored in the superblock
> 
> I believe too. As I mentioned, it would be possible
> to edit the outcome of "--examine --scan", but not
> really wanted.
> 
> > we could change the way mdadm outputs data to put _all_ redundant
> > information in subsequent lines and keep the only required info in the
> > 'ARRAY' line,
> > so mdadm --examine --scan | grep ARRAY would be suitable for initial
> > configuration
> > or even print it only if a --verbose flag is added
> > so mdadm --examine --scan by itself would suit most need
> 
> This second option I would prefer in one way or the other.
> I mean, either "mdadm --verbose --examine --scan": all info,
> or "mdadm --quiet --examine --scan": minimal info.
> One of the two would be OK, I guess (not necessarly both).

mdadm --verbose --examine (or --detail) --scan
already provided extra info not included without --verbose, that being
the list of devices that currently comprise the array.
I have just made a modification the 3.0-devel so that level= and
devices= are not reported unless --examine is given.
That just leaves metadata=, UUID= and possibly name= container=
member=, which should all be safe to have in mdadm.conf.

Thanks for the suggestion.

> 
> > for the time being some akw magic can be used to parse 'mdadm --examine
> > --scan' and make it suitable for inclusion in mdadm.conf
> 
> This is a possibility. It would be also OK to have a
> script, delivered together with mdadm, doing this.
> I can script myself, but a "standard solution" might
> be better.
> 
> One question somehow related to this thread.
> 
> I would like to have my "fixed" RAIDs as devices with a
> specific name.
> That is, something like /dev/md/root and /dev/md/lvm (for
> /dev/md0 and /dev/md1).
> In this context, I would also like to have /dev/md0 and
> /dev/md1 free to be used by other RAID.
> Of course, I've no problem in using mdadm.conf for this,
> but it seems that it is only possible something like
> /dev/mdX or /dev/md/X.
> 
> Is this correct or there is some way to "personalize" the
> created device name?

Yes.  If you use 0.90 metadata (still the default ... I wonder if I
should change that for 3.0..) then you need to list the name in
mdadm.conf, but

  ARRAY /dev/md/foo UUID=whatever

should do what you want.

If you use 1.x metadata (e.g. 1.0), then this works nicely.

 mdadm --create /dev/md/foo --metadata 1.0 --level .....

This will store the name 'foo' in the metadata and when you assemble
the array, it will be called /dev/md/foo.
This will be a symlink to /dev/md125 or something like that, but you
don't need to care.

NeilBrown
