From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: RAID 10 on Fusion IO cards problems
Date: Thu, 29 Aug 2013 10:33:57 -0300
Message-ID: <CAH3kUhELZ9DvsSADB++z532dSPauMD4HasckAMgNiWRQvHgDyQ@mail.gmail.com>
References: <CAGkViCEJqcGHZQgn0moxFbhHr_XJ0uswy1C4L_nrURR6VKCwSw@mail.gmail.com>
	<CAH3kUhGcs718B_0+Ci3QeFvUqQrXNQiw+O+MSr2+whauHML37Q@mail.gmail.com>
	<CAGkViCHFtZ4S-bqgokwkOS_Lr4wOnqSrGL9hVMcibkGnwwh9ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCHFtZ4S-bqgokwkOS_Lr4wOnqSrGL9hVMcibkGnwwh9ug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i created it with
mdadm --create /dev/md0 --level=10 --layout=f2 --raid-devices=4
/dev/sda /dev/sdb /dev/sdc /dev/sdd

i didn't used the chunck option (512kb is the default right?)
i think you can omit the layout, maybe the n2 is better  but i didn't tested
i use the f2 in hdd configs when i want a 'big' read performace and a
write isn't important, since ssd don't have head, maybe a layout=n2
(or no layout option, just use the default) is better, but you must
test with your workload


2013/8/29 Albert Pauw <albert.pauw@gmail.com>:
> Hi Roberto,
>
> could you share your setup? What chunksize did you use, e.g. How did
> you create it (if you can remember)?
>
> Thanks,
>
> Albert
>
> On 29 August 2013 15:11, Roberto Spadim <rspadim@gmail.com> wrote:
>> i use a raid10 far in revodrive cards, but i'm using kernel 3.10.7
>> with slackware and it runs fine
>>
>> 2013/8/29 Albert Pauw <albert.pauw@gmail.com>:
>>> Hi guys,
>>>
>>> I am trying to get a RAID 10 configuration working at work, but seem
>>> to hit a performance wall after 20 minutes into a DB creation session.
>>>
>>> Here's the setup:
>>>
>>> OS: Oracle Linux 5.9 (effectively RHEL 5.9), kernel  2.6.32-400.29.2.el5uek.
>>> All utilities updates, mdadm (2.6.9 latest through updates).
>>>
>>> Setup:
>>>
>>> Two Fusion IO Duo cards, each Fusion IO device 640 GB, so four in total.
>>>
>>> Raid 10 set up as:
>>>
>>> striped between the two IO devices on the same Fusion IO card, and
>>> mirrored between the separate cards.
>>>
>>> So, Fusion IO card 1, device fioa and fiob, Fusion IO card 2, device
>>> fioc and fiod.
>>>
>>> The two stripes are fioa/fiob and fioc/fiod, and a mirror between these devices:
>>>
>>> mdadm --create --verbose /dev/md0 --level=10 --metadata=1.2
>>> --chunk=512 --raid-devices=4 /dev/fioa /dev/fioc /dev/fiob /dev/fiod
>>> --assume-clean -N md0
>>>
>>> When the performance turned out bad, after about 20 minutes, the
>>> process was stopped. I broke the mirror, so the md0 device is only
>>> striped, but the performance hit after 20 minutes happened again.
>>>
>>> The status of all cards are fine, no problems there. Then I created a
>>> fs on only one device and have it run again. This time it worked fine.
>>> The fs was in all cases ext3, no TRIM.
>>>
>>> Any suggestions, experience with this kind of setup?
>>>
>>> Thanks,
>>>
>>> Albert
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Roberto Spadim



-- 
Roberto Spadim
