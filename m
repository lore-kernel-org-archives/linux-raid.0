From: Nikhil Kshirsagar <nkshirsa@redhat.com>
Subject: Re: mdadm - raid6 best practices ?
Date: Sat, 23 Sep 2017 08:52:55 +0530
Message-ID: <CAMNNMLGWcaHpOp6CQ9XOgFXzOMzW760dPBp44eiqRQ2NiQKE9Q@mail.gmail.com>
References: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
 <89da68f8-2d31-4168-00f6-050a194cd2fa@hardwarefreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <89da68f8-2d31-4168-00f6-050a194cd2fa@hardwarefreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you all for the information, I'll get some more workload
details. Thanks again!

-nikhil.

On Sat, Sep 23, 2017 at 6:10 AM, Stan Hoeppner <stan@hardwarefreak.org> wrote:
> On 09/21/2017 10:55 PM, Nikhil Kshirsagar wrote:
>>
>> Hello linux-raid,
>>
>> A customer has some questions about raid6 best practices. They are
>> using a 84-disk MD1280 Expansion Shelf (seagate disks). They want to
>> use mdadm to setup a s/w raid, using raid6.
>>
>> The questions are
>>
>> a) recommended number of disks included in RAID array set?
>> b) Is it possible to include all 84 disks in one array and leave 2 of
>> them as host spare?
>> c) Is there a raid6 best practices document to refer to ?
>>
>> Can anyone point me to me any internal docs or articles to construct a
>> reply to the customer?
>>
>> Thanks,
>> Nikhil.
>
>
> The single most important question:
>
> What is the workload?
>
> Start the discussion there, or everything else is meaningless.
>
> --
> Stan
