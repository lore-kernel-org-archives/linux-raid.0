From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Tue, 21 Apr 2009 03:13:23 +0100
Message-ID: <49ED2BC3.7050109@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>    <49ED096E.1000002@anonymous.org.uk>    <49ED16F7.3040906@anonymous.org.uk> <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/04/2009 02:33, NeilBrown wrote:
[...]
> Choosing a larger --bitmap-chunk size will require fewer updates to the
> bitmap before writes are allowed to proceed.   However a larger bitmap-chunk
> size will also increase the amount of work needed after a crash or
> re-added device.

Ah, from my reading of the mdadm man page I thought you could only 
specify the chunk size when using an external bitmap:
--bitmap-chunk=
        Set  the  chunksize  of the bitmap. Each bit corresponds to that
        many Kilobytes of storage.  When using a file based bitmap,  the
        default  is  to  use  the  smallest  size that is at-least 4 and
        requires no more than  2^21  chunks.   When  using  an  internal
        bitmap,  the  chunksize is automatically determined to make best
        use of available space.

> Check your current (default) chunk size with "mdadm -X /dev/sdxx" and
> create a new bitmap with (say) 16 or 64 times the chunk size.
> See if that makes a difference.

It certainly does. Upping it from 2M to 32M gets me from 45MB/s to 
81MB/s on the scratch LV, and there's noticeably less seek noise.

Eeek! Trying to `mdadm --grow /dev/md1 --bitmap=none` from my large 
chunk size caused a reboot! There's nothing in the log, and I didn't see 
the console. I still have my 32M chunksize but I don't want to try that 
again in a hurry :-)

[...]
> Your other option is to put the bitmap in a file on some other device.
> If you have a device this is rarely used (maybe your root filesystem)

Can't do that, my root filesystem is on the RAID-5, and part of the 
reason for wanting the bitmap is because the md can't be stopped while 
shutting down, so it was always wanting to resync at startup, which is 
rather tedious.

> Maybe you could create an external bitmap in a tmpfs.... but then
> it wouldn't survive a crash and so has little value.  It would be
> fast though :-)

"Ooh, virtual memory! Now I can have a really big RAM disc!"

Now, it's time I checked my discs to see if I've lost data in that 
crash. `mdadm -X` is stuck saying there are 10 dirty chunks.

Cheers,

John.
