From: =?UTF-8?B?WXVjb25nIFN1biAo5Y+26Zuo6aOeKQ==?= <sunyucong@gmail.com>
Subject: Re: Raid10 and page cache
Date: Tue, 6 Dec 2011 20:04:33 -0800
Message-ID: <CAJygYd3j5HwGyZ7rTKZj5dr=cXDOpy3jK=6AyOVKJY0PX3bdtA@mail.gmail.com>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
 <CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
 <20111207092625.7140c5dc@notabene.brown> <CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
 <20111207120133.70ca294c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207120133.70ca294c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The problem with using page-flush as a write cache here is that write
to MD don't go through IO scheduler, which is a very big problem,
because when flush thread decide to write to MD,  it's impossible to
control the write speed, or prioritize them with read, every requests
basically is a fifo,  and when flush size is big, no read can be
served.

On Tue, Dec 6, 2011 at 5:01 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 6 Dec 2011 15:13:34 -0800 Yucong Sun (=D2=B6=D3=EA=B7=C9) <su=
nyucong@gmail.com>
> wrote:
>
>> On Tue, Dec 6, 2011 at 2:26 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Tue, 6 Dec 2011 14:01:14 -0800 Yucong Sun (=D2=B6=D3=EA=B7=C9) =
<sunyucong@gmail.com>
>> > wrote:
>> >
>> >> Hi,
>> >>
>> >> I recently setup raid10 on 4 physical disk and have a iscsi serve=
 it
>> >> as a block device, and have been trying to tweak for performance.
>> >>
>> >> First thing I notice that MD seems to rely on page cache to flush
>> >> changes to disk,  is there any way to turn that off so changes ar=
e
>> >> flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I wan=
t to
>> >> turn it off is to understand the performance difference,  I want =
to be
>> >> sure that page cache is truly acting as a write-back cache, I kno=
w one
>> >> can tune the dirty_* to control the cache flush, but I want to ma=
ke
>> >> sure that it is actually doing what I think it does.
>> >
>> > Why do you think this?
>> >
>> > md/raid10 sends all request straight through to the relevant under=
lying
>> > device(s).
>> > reads are just passed straight down.
>> > Writes are duplicated (the request structure, not the data) and qu=
eued to a
>> > separate thread which does the actual write, but it is fairly dire=
ct.
>>
>> So I know there's page caching /flush involved because I watch
>> /proc/meminfo and see  Dirty value growing up and After reach the
>> threshold, Write-back kicks in and wrote data.
>> So if as you said md does no page flushing, then it must because of
>> the iscsi software opens the device without O_DIRECT, so it uses pag=
e
>> cache which in turn flush data to MD, now it makes more sense.
>>
>> But for the md write, it's not SYNC write? meaning that after write
>> call with O_DIRECT to the md device returns, the data is still
>> possibility on the fly to the disk? how does having a bitmap plays i=
n
>> between? does it work like ext3 jounal? after a power-loss, can we
>> expect a crash consistent data on the disk?
>
> When you want sync writes, you need to use fsync.
>
> When md writes the superblock or a bitmap page it uses SYNC and FLUSH=
 writes
> to ensure they get to the media before the subsequent data write.
>
>
>>
>> Another thing to note is I found IO size on MD device is always 4K,
>> which is the page size, is that normal? just want to making sure thi=
s
>> isn't a bad behavior result from the iscsi software.
>
> It is normal in some cases.  It depends a bit on the details of the
> underlying device.
>
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
