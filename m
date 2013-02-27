From: Khurram Hassan <kfhassan@gmail.com>
Subject: Re: Rocketraid 640 raid 5 disabled
Date: Wed, 27 Feb 2013 20:55:14 +0500
Message-ID: <CAHijsZtnGHWwM4oozxRY7GcAiMBM2H-+xYm9CnvCneeM9WcDAQ@mail.gmail.com>
References: <CAHijsZvKW0A5CWj01X7wp3fDfh9S0RtORnaVZYyE8McsLJLSAQ@mail.gmail.com>
	<512DAA12.3000700@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512DAA12.3000700@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I never said its a "hardware RAID card problem". I am talking about a
degraded raid 5 array in which 2 disks out of a total of 3 disks have
been marked offline even though all 3 disks are listed in the card's
gui. There is nothing wrong with the raid card itself.

I would like to use mdadm to re-write the array's metadata so that the
disks are accessible again. I have done it previously also but with an
intel array and loads of help from Neil Brown. I am hoping he can work
his magic again :)

On Wed, Feb 27, 2013 at 11:39 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 2/26/2013 9:11 PM, Khurram Hassan wrote:
>> I have a disabled raid 5 (3 disks) array on a Rocketraid 640. The full
>> sequence of events follows. After the array was shown as degraded, I
>> checked the webgui (under windows 7) which showed hard disk 3 was bad,
>> so changed this hard disk and the rebuild started. After a few hours,
>> I got a loud continuous beep from the system. Upon checking it, I
>> found that hard disk 1 had bad sectors and was offline. At this time,
>> the rebuild showed 85.1% complete. I clicked rescan and it came back
>> on online. At this time, I started copying data from the raid disk to
>> another hard disk which was not on the raid controller. The raid disk
>> had three volumes and I successfully copied the first volume data. It
>> was during data copy from the 2nd volume that hard disk 1 gave bad
>> sector message again and went offline. I clicked rescan, it came
>> online but then hard disk 2 and hard disk 3 went offline and the array
>> became disabled. The 3 disks are still recognized by the controller,
>> but the array shows only the 1st hard disk as part of the array.
>>
>> Can I use mdadm to recover this array or at least to get the 2nd hard
>> disk as online so that I can copy data from it? I dont boot off the
>> array; I have another hard disk for that purpose. I have installed
>> ubuntu 12.04 on this boot hard disk and have loaded the driver for the
>> controller in it. I dont see anyhard disk devices under /dev for it. I
>> only have /dev/sdax which is for my boot hard disk.
>
> Is this RAID5 array created/controlled by the RocketRAID firmware or
> Linux md/RAID (mdadm).  It sounds like the RocketRAID.  In which case,
> why would you think mdadm could fix a hardware RAID card problem?
>
> --
> Stan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
