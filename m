From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Interesting feature request for linux raid, waking up drives
Date: Wed, 9 May 2012 23:16:33 +0200
Message-ID: <CAAOsTSnd_hLTdRZeSDs0ThfQspAq7DVAnsVMeXgMEosugoesag@mail.gmail.com>
References: <CAAOsTSkxo2Lxb2FCO6A19CrWVbDm1VsrtsYwVEykcs7X=-1sTQ@mail.gmail.com>
	<4FAACE5F.2010004@nuclearwinter.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAACE5F.2010004@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 9, 2012 at 10:06 PM, Larkin Lowrey
<llowrey@nuclearwinter.com> wrote:
> I second this suggestion but I don't think it's the job of the raid
> layer to keep track of whether the member drives are spinning or not.

I also dont think it should be directly in the raid level, but it is
problem of linux raid and so the solution should be sought here.

> I have implemented a similar setup to this but am suffering from the
> sequential spin-up problem you described. It would be nice to have a
> solution.

My script is not perfect but it eliminates sequential spin-up problem
perfectly. If you want, use it. The sequential spin-up problem was the
reason I wrote it and its main function is to detect woken drives and
immediately wake other drives from RAID.

> A userspace daemon could probably do the job. I found that relying on
> the drive's internal power management for spinning them down was
> unreliable (especially for WDC "green" drives) so I implemented a scr=
ipt
> that watches /sys/block/sdX/stat for activity and spins down the driv=
e
> directly (via hdparm) when no activity has been posted for a
> configurable period of time. A daemon process that was responsible fo=
r
> spinning down the constituent drives could also be responsible for
> spinning them up by watching /sys/block/mdX/stat for pending transfer=
s.
> Perhaps you and I could work on such a project.

I added support for spinning down drives only as addition after I
bought first WD Greens . It is done in wrong way, it relies on some
drives in the array working correctly and I guess your way is the
correct one. Do you have specification of /sys/block/sdX/stat?

Right now the script is checking power status of drives by hdparm. I
dont know yet what is in /sys/block/sdX/stat and what is better, but
the basic principle behind my script works perfectly at least in my
setups - if at least one drive from raid array is awake, wake up all
of them.

> One thing mdadm could do which would help greatly is to enumerate the
> member disk block devices (not just partitions or member raid devices=
)
> for a given array. This information is known since concurrent sync
> operations are serialized so no two sync operations occur at the same
> time on the same physical devices.

Maybe Neil can give us his thoughts what is the best place / form for
such functionality.

Patrik

>
> --Larkin
>
> On 5/9/2012 12:37 PM, Patrik Horn=EDk wrote:
>> Hello Neil,
>>
>> I want to propose some functionality for linux raid subsystem that I
>> think will be very practical for many users, automatic waking of
>> drives. I am using my own user land script written years ago to do
>> that and I dont know if there is some standard solution now. If ther=
e
>> is some, please point me to it.
>>
>> I am using couple of big RAID5 arrays in servers working like NASes =
in
>> small office and home, which are in use only small part of the day. =
I
>> am using low power server and aggressive power saving settings on HD=
Ds
>> to make power consumption substantially lower, for example drives ar=
e
>> going to sleep after 15 min of inactivity. Normally problem with suc=
h
>> settings is extremely long waking time when array is accessed.
>> Software accessing data often first requests only chunk of data on
>> first drive in array and waiting cca 20-30 sec for them, after
>> processing them accessing data on another drive and waiting another
>> 20-30 sec and so on.
>>
>> I solved it with my own script in PHP, which monitors drives' status
>> periodically. When it detects that drive from RAID array woke up, it
>> immediately wakes other drives. So total waking time is equal to
>> waking of one drive plus couple of seconds. It works perfectly and
>> smoothly for years for me.
>>
>> I attached the script from one of my servers, it is little cruel and
>> using hwparm and smartctl to monitor and manipulating drives. It is
>> little customized and specific for its server, for example one drive
>> detected by model is not used to wake up other drives and two drives
>> are also putting one another into sleep, because I found out the
>> standby timeout setting was not working reliable on one drive. But y=
ou
>> will get the idea.
>>
>> I think it could be useful for some users if there is possibility to
>> use such feature. Do you think it would be useful? Do you think ther=
e
>> is some place in linux raid infrastructure where it can be somehow
>> implemented? (Possibly as some user land tool using some kernel APIs=
,
>> I dont know.)
>>
>> Best regards,
>>
>> Patrik Horn=EDk
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
