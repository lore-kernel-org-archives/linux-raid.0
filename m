From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 5 Dec 2008 16:58:59 -0800 (PST)
Message-ID: <590849.18955.qm@web30808.mail.mud.yahoo.com>
References: <936691.74609.qm@web30806.mail.mud.yahoo.com> <447802.83994.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0812051922530.4906@p34.internal.lan> <616202.13446.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0812051950550.12295@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I'll wait some more before doing that and see if Neil or someone else pipes in.  I am really trying to avoid recreating the superblock structures, though it's pretty clear what the sequence of devices is from doing examines on them.

thx
mike




----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Friday, December 5, 2008 4:51:26 PM
Subject: Re: Need urgent help in fixing raid5 array

Only use it as A LAST resort, check the mailing list or wait for 
Neil/someone else with/whose had a similar issue who can maybe help more 
here.

On Fri, 5 Dec 2008, Mike Myers wrote:

> Thanks very much.  All the disks I am trying to assemble have the same event count and UUID, which is why I don't understand why it's not assembling.  I'll try the assume-clean option and see if that helps.
>
> It would be great to understand how md determines if the drives are in sync with each other.  I thought the uuid and event count was all you needed...
>
> thx
> mike
>
>
>
>
> ----- Original Message ----
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> To: Mike Myers <mikesm559@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Friday, December 5, 2008 4:24:46 PM
> Subject: Re: Need urgent help in fixing raid5 array
>
>
> You can try this as a last resort:
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07815.html
>
> (mdadm w/create and assume-clean) but only use this as a last resort, when
> I had two disk failures, I was able to see some of the data but ultimately
> it was lost, bottom line? i dont use raid5 anymore, raid6 only, in the
> 3ware docs they recommend if you use more than 4 disks you should use
> raid6 if you have the capability, i agree
>
> some others on the list may have more . less intrusive ideas . only  use
> the above method as a LAST RESORT, i was able to assemble the array but I
> had problems getting xfs_repair to fix the filesystem
>
> On Fri, 5 Dec 2008, Mike Myers wrote:
>
>> Anyone?  What am I missing here?
>>
>> thx
>> mike
>>
>>
>>
>>
>> ----- Original Message ----
>> From: Mike Myers <mikesm559@yahoo.com>
>> To: linux-raid@vger.kernel.org
>> Sent: Friday, December 5, 2008 9:03:22 AM
>> Subject: Need urgent help in fixing raid5 array
>>
>> I have a problem with repairing a raid5 array I really need some help with.  I must be missing something here.
>>
>> I have 2 raid5 arrays combined with LVM into a common logical volume and then running XFS on top of that.  Both arrays have 7 1 TB disks in them.  I moved a controller card around so that I could install a new Intel GB ethernet card in one of the PCI-E slots.  That went fine except one of the SATA cables got knocked loose so one of the disks in /dev/md2 wen't offline.  Linux booted fine, started the md2 with 6 elements in it and everything was fine with md2 in a degraded state.  I fixed the cable problem and hot added that drive to the array, but since it was now out of sync, md began a rebuild.  No problem.
>>
>> Around 60% through the resync, smartd started reporting problems with one of the other drives in the array.  Then that drive ejected from the degraded array, caused the raid to stop and the LVm volume to go offline.  Ugh...
>>
>> Ok, so it looks from the smart data that that disk had been having a lot of problems and was failing.  As it happens, I had a new 1 TB disk arrive the same day, and I pressed it to service here.  I used sfdisk -d olddisk | sfdisk newdisk to copy the partition table from the old drive to the new one, and then used ddrescue to copy the data from the old partition (/dev/sdo1) to the new one (/dev/sdp1). That worked pretty well, just 12kB couldn't be recovered.
>>
>> So I remove the old disk,  re-add the new disk, and attempt to start the array with new (cloned) 1 Tb disk in the old disks stead.  Even though the UUID's, magic numbers and events fields are all the same, md thinks the cloned disk is a spare, and doesn't start the array.  What am I missing here?  Why doesn't it view it as the old disk as a member and just start it?
>>
>> thx
>> mike
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
>
>



      
