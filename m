From: Mikhail Balabin <mbalabin@gmail.com>
Subject: Re: polling mdX/md/degraded in sysfs
Date: Tue, 10 Jan 2012 21:19:36 +0600
Message-ID: <CAC9iW=syYWp=yMtF+DS_F5_iW4Q5JrvOmjEw869FkPo0qXDM+Q@mail.gmail.com>
References: <CAC9iW=taiG0=JOXcrEDOWKoHswEAp1uRTP2UP=4MepBXNf2Lrg@mail.gmail.com>
 <CAGRgLy5CsmEU_-GnvXH3ffqK4Wnj7V6a_-TWnhA3ysbo2HKGqQ@mail.gmail.com>
 <20120109114433.6cf3c47a@notabene.brown> <CAC9iW=v+NaHOZ_QBqvHKA2iXsx9OHkuUBsjmkS9+XaKmpe7cJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9iW=v+NaHOZ_QBqvHKA2iXsx9OHkuUBsjmkS9+XaKmpe7cJg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/1/9 Mikhail Balabin <mbalabin@gmail.com>:
> 2012/1/9 NeilBrown <neilb@suse.de>:
>> On Sun, 8 Jan 2012 11:06:59 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
>> wrote:
>>
>>> Hi,
>>> well, at least according to 2.6.38-8 kernel code, this attribute is
>>> notified in 3 cases:
>>> # When the array is started (e.g., via RUN_ARRAY ioctl)
>>> # When "reshape" is initiated via sysfs
>>> # When a spare is activated after successful completion of
>>> resync/recover/check/replair
>>>
>>
>> Hmm... it really should notify when a disk fails.
>>
>> Mikhail: could you please test if this patch makes it work better for you?
>
> Ok, I'll try to test the patch against 3.2 today.
>
>> Thanks,
>> NeilBrown
>
> Mikhail Balabin

The patch have fixed the issue. I suppose it should go to the mainline.

Alexander, Neil, thanks for your efforts.

Mikhail Balabin
