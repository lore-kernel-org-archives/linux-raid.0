From: Neil Brown <neilb@suse.de>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Wed, 10 Jun 2015 10:19:42 +1000
Message-ID: <20150610101942.0bc26a25@home.neil.brown.name>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzj4glajs.fsf@jes.lga.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

On Wed, 03 Jun 2015 17:57:43 -0400
Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Wed, 03 Jun 2015 16:20:21 -0400 Jes Sorensen
> > <Jes.Sorensen@redhat.com> wrote:
> >
> >> Neil,
> >> 
> >> I was running testing on the current 4.1-rc6 tree (Linus' top of
> >> trunk 8cd9234c64c584432f6992fe944ca9e46ca8ea76) and I am seeing
> >> the following OOPS which is reproducible.
> >> 
> >> It shows up when running the mdadm test suite, 07changelevelintr
> >> to be specific.
> >> 
> >> Is this something you have seen?
> >> 
> >> Cheers,
> >> Jes
> >> 
> >> ------------[ cut here ]------------
> >> kernel BUG at drivers/md/raid5.c:5391!
> >
> > No, I haven't seen that.  And I've been running the test suite
> > quite a bit lately.
> >
> > Can you get it to print out the relevant numbers?  Include
> > readpos/writepos/safepos too.
> 
> This enough? Let me know if you need more.
> 
> I suspect this started happening with the changes that went in between
> 4.1-rc5 and 4.1-rc6. I will try to bisect it tomorrow.
> 
> Cheers,
> Jes
> 
> mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 stripe_addr:
> fffffffffffffdff, sector_nr 0, readpos 511, writepos -513, safepos
> 512  

These numbers suggest that conf->reshape_progress divided by
"data_disks" or "new_data_disks" is -1 - or really the unsigned
equivalent, which is MaxSectors.
But unless data_disks is 1, ->reshape_progress must really be -2 or -3
or something.
So maybe if you could confirm the values of ->reshape_progress,
data_disks, and new_data_disks, that might help.


I don't think ->reshape_progress could get a negative value in any way
except by being assigned MaxSectors.  And that only happens when the
reshape has really completely finished.

So it looks like some sort of race.  I have other evidence of a race
with the resync/reshape thread starting/stopping.  If I track that
down it'll probably fix this issue too.

Thanks,
NeilBrown
