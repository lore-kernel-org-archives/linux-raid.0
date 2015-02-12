From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: please help - raid 1 degraded
Date: Thu, 12 Feb 2015 14:12:35 +1100
Message-ID: <54DC1A23.1080307@eyal.emu.id.au>
References: <20150211180403.GA14805@fnord.prismnet.com> <54DBD3E2.80701@websitemanagers.com.au> <20150212000940.GA49579@eris.prismnet.com> <54DBF587.6050004@websitemanagers.com.au> <20150212010200.GA51009@eris.prismnet.com> <54DBFD91.7080507@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DBFD91.7080507@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 12/02/15 12:10, Adam Goryachev wrote:
> On 12/02/15 12:02, sunruh@prismnet.com wrote:
>> ok, so now the really important questions: once done, what files/stats do i need to save off for the next time it craters?
>
> I think the usual information requested is the following:
> fdisk -lu /dev/sd?
> mdadm --manage --query /dev/sd?
> mdadm --manage --detail /dev/md*
> mdadm --manage --examine /dev/sd?

Maybe
	mdadm --misc --query   /dev/md*
         mdadm --misc --detail  /dev/md*
         mdadm --misc --examine /dev/sd*

> cat /proc/mdstat
> ls -l /dev/disk/by-id/
>
> If you can keep a copy of all those things, then you will be much further ahead than many people. Of course, RAID1 is just so much easier/simpler than RAID5/RAID6, so usually you won't need any of that. RAID1 is simple mirror, so if you have two disks, one with data, one without, then you just need to decide which disk has the data, and start with that.
> It is even possible to start two MD arrays, one from each disk, and then compare the contents to decide which one you want to keep.
> Or, you can simply mount the device directly (skipping any MD data at the beginning if needed).
>
> Like I said, RAID1 is by far the simplest type of RAID if you want redundancy and can fit your dataset onto a single device.
>
> Glad you had a successful recovery :)
>
> Regards,
> Adam
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
