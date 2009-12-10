From: Neil Brown <neilb@suse.de>
Subject: Re: Growing Linear RAID
Date: Thu, 10 Dec 2009 12:34:37 +1100
Message-ID: <20091210123437.63cbc24b@notabene.brown>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
	<20091209153002.GA5586@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091209153002.GA5586@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Dec 2009 15:30:02 +0000
Robin Hill <robin@robinhill.me.uk> wrote:

> On Wed Dec 09, 2009 at 08:31:54PM +0530, senthilkumar.muthukalai@wipro.com wrote:
> 
> > Hi,
> > 
> > I am trying to add a disk to a Linear Raid which was created with 2
> > disks.
> > We use linux-2.6.18 and mdadm-2.6.4.
> > I guess these support the above mentioned disk addition.
> > 
> Why do you guess this?  The manual page should tell you exactly what's
> supported, and even mdadm 3.1.1 makes no mention of support for growing
> linear RAID:
> 
>         Currently supported growth options including changing the active
>         size of component devices and  changing  the  number  of active
>         devices  in RAID levels 1/4/5/6, changing the RAID level between
>         1, 5, and 6, changing the chunk size and layout  for RAID5  and
>         RAID5, as well as adding or removing a write-intent bitmap
> 
>

Hmm... guess I should update that documentation, shouldn't I .....

Adding a device to a linear is supported since 2.6.18.

NeilBrown
