From: John Brooks <john@fastquake.com>
Subject: Re: Inconsistent use of sectors vs 1k-blocks in sysfs and other
 places
Date: Tue, 20 Dec 2016 22:14:30 +0000
Message-ID: <20161220221430.GA19146@oldkitsune.fastquake.com>
References: <20161217051420.GA29241@oldkitsune.fastquake.com>
 <87fulkvpgf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fulkvpgf.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 19, 2016 at 09:32:00AM +1100, NeilBrown wrote:
> The code is right by definition.  As you say, mdadm uses this interface
> so we cannot change it.

Yep, I expected as much and fully agree.

> >
> > Somewhat related, suspend_{lo|hi}, resync_{min|max} attributes specify ranges
> > in sectors, but the documentation does not specify if they are ranges on the
> > array size or device size. And RAID10 may even handle resync_max differently
> > from the rest; I didn't look deeply into that but see commit c805cdecea.
>
> suspend_{lo|hi} are are array addresses
> resync_{min|max} are array addresses for RAID1 and RAID10, and they are
> device-addresses-offset-from-data_offset for RAID1 and RAID456.

Good to know. One question, is it possible for the offset or size to be
different across disks in the same array? The documentation says that the size
is "normally" the same as component_size, implying that perhaps it could be
different.

> It is bad that the documentation is incorrect and incomplete.  If you we
> to post a patch which fixed some of it, I'm sure that would be
> thankfully accepted.

I will see what I can do.

> In theory you could have a RAID1 with an odd number of sectors used in
> each component, but I doubt that happens in practice.  So you can get
> the component size in sectors by reading component_size and multiplying
> by two.

Is that within a realm of possibility worth mentioning in the docs?
