From: =?UTF-8?B?WXVjb25nIFN1biAo5Y+26Zuo6aOeKQ==?= <sunyucong@gmail.com>
Subject: Re: Raid10 and page cache
Date: Wed, 7 Dec 2011 01:21:59 -0800
Message-ID: <CAJygYd2by45xJs-RV_v0S8Hd8B1Dk9DP6B+L6MmX=_Va-5Qsvw@mail.gmail.com>
References: <CAJygYd16PWfKe8fK-b150N46CEwzBUqJn1N6dfsGR4yyTgGbTQ@mail.gmail.com>
 <CAJygYd3ofkHp9huD_Q1xoKVb_Q2LTDAnFHf-n+8xyG7ug3wC_Q@mail.gmail.com>
 <20111207092625.7140c5dc@notabene.brown> <CAJygYd3fM+wtnU0HkN7s7o=FPizbPNPET2A21jxWk-BJZgdFbA@mail.gmail.com>
 <20111207120133.70ca294c@notabene.brown> <CAJygYd3j5HwGyZ7rTKZj5dr=cXDOpy3jK=6AyOVKJY0PX3bdtA@mail.gmail.com>
 <20111207152853.42594fc9@notabene.brown> <CAJygYd0UeJ04KOZJLkjO1KoBf6t0Ko_jyCw=HerCtehgkG5DUQ@mail.gmail.com>
 <20111207161003.0aa181d8@notabene.brown> <CAJygYd1WgqMYTzvXKKWR9_=Osqd=BPFud20FHXsDz1ag37uJ=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJygYd1WgqMYTzvXKKWR9_=Osqd=BPFud20FHXsDz1ag37uJ=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, I re-read the kernel code again,  it looks like backdev.cc is
doing the correct thing by calling writeback with WB_NO_SYNC, it all
looks good, but I don't understand why it would appear read saturated
on my system.

However I think your commit would definitely make things better,
Ideally I think make write only use available bandwidth like sync
does, and automatically adjusting.

