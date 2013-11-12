From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Tue, 12 Nov 2013 11:29:01 +0100
Message-ID: <528202ED.1040307@fastmail.fm>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5281F53D.4060703@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/12/2013 10:30 AM, joystick wrote:
> On 11/11/2013 19:52, Justin Piszcz wrote:
> Wait so that mismatches grow again a couple of thousands, then I suggest
> you really do what I wrote in my previous email.
> If you can afford to bring the system offline then it's really easy
> because you can find all mismatching files in one shot
>
> - wait for mismatch_cnt reach 2000 at least (the more, the better), then
> reboot machine with a livecd
> - mount RAID
> - mount the filesystem readonly
> - (very important or it will resync) activate bitmap for raid1,
> preferably with small chunksize
> - fail 1 drive so to degrade raid1
> - drop caches with blockdev --flushbufs on the md device such as
> /dev/md2, on the two underlying partitions such as /dev/sd[ab]2, and
> maybe even on the two disk holding then such as /dev/sd[ab] (I'm not
> really sure what is the minimum needed) ; and also echo 3 >
> /proc/sys/vm/drop_caches
> - recursive md5sum for all files of the filesystem (something like find
> -type f -print0 | xargs -0 md5sum (untested)) > redirect stdout to a
> file on another filesystem
> - reattach drive with --re-add, let it resync the differences using the
> bitmap (there shouldn't be any, should complete immediately)
> - fail the other drive
> - drop all caches again
> - again find | md5sum , redirected to another file on another filesystem
> - reattach drive with --re-add
>
> now analyze differences between md5sums. Those are the files which are
> different in the two legs of the RAID, and they shouldn't be (aka
> corruption).
> Find preferably humanly readable text files which are sequentially
> written, such as log files. It is more difficult to understand what's
> wrong for files changed in the middle such as database files, or binary
> files.
>

If you have available disk space, you might run ql-fstest (possibly in 
combination) with the above method.

https://bitbucket.org/aakef/ql-fstest

Right now it does not support yet to restart it and to verify existing 
files, but I'm going to add this, either this evening or on Thursday.


Cheers,
Bernd

