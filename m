From: Neil Brown <neilb@suse.de>
Subject: Re: Combining OCFS2 with Linux software RAID-0?
Date: Fri, 11 Dec 2009 18:33:33 +1100
Message-ID: <20091211183333.09b48bbd@notabene.brown>
References: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com>
	<20091210123703.71b47ce7@notabene.brown>
	<20091211071526.GA4062@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091211071526.GA4062@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Dec 2009 08:15:26 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Thu, Dec 10, 2009 at 12:37:03PM +1100, Neil Brown wrote:
> >On Wed, 9 Dec 2009 15:03:11 -0800
> >> Has anybody tried something like this?  Are there alternative RAID-0
> >> solutions for Linux that would be expected to work?
> >
> >For RAID0 or LINEAR, this should work - give it a try.
> >
> _with_ a superblock? or without?

Either.

> what happens if one node modifies the superblock while the other is
> running.

Once a RAID0 has been created, there is never any need to modify the
superblock, and I'm fairly sure we don't.

> 
> >It might work for RAID1 one day to, but is unlikely to ever work for 
> >RAID5.
> With an external metadata handler i believe it would be possible to
> support up to raid1, maybe 10.

That is the idea, yes.

> 
> While in similar setups, data protection should be handled by the
> storage system, raid 1 has its uses in a failover setup with two sites.
> I don't see a real use for raid5/6 in such scenarios.

If I had 16 nodes, each with a local device and a fast interconnect, I might
want to have a filesystem that spanned all of the devices but survived the
failure of any two nodes.  Then having a stripe/parity layout across the
devices would be useful.
However I think the only way to get good performance would be to require that
the filesystem does full-stripe writes every time.
So I think that would look more like a clusterised ZFS ... but who knows.

NeilBrown
