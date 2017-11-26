From: Paul Chambers <paul@bod.org>
Subject: Re: Fwd: problems attempting to grow raid5 to raid6 - advice sought
Date: Sat, 25 Nov 2017 16:24:24 -0800
Message-ID: <CALfMqR5gXj7LjJ-ROOWc8aRwzwmjh9mWmLNGj_uTO5khTzT=jA@mail.gmail.com>
References: <CALfMqR47A=5usN-=6v3vUHAPYe-dFQ1Zxhuef0zZzRhXPcQQnQ@mail.gmail.com>
 <CALfMqR5DVqMOwNQwTPwb3y3OH7S-mKy-i=N1_SgvWfbRxbtarw@mail.gmail.com> <20171125152304.GN20756@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171125152304.GN20756@reaktio.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Typo in my email, sorry. I did add the partitions, not the drives, to
the array, i.e.:

~# mdadm --add /dev/md0 /dev/sdi1 /dev/sdk1 /dev/sdl1

The detailed info dump at the end of the email confirms that.
- Paul
-- 
http://about.me/paul.chambers


On Sat, Nov 25, 2017 at 7:23 AM, Pasi Kärkkäinen <pasik@iki.fi> wrote:
> On Fri, Nov 24, 2017 at 06:54:43PM -0800, Paul Chambers wrote:
>> (all the detailed info is at the end of this email)
>>
>> I could use some expert help...
>>
>> I started with a RAID-5 array of 5 x 6TB WD RED drives, and 1 x 6TB
>> Seagate Ironwolf drive. This has been running well for a long time as
>> a 5-drive array, and was grown to a 6 drive array a few months ago by
>> the addition of the ironwolf drive. No known issues.
>>
>>   ### devices in order: 0   1   2   3   4   5
>>   DRIVES="sdj sdg sdf sdq sdc sdh"
>>
>> I purchased 3 x 8TB WD Red drives, and used parted to set them up as
>> GPT, with a single partition that fills the drive.
>>
>> I then added them to the array in the usual fashion:
>>
>> ~# mdadm --add /dev/md0 /dev/sdi /dev/sdk /dev/sdl
>>
>
> Hmm.. what was the point of creating the partitions if you added the whole disk to the array anyway?
>
>
> -- Pasi
>
