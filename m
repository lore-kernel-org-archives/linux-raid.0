From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 08:38:19 -0600
Message-ID: <CAE9DZUQ=BFtaFxw-scDPpXEW8X5BEb=scWR4OGD-TNcv0Rh1-w@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAETWcfs_UmRKi+x3Wf+z2aaG6+x-qyCgBHk+OUdjE7r0XpCYEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAETWcfs_UmRKi+x3Wf+z2aaG6+x-qyCgBHk+OUdjE7r0XpCYEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 12:36 AM, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi,
>
> Did you set stride/stripe configuration to filesystem that is aligned
> with raid configuration?
>
> Regards,
> Alexander
>
> On Thu, Dec 10, 2015 at 4:34 AM, Dallas Clement
> <dallas.a.clement@gmail.com> wrote:
>> Hi all.  I'm trying to determine best and worst case expected
>> sequential write speeds for Linux software RAID with spinning disks.
>>
>> I have been assuming on the following:
>>
>> Best case RAID 6 sequential write speed is (N-2) * X, where is is
>> number of drives and X is write speed of a single drive.
>>
>> Worst case RAID 6 sequential write speed is (N-2) * X / 2.
>>
>> Best case RAID 5 sequential write speed is (N-1) * X.
>>
>> Worst case RAID 5 sequential write speed is (N-1) * X / 2.
>>
>> Could someone please confirm whether these formulas are accurate or not?
>>
>>
>> I am not even getting worst case write performance with an array of 12
>> spinning 7200 RPM SATA disks.  Thus I  suspect either the formulas I
>> am using are wrong or I have alignment issues or something.  My chunk
>> size is 128 KB at the moment.
>>
>> Thanks,
>>
>> Dallas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

> Did you set stride/stripe configuration to filesystem that is aligned
with raid configuration?

Hi Alexander.  I've  just been reading / writing the raw raid device
with no filesystem at the moment.  Using fio, with direct=1.  I seem
to get the best results with bs=512k and queue_depth=256.  Even with
this, I am still short of the worst case write performance.
