From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Mon, 28 Nov 2016 10:02:28 +0100
Message-ID: <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com>
 <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de> <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com>
 <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Mon, Nov 28, 2016 at 9:54 AM, Coly Li <colyli@suse.de> wrote:
> On 2016/11/28 =E4=B8=8B=E5=8D=884:24, Jinpu Wang wrote:
>> snip
>>>>>
>>>>> every time nr_pending is 1 bigger then (nr_queued + 1), so seems we
>>>>> forgot to increase nr_queued somewhere?
>>>>>
>>>>> I've noticed (commit ccfc7bf1f09d61)raid1: include bio_end_io_list in
>>>>> nr_queued to prevent freeze_array hang. Seems it fixed similar bug.
>>>>>
>>>>> Could you give your suggestion?
>>>>>
>>>> Sorry, forgot to mention kernel version is 4.4.28
>>>
>>> This commit is Cced to stable@vger.kernel.org for v4.3+, do you use a
>>> stable kernel or a distribution with 4.4.28 kernel ?
>>>
>>> Coly
>>>
>>>
>> Hi Coly,
>>
>> I'm using Debian8 with 4.4.28 kernel.
>
> Hi Jinpu,
>
> Is it possible for your to run a upstream kernel or vanilla kernel to
> test whether the issue still can be reproduced ? Then we can know
> whether it is an upstream bug or a distro issue.
>
> Thanks.
>
> Coly

Hi Coly,

I did run kernel 4.4.34 (I download from kernel.org), I can reproduce
the same bug.

I can also try latest 4.8 or 4.9 rc kernel, if you think it's necessary?

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
