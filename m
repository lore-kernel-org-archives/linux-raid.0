From: Coly Li <colyli@suse.de>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Mon, 28 Nov 2016 17:10:33 +0800
Message-ID: <dd068837-6873-ab1b-3c25-d4dbf4ad2ec4@suse.de>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com>
 <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de>
 <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com>
 <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de>
 <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On 2016/11/28 下午5:02, Jinpu Wang wrote:
> On Mon, Nov 28, 2016 at 9:54 AM, Coly Li <colyli@suse.de> wrote:
>> On 2016/11/28 下午4:24, Jinpu Wang wrote:
>>> snip
>>>>>>
>>>>>> every time nr_pending is 1 bigger then (nr_queued + 1), so seems we
>>>>>> forgot to increase nr_queued somewhere?
>>>>>>
>>>>>> I've noticed (commit ccfc7bf1f09d61)raid1: include bio_end_io_list in
>>>>>> nr_queued to prevent freeze_array hang. Seems it fixed similar bug.
>>>>>>
>>>>>> Could you give your suggestion?
>>>>>>
>>>>> Sorry, forgot to mention kernel version is 4.4.28
>>>>
>>>> This commit is Cced to stable@vger.kernel.org for v4.3+, do you use a
>>>> stable kernel or a distribution with 4.4.28 kernel ?
>>>>
>>>> Coly
>>>>
>>>>
>>> Hi Coly,
>>>
>>> I'm using Debian8 with 4.4.28 kernel.
>>
>> Hi Jinpu,
>>
>> Is it possible for your to run a upstream kernel or vanilla kernel to
>> test whether the issue still can be reproduced ? Then we can know
>> whether it is an upstream bug or a distro issue.
>>
>> Thanks.
>>
>> Coly
> 
> Hi Coly,
> 
> I did run kernel 4.4.34 (I download from kernel.org), I can reproduce
> the same bug.
> 
> I can also try latest 4.8 or 4.9 rc kernel, if you think it's necessary?
> 
Yes, please. If it can be reproduced on upstream kernel by a set of
scripts, it will be very helpful to debug and fix this issue.

Thanks in advance.

Coly
