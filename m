From: "NeilBrown" <neilb@suse.de>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Tue, 21 Apr 2009 11:33:21 +1000 (EST)
Message-ID: <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
    <49ED096E.1000002@anonymous.org.uk>
    <49ED16F7.3040906@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49ED16F7.3040906@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, April 21, 2009 10:44 am, John Robinson wrote:
> That's more like it, and no more rattling. Can I tune settings for the
> internal bitmap, or is this something which will have improved anyway
> since my kernel (2.6.18-128.1.6.el5.centos.plusxen so essentially a
> prominent North American Enterprise Linux vendor's EL5 codebase for
> md/raid5)? I mean, I do want the bitmap, but I hadn't realised it was
> quite so expensive (not that it matters much in this particular
> application).
>

I don't think newer kernels make any different to bitmap related
performance, though there might be some general raid5 improvements since
then.

There are two tunables for bitmaps.  Chuck size and delay (though the
delay doesn't seem to be in the man page).

Choosing a larger --bitmap-chunk size will require fewer updates to the
bitmap before writes are allowed to proceed.   However a larger bitmap-chunk
size will also increase the amount of work needed after a crash or
re-added device.
Check your current (default) chunk size with "mdadm -X /dev/sdxx" and
create a new bitmap with (say) 16 or 64 times the chunk size.
See if that makes a difference.

The delay tunable sets how quickly bits are removed from the bitmap.
This is done fairly lazily and opportunistically so it isn't likely
to affect throughput directly.  However if you are updates the same
area on disk periodically, and this period is a little bit more than
the timeout, you will get excessive bitmap updates that service little
purpose.
You could try increasing this (to say 30 or 60 seconds), but I doubt
it will have much effect.

Your other option is to put the bitmap in a file on some other device.
If you have a device this is rarely used (maybe your root filesystem)
you can create an external bitmap on there.  You would want to be
sure that the device storing the bitmap is always going to be
available when you start the array that the bitmap belongs to.

Maybe you could create an external bitmap in a tmpfs.... but then
it wouldn't survive a crash and so has little value.  It would be
fast though :-)

NeilBrown


> Cheers,
>
> John.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

