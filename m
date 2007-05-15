From: David Greaves <david@dgreaves.com>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 10:41:39 +0100
Message-ID: <46498053.9000807@dgreaves.com>
References: <4649760A.1060805@wpkg.org> <46497A78.6030109@rabbit.us> <46497CF4.3050807@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46497CF4.3050807@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org, Peter Rabbitson <rabbit@rabbit.us>
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:
> Peter Rabbitson schrieb:
>> Tomasz Chmielewski wrote:
>>> I have a RAID-10 setup of four 400 GB HDDs. As the data grows by several
>>> GBs a day, I want to migrate it somehow to RAID-5 on separate disks in a
>>> separate machine.
>>>
>>> Which would be easy, if I didn't have to do it online, without stopping
>>> any services.
>>>
>>>
>>
>> Your /dev/md10 - what is directly on top of it? LVM? XFS? EXT3?
> 
> Good point. I don't want to copy the whole RAID-10.
> I want to copy only one LVM-2 volume (which is like 90% of that RAID-10,
> anyway).
> 
> 
> So I want to synchronize /dev/LVM2/my-volume (ext3) with /dev/sdr (now
> empty; bigger than /dev/LVM2/my-volume).
> 
> 
> (sda2, sdb2, sdc2, sdd2) -> RAID-10 -> LVM-2 -> my volume -> ext3
> 
> 


I've not used iSCSI but I wonder about using nbd : network block device

Use nbd to export /dev/md5 from machine 2.
Import /dev/nbd0 on machine 1.
Add nbd0 to the VG on machine 1
pvmove the data from /dev/md10 to /dev/nbd0 (ie the md5 on machine2 via nbd)
remove /dev/md10 from the VG.
The VG should now exist only on /dev/nbd0 on machine 2
stop the services and lvm on machine 1
start the lvm and services on machine 2.

I'd suggest testing this first <grin>.

David
