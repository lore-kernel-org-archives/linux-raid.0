From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Mon, 14 Jun 2010 19:47:42 +1000
Message-ID: <20100614194742.4a383a3f@notabene.brown>
References: <4C1128C2.4020105@meetinghouse.net>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
	<20100611145019.6f1a5e7d@notabene.brown>
	<201006131628.35037.bernd.schubert@fastmail.fm>
	<20100614090520.2ae5a961@notabene.brown>
	<20100614151425.11f91562@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100614151425.11f91562@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Jun 2010 15:14:25 +0600
Roman Mamedov <roman@rm.pp.ru> wrote:

> On Mon, 14 Jun 2010 09:05:20 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > > While I have done this myself a couple of times, I still do not understand 
> > > where it takes the disk space for the bitmap journal from? Is this space
> > > mdadm reserved for this purpose?
> > 
> > Sort-of.
> > It uses space that the alignment requirements of the metadata assure us is
> > otherwise unused.
> > For v0.90, that is limited to 60K.  For 1.x it is 3K.
> 
> I have now:
> 
> md0 : active raid5 sdf3[3] sde3[1] sda3[0]
>       3887004672 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 1/8 pages [4KB], 131072KB chunk
> 
> Metadata is 1.2, and the internal bitmap is 8 pages, which is 32K, not 3K.
> Did I misunderstand something, or perhaps 3K was a typo?
> 

The pages used to store the bitmap internally use 16 bits per bitmap-chunk,
to count how many active IO requests to the chunk there are.  So it is
potentially 16 times the size of the bitmap stored on disk.  For that reason
we free pages for which all chunks are idle.  In your case, only one of the 8
pages currently has any active chunks.

There are 3887004672 / 131072 or about 29655 chunks.  Hence bits.
29655/8 is 3706 bytes which you will notice is still larger than 3 K.

When you create an array an specify that a bitmap be added at the same time,
there is more flexibility for size and location of the bitmap.  It can easily
be more that 3K in that case.

So presumably this array was created with a bitmap, rather than created
without a bitmap and had a bitmap added later with --grow.  Correct?

NeilBrown
