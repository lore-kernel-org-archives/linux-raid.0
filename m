From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 15:06:56 +0200
Message-ID: <20090418130656.GA3344@lazy.lzy>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090418101954.GA1448@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 12:19:54PM +0200, Luca Berra wrote:
> i believe the num-devices is redundant since this value is already
> stored in the superblock

I believe too. As I mentioned, it would be possible
to edit the outcome of "--examine --scan", but not
really wanted.

> we could change the way mdadm outputs data to put _all_ redundant
> information in subsequent lines and keep the only required info in the
> 'ARRAY' line,
> so mdadm --examine --scan | grep ARRAY would be suitable for initial
> configuration
> or even print it only if a --verbose flag is added
> so mdadm --examine --scan by itself would suit most need

This second option I would prefer in one way or the other.
I mean, either "mdadm --verbose --examine --scan": all info,
or "mdadm --quiet --examine --scan": minimal info.
One of the two would be OK, I guess (not necessarly both).

> for the time being some akw magic can be used to parse 'mdadm --examine
> --scan' and make it suitable for inclusion in mdadm.conf

This is a possibility. It would be also OK to have a
script, delivered together with mdadm, doing this.
I can script myself, but a "standard solution" might
be better.

One question somehow related to this thread.

I would like to have my "fixed" RAIDs as devices with a
specific name.
That is, something like /dev/md/root and /dev/md/lvm (for
/dev/md0 and /dev/md1).
In this context, I would also like to have /dev/md0 and
/dev/md1 free to be used by other RAID.
Of course, I've no problem in using mdadm.conf for this,
but it seems that it is only possible something like
/dev/mdX or /dev/md/X.

Is this correct or there is some way to "personalize" the
created device name?

Thanks,

bye,

-- 

piergiorgio
