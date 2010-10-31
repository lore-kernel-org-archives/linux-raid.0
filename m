From: Neil Brown <neilb@suse.de>
Subject: Re: 3T drives and RAID
Date: Sun, 31 Oct 2010 11:30:29 -0400
Message-ID: <20101031113029.226d9e65@notabene>
References: <20101030103312.7b5a2107@zealot>
	<B8.A4.13137.093EBCC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B8.A4.13137.093EBCC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Johannes Truschnigg' <johannes@truschnigg.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Oct 2010 04:21:16 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 	Md will automatically treat the oddball drive as if it had .5K
> sectors, or does one need to tell ma (or the kernel) to do so?
>

You don't need to tell the kernel to do anything special - it should just
work.

md/raid5 (and raid6) do all writes as 4K blocks, 4K aligned (as the
stripe-cache is made of pages which are 4K).  So that fits perfectly with the
new drives.
If your filesystem issued a non-aligned read, then it could get down to the
device as a non-aligned read, but there is little performance penalty for
reads, only writes.
And XFS almost certainly does all IO in 4K multiples, so you should be fine.

In short: I can see no reason why it shouldn't work smoothly.

NeilBrown
