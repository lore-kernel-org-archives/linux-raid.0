From: =?UTF-8?B?WXVjb25nIFN1biAo5Y+26Zuo6aOeKQ==?= <sunyucong@gmail.com>
Subject: Re: Raid10 and page cache
Date: Tue, 6 Dec 2011 15:13:34 -0800
Message-ID: <CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
 <CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com> <20111207092625.7140c5dc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207092625.7140c5dc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 6, 2011 at 2:26 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 6 Dec 2011 14:01:14 -0800 Yucong Sun (=E5=8F=B6=E9=9B=A8=E9=A3=
=9E) <sunyucong@gmail.com>
> wrote:
>
>> Hi,
>>
>> I recently setup raid10 on 4 physical disk and have a iscsi serve it
>> as a block device, and have been trying to tweak for performance.
>>
>> First thing I notice that MD seems to rely on page cache to flush
>> changes to disk, =C2=A0is there any way to turn that off so changes =
are
>> flushed to the disk? like O_FSYNC|O_DIRECT does? The reason I want t=
o
>> turn it off is to understand the performance difference, =C2=A0I wan=
t to be
>> sure that page cache is truly acting as a write-back cache, I know o=
ne
>> can tune the dirty_* to control the cache flush, but I want to make
>> sure that it is actually doing what I think it does.
>
> Why do you think this?
>
> md/raid10 sends all request straight through to the relevant underlyi=
ng
> device(s).
> reads are just passed straight down.
> Writes are duplicated (the request structure, not the data) and queue=
d to a
> separate thread which does the actual write, but it is fairly direct.

So I know there's page caching /flush involved because I watch
/proc/meminfo and see  Dirty value growing up and After reach the
threshold, Write-back kicks in and wrote data.
So if as you said md does no page flushing, then it must because of
the iscsi software opens the device without O_DIRECT, so it uses page
cache which in turn flush data to MD, now it makes more sense.

But for the md write, it's not SYNC write? meaning that after write
call with O_DIRECT to the md device returns, the data is still
possibility on the fly to the disk? how does having a bitmap plays in
between? does it work like ext3 jounal? after a power-loss, can we
expect a crash consistent data on the disk?

Another thing to note is I found IO size on MD device is always 4K,
which is the page size, is that normal? just want to making sure this
isn't a bad behavior result from the iscsi software.
>
>>
>> Then I notice in output of free, =C2=A0the number in Cache column is=
 very
>> low, however the Buffer is very high, my question is does Buffer her=
e
>> serves as a read cache? I couldn't find the answer anywhere else.
>
> The best place to find the answer is in the source code.
>
> Every page in the page cache is associated with some file.
> If that file is a block device (e.g. /dev/sdX) then it is reported as
> 'Buffer' otherwise it is reported as 'Cache'.
>
> Some filesystems like ext3 uses 'Buffer' memory for metadata but call=
 use
> 'Cache' memory for files and directories.
>

Thanks, it is being used as read cache then, too bad there's no easy
way to measure/see the hit rate.

>>
>> My last question is that since MD seems already doing the cache, =C2=
=A0what
>> effect would it have if I want to setup a LO device in front of MD
>> device, Is there going to be more caching, how is different than jus=
t
>> plain MD device?
>
> MD/raid10 does no caching.
> A loop-back over the md device would not add extra caching.
>
> NeilBrown
>
>
>>
>> Thanks.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
