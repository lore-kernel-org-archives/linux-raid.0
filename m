From: Marc MERLIN <marc@merlins.org>
Subject: Re: Intent Bitmap size and performance
Date: Thu, 6 Feb 2014 11:05:19 -0800
Message-ID: <20140206190519.GE25441@merlins.org>
References: <20140202003915.GB25441@merlins.org>
 <20140202005646.GC25441@merlins.org>
 <20140202172832.30e33c05@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140202172832.30e33c05@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 02, 2014 at 05:28:32PM +1100, NeilBrown wrote:
> On Sat, 1 Feb 2014 16:56:46 -0800 Marc MERLIN <marc@merlins.org> wrote:
> 
> > On Sat, Feb 01, 2014 at 04:39:15PM -0800, Marc MERLIN wrote:
> > > How can I tell I got the size for my array size?
> > 
> > Aah, the clue seems to be in the kernel logs:
> > [669348.274368] md7: bitmap file is out of date (0 < 38029) -- forcing full recovery
> > [669348.299174] created bitmap (15 pages) for device md7
> > [669348.316720] md7: bitmap file is out of date, doing full recovery
> > [669348.380555] md7: bitmap initialized from disk: read 1 pages, set 29809 of 29809 bits
> > 
> > If I got the math right, 30K bits for 8TB is one bit per 266MB.
> > 
> > Given that, I'm going to assume that this is not going to impact system
> > performance much for most operations.
> > 
> > Is my assumption and conclusion correct?
> > 
> > Thanks,
> > Marc
> 
> You can also use "mdadm --examine-bitmap" on one of the component devices to
> get more details about the bitmap.

Thanks, I had managed to miss this in the man page.

Argh, not good then, see:
gargamel:~# mdadm --examine-bitmap /dev/md5
        Filename : /dev/md5
           Magic : 534b554c
mdadm: invalid bitmap magic 0x534b554c, the bitmap file appears to be corrupted
         Version : 16826042
mdadm: unknown bitmap version 16826042, either the bitmap file is corrupted or you need to upgrade your tools
gargamel:~# mdadm --examine-bitmap /dev/md8
        Filename : /dev/md8
           Magic : 534b554c
mdadm: invalid bitmap magic 0x534b554c, the bitmap file appears to be corrupted
         Version : 16826042
mdadm: unknown bitmap version 16826042, either the bitmap file is corrupted or you need to upgrade your tools

md8 I just created a few weeks ago.
md5 is old-ish but I just added the bitmap with --grow.

kernel: 3.12.7
gargamel:~# mdadm --version
mdadm - v3.3 - 3rd September 2013

gargamel:~# apt-get install -t unstable mdadm
Reading package lists... Done
Building dependency tree       
Reading state information... Done
mdadm is already the newest version.

Is debian unstable too old, or do I have another bug?

> My rule-of-thumb (base on zero hard evidence) is that one bit should
> correspond to approximately 1 second of IO.  Your bits correspond to 2 or 3
> seconds so that is certainly the right ball park.
> 
> As always with RAID, performance is highly dependent on load.
> It is quite easy to add and remove bitmaps to/from a live md array so
> testing the effect on a particular workload is not that hard.
> 
> The default mdadm chooses is a bit complex.  It first chooses an amount of
> space to reserve for the bitmap, the it figures what chunk size will allow
> the bits to fit in the available space.  Then makes sure that it as least
> 64Meg.

Thanks for explaining.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
