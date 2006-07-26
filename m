From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Wed, 26 Jul 2006 17:30:26 -0400
Message-ID: <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>
References: <44C5BA6F.3010404@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C5BA6F.3010404@steeleye.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 7/25/06, Paul Clements <paul.clements@steeleye.com> wrote:
> This patch (tested against 2.6.18-rc1-mm1) adds a new sysfs interface
> that allows the bitmap of an array to be dirtied. The interface is
> write-only, and is used as follows:
>
> echo "1000" > /sys/block/md2/md/bitmap
>
> (dirty the bit for chunk 1000 [offset 0] in the in-memory and on-disk
> bitmaps of array md2)
>
> echo "1000-2000" > /sys/block/md1/md/bitmap
>
> (dirty the bits for chunks 1000-2000 in md1's bitmap)
>
> This is useful, for example, in cluster environments where you may need
> to combine two disjoint bitmaps into one (following a server failure,
> after a secondary server has taken over the array). By combining the
> bitmaps on the two servers, a full resync can be avoided (This was
> discussed on the list back on March 18, 2005, "[PATCH 1/2] md bitmap bug
> fixes" thread).

Hi Paul,

I tracked down the thread you referenced and these posts (by you)
seems to summarize things well:
http://marc.theaimsgroup.com/?l=linux-raid&m=111116563016418&w=2
http://marc.theaimsgroup.com/?l=linux-raid&m=111117515400864&w=2

But for clarity's sake, could you elaborate on the negative
implications of not merging the bitmaps on the secondary server?  Will
the previous primary's dirty blocks get dropped on the floor because
the secondary (now the primary) doesn't have awareness of the previous
primary's dirty blocks once it activates the raid1?

Also, what is the interface one should use to collect dirty bits from
the primary's bitmap?

This bitmap merge can't happen until the primary's dirty bits can be
collected right?  Waiting for the failed server to come back to
harvest the dirty bits it has seems wrong (why failover at all?); so I
must be missing something.

please advise, thanks.
Mike
