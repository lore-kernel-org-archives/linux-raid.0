From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: Raid10 and page cache
Date: Tue, 6 Dec 2011 16:22:55 -0700
Message-ID: <CALFpzo6EKQ-nOtHYyL2iAStH5QLnMPqiN6ksti5fe6Z9OBYmEA@mail.gmail.com>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
	<CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
	<20111207092625.7140c5dc@notabene.brown>
	<CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?WXVjb25nIFN1biAo5Y+26Zuo6aOeKQ==?= <sunyucong@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When you write a file, it is not MD doing caching that you see. The OS
caches via dirty memory before flushing to MD. If you want to write
sync or O_DIRECT, do so by adding the flag to the open() call when you
write a file.

On Tue, Dec 6, 2011 at 4:13 PM, Yucong Sun (=D2=B6=D3=EA=B7=C9) <sunyuc=
ong@gmail.com> wrote:
> On Tue, Dec 6, 2011 at 2:26 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 6 Dec 2011 14:01:14 -0800 Yucong Sun (=D2=B6=D3=EA=B7=C9) <s=
unyucong@gmail.com>
>> wrote:
>>
>>> Hi,
>>>
>>> I recently setup raid10 on 4 physical disk and have a iscsi serve i=
t
>>> as a block device, and have been trying to tweak for performance.
>>>
>>> First thing I notice that MD seems to rely on page cache to flush
>>> changes to disk,  is there any way to turn that off so changes are
>>> flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I want =
to
>>> turn it off is to understand the performance difference,  I want to=
 be
>>> sure that page cache is truly acting as a write-back cache, I know =
one
>>> can tune the dirty_* to control the cache flush, but I want to make
>>> sure that it is actually doing what I think it does.
>>
>> Why do you think this?
>>
>> md/raid10 sends all request straight through to the relevant underly=
ing
>> device(s).
>> reads are just passed straight down.
>> Writes are duplicated (the request structure, not the data) and queu=
ed to a
>> separate thread which does the actual write, but it is fairly direct=
=2E
>
> So I know there's page caching /flush involved because I watch
> /proc/meminfo and see  Dirty value growing up and After reach the
> threshold, Write-back kicks in and wrote data.
> So if as you said md does no page flushing, then it must because of
> the iscsi software opens the device without O_DIRECT, so it uses page
> cache which in turn flush data to MD, now it makes more sense.
>
> But for the md write, it's not SYNC write? meaning that after write
> call with O_DIRECT to the md device returns, the data is still
> possibility on the fly to the disk? how does having a bitmap plays in
> between? does it work like ext3 jounal? after a power-loss, can we
> expect a crash consistent data on the disk?
>
> Another thing to note is I found IO size on MD device is always 4K,
> which is the page size, is that normal? just want to making sure this
> isn't a bad behavior result from the iscsi software.
>>
>>>
>>> Then I notice in output of free,  the number in Cache column is ver=
y
>>> low, however the Buffer is very high, my question is does Buffer he=
re
>>> serves as a read cache? I couldn't find the answer anywhere else.
>>
>> The best place to find the answer is in the source code.
>>
>> Every page in the page cache is associated with some file.
>> If that file is a block device (e.g. /dev/sdX) then it is reported a=
s
>> 'Buffer' otherwise it is reported as 'Cache'.
>>
>> Some filesystems like ext3 uses 'Buffer' memory for metadata but cal=
l use
>> 'Cache' memory for files and directories.
>>
>
> Thanks, it is being used as read cache then, too bad there's no easy
> way to measure/see the hit rate.
>
>>>
>>> My last question is that since MD seems already doing the cache,  w=
hat
>>> effect would it have if I want to setup a LO device in front of MD
>>> device, Is there going to be more caching, how is different than ju=
st
>>> plain MD device?
>>
>> MD/raid10 does no caching.
>> A loop-back over the md device would not add extra caching.
>>
>> NeilBrown
>>
>>
>>>
>>> Thanks.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
