From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Tue, 15 Jun 2010 07:24:49 +1000
Message-ID: <20100615072449.43ab5c9d@notabene.brown>
References: <4C1128C2.4020105@meetinghouse.net>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
	<20100611145019.6f1a5e7d@notabene.brown>
	<201006131628.35037.bernd.schubert@fastmail.fm>
	<20100614090520.2ae5a961@notabene.brown>
	<20100614151425.11f91562@natsu>
	<20100614194742.4a383a3f@notabene.brown>
	<20100614175327.57f05bb1@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100614175327.57f05bb1@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Jun 2010 17:53:27 +0600
Roman Mamedov <roman@rm.pp.ru> wrote:

> On Mon, 14 Jun 2010 19:47:42 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > When you create an array an specify that a bitmap be added at the same time,
> > there is more flexibility for size and location of the bitmap.  It can easily
> > be more that 3K in that case.
> > 
> > So presumably this array was created with a bitmap, rather than created
> > without a bitmap and had a bitmap added later with --grow.  Correct?
> 
> Yes, as far as I remember. However, it seems a bit unfortunate to have any
> significant difference between adding the bitmap right when creating the
> array, and adding it later. For that reason, I'd suggest reserving more space
> in the metadata than 3K, even if the bitmap isn't requested - and even if it
> won't be added later, then that space could prove useful for something else
> that might require it later. Maybe 64, 128 or 256K - still miniscule compared
> to the array size, and could provide some nice flexibility for the future.
> 

Yes. An I'm fairly sure mdadm does always reserve space.
The point is that (until very recently) it wasn't possible to tell the kernel
where to add a bitmap to an active array - just that it should add one.
So it could  only add it at a place that it was certain would be usable.
That is the place I described.
It is now possible to give the kernel more details of the bitmap to add.  I
just need to teach mdadm how to choose the best space and how to tell the
kernel about it.

NeilBrown
