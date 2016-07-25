From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Tue, 26 Jul 2016 09:08:35 +1000
Message-ID: <31663d09-eead-9e57-f1d7-34c19c901b91@websitemanagers.com.au>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/07/16 07:14, bobzer wrote:
> Hi,
>
> I'm looking for advice to not mess up my migration. because
> unfortunately i miss drive
> I wanna migrate all my data from a raid 5 of 4x2TB (actually 3 because
> i'm degraded right now) to a raid 6 of 4x4TB
> so exactly i got :
> - raid 5, should be 4 disk of 2T but got problem and so right now it's
> just 2x2T and a 2Tb disk image in a 4T disk (the raid crashed and is
> not start right now but is clean)
> - 2 disk of 4TB
> - the raid 5 use lvm2 on top of mdadm
>
> I want a raid 6 so i thought i could create a raid 6 degraded with the
> 2x4TB and after copy the data to this new raid and after add the third
> 4TB and finally add the 2  2TB as a raid 0 to get a 4TB
> I know it's an ideal solution to get 3x4TB + 2x2TB to do my raid but
> it give me time to invest.
>
> So my question is :
> - is it a really bad idea ?
> - do you have a better idea? solution ?
> - maybe i can migrate instead of copy a raid to another ?
>
> thank you very much
> Math
My head hurts, I don't understand what you currently have, but I think 
you have:
RAID5 with three members, sda1(2TB), sdb1(2TB) and an 2TB image stored 
on sdc1(4TB)
Two spare 4TB drives sdd1 and sde1.

I would do a replace from the image on sdc1 to sde1
Do a replace from sda1 to sdc1
Do a replace from sdb1 to sdd1
Create a RAID0 array on sda1 + sdb1 (linear or stripe, guess it doesn't 
matter much either way, though if performance matters, then think about 
this as it will throw out the expected performance of your array).
Do a add of the RAID0 to the RAID5 (it will add as a spare)
Do a grow of the RAID5 to RAID6
Do a grow --size=max to increase capacity to the smallest drive (don't 
do the grow earlier, the RAID0 might be slightly smaller).

The above means at no point is your RAID5 degraded, and you end up with 
RAID6.
It will probably take some time to do all that, I'm not sure if the 2nd 
and 3rd steps can be done in parallel or not...

PS, you should take a copy of all your RAID information and drive member 
details (lsdrv script) before commencing so that if something goes 
wrong, you have the best chance of recovery.
!!!Also, definitely ensure you have SCT/ERC configured properly on both 
the old and new drives!!!

Regards,
Adam
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