2011/12/6 Yucong Sun (=D2=B6=D3=EA=B7=C9) <sunyucong@gmail.com>:
> Ok, still, during that time, no read is being finished.
>
> I'm on  Linux vstore-1 2.6.32-35-server #78-Ubuntu SMP Tue Oct 11
> 16:26:12 UTC 2011 x86_64 GNU/Linux
> do you know which kernel version has that commit ? 2.6.35 ?
>
> I think the root cause is that, whenever dirty_background_bytes is
> reached,  kernel flush thread [flush:254:0] wakes up and cause
> md_raid10_d0 to go into state D, which cause everything to hang a
> while, I guess maybe the flush thread is calling fsync() after the
> write? That's hard to believe, but can actually explain the symptom.
>
> BTW I don't think limiting batch write to 1024 would solve the
> problem, I am actually doing it now because I have to set
> dirty_background_bytes to 4M which is exactly 1024 write every second
> or so.
>
> Cheers.
>
> On Tue, Dec 6, 2011 at 9:10 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 6 Dec 2011 20:50:48 -0800 Yucong Sun (=D2=B6=D3=EA=B7=C9) <s=
unyucong@gmail.com>
>> wrote:
>>
>>> I'm not sure whether it is what I mean,  to illustrate my problem l=
et
>>> me put iostat -x -d 1 output  as below
>>>
>>> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
>>> avgrq-sz avgqu-sz   await  svctm  %util
>>> sdb               0.00     0.00  163.00    1.00  1304.00     8.00
>>> 8.00     0.26    1.59   1.59  26.00
>>> sdc               0.00     0.00   93.00    1.00   744.00     8.00
>>> 8.00     0.24    2.55   2.45  23.00
>>> sde               0.00     0.00   56.00    1.00   448.00     8.00
>>> 8.00     0.22    3.86 3.86 22.00
>>> sdd               0.00     0.00   88.00    1.00   704.00     8.00
>>> 8.00     0.18    2.02 2.02 18.00
>>> md_d0             0.00     0.00  401.00    0.00  3208.00     0.00
>>> 8.00     0.00    0.00   0.00   0.00
>>>
>>> =3D=3D> this is normal operation, because of page cache, there's on=
ly read
>>> being submitted to the MD device.
>>>
>>> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
>>> avgrq-sz avgqu-sz   await  svctm  %util
>>> sda               0.00     0.00    0.00    0.00     0.00     0.00
>>> 0.00     0.00    0.00   0.00   0.00
>>> sdb               0.00  1714.00    4.00  277.00    32.00 14810.00
>>> 52.82    34.04  105.05   2.92  82.00
>>> sdc               0.00  1685.00   12.00  270.00    96.00 14122.00
>>> 50.42    42.56  131.03   3.09  87.00
>>> sde               0.00  1385.00    8.00  261.00    64.00 12426.00
>>> 46.43    29.76   99.44   3.35  90.00
>>> sdd               0.00  1350.00    8.00  228.00    64.00 10682.00
>>> 45.53    40.93  133.56   3.69  87.00
>>> md_d0             0.00     0.00   32.00 16446.00   256.00 131568.00
>>>  8.00     0.00    0.00   0.00   0.00
>>>
>>> =3D=3D> Huge page flush kick in, note the read requests is saturate=
d on MD device.
>>>
>>> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
>>> avgrq-sz avgqu-sz   await  svctm  %util
>>> sda               0.00     0.00    0.00    0.00     0.00     0.00
>>> 0.00     0.00    0.00   0.00   0.00
>>> sdb               0.00  1542.00    4.00  264.00    32.00 11760.00
>>> 44.00    66.58  230.22   3.73 100.00
>>> sdc               0.00  1185.00    0.00  272.00     0.00  9672.00
>>> 35.56    63.40  215.88   3.68 100.00
>>> sde               0.00  1352.00    0.00  298.00     0.00 12488.00
>>> 41.91    35.56  126.34   3.36 100.00
>>> sdd               0.00   996.00    0.00  294.00     0.00 10120.00
>>> 34.42    76.79  270.37   3.40 100.00
>>> md_d0             0.00     0.00    4.00    0.00    32.00     0.00
>>> 8.00     0.00    0.00   0.00   0.00
>>>
>>> =3D=3D> Huge page flush still working,  no read is being done.
>>>
>>> This is the problem , when page flush kick in, MD appears to refuse
>>> incoming read,  all under laying device is tuned to deadline schedu=
ler
>>> and tuned to favor read, still, it don't work since MD simply don't
>>> submit new read to the underlying device.
>>
>> The counters are update when a request completes, not when it is sub=
mitted,
>> so you cannot tell from this data if md is submitting the read reque=
sts or
>> not.
>>
>> What kernel are you working with?  If it doesn't contain the commit
>> identified below can you try with that and see if it makes a differe=
nce?
>>
>> Thanks,
>> NeilBrown
>>
>>
>>
>>>
>>> 2011/12/6 NeilBrown <neilb@suse.de>:
>>> > On Tue, 6 Dec 2011 20:04:33 -0800 Yucong Sun (=D2=B6=D3=EA=B7=C9)=
 <sunyucong@gmail.com>
>>> > wrote:
>>> >
>>> >> The problem with using page-flush as a write cache here is that =
write
>>> >> to MD don't go through IO scheduler, which is a very big problem=
,
>>> >> because when flush thread decide to write to MD,  it's impossibl=
e to
>>> >> control the write speed, or prioritize them with read, every req=
uests
>>> >> basically is a fifo,  and when flush size is big, no read can be
>>> >> served.
>>> >>
>>> >
>>> > I'm not sure I understand....
>>> >
>>> > Requests don't go through an IO scheduler before they hit md, but=
 they do
>>> > after md sends them on down, so they can be re-ordered there.
>>> >
>>> > There was a bug where raid10 would allow an arbitrary number of w=
rites to
>>> > queue up so that flushing code didn't know when to stop.
>>> >
>>> > This was fixed by
>>> >   commit 34db0cd60f8a1f4ab73d118a8be3797c20388223
>>> >
>>> > nearly 2 months ago :-)
>>> >
>>> > NeilBrown
>>> >
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
