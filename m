From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid1 + writemostly
Date: Mon, 15 Dec 2008 18:14:28 -0600
Message-ID: <cccedfc60812151614m55c59891p52fd80ed62e0c504@mail.gmail.com>
References: <cccedfc60812151030y630bb6c3g40a926bced2b1c09@mail.gmail.com>
	 <18758.52113.251622.783466@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18758.52113.251622.783466@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 3:26 PM, Neil Brown <neilb@suse.de> wrote:
> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>> According to the manpage for mdadm, --write-mostly can only be used
>> add build, create, or add time.  How does one set write-mostly devices
>> *after* they've been added?
>
> You cannot.
> The easiest approach is to remove it and re-add it with the
> write-mostly flag.

OK. However, why does fiddling with the
/sys/block/mdX/dev-someDevice/state seem to do it?


>> Why doesn't --examine-bitmap show the right mode?
>
> What were you expecting?  The bitmap never reports anything about
> writemostly, only write-behind.

Yes, I was expecting write-behind. D'oh!

>> Also, removing the bitmap from the array does not zero out the bitmap
>> on the actual device. Shouldn't it do that?
>
> No.  It simply records in the array metadata that there is no bitmap.
> It might be sensible to get "--examine-bitmap" to report that the
> bitmap is not active in some way.

I'd like to offer my perspective on that - I feel as though when
bitmaps are removed from arrays that the actual bitmap data should be
zeroed (or marked as invalid somehow). What we have is a situation
wherein a device that has never had a bitmap will say more or less
just that when queried. However, a device that has had a bitmap at
*any* point in the past (provided it's not been overwritten) will
display that bitmap, no matter how crazy it is.

-- 
Jon
