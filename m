From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 11:50:04 +0200
Message-ID: <4649824C.1010005@wpkg.org>
References: <4649760A.1060805@wpkg.org> <46497A78.6030109@rabbit.us> <46497CF4.3050807@wpkg.org> <46498053.9000807@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46498053.9000807@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org, Peter Rabbitson <rabbit@rabbit.us>
List-Id: linux-raid.ids

David Greaves schrieb:

(...)

>> So I want to synchronize /dev/LVM2/my-volume (ext3) with /dev/sdr (now
>> empty; bigger than /dev/LVM2/my-volume).
>>
>>
>> (sda2, sdb2, sdc2, sdd2) -> RAID-10 -> LVM-2 -> my volume -> ext3
>>
>>
> 
> 
> I've not used iSCSI but I wonder about using nbd : network block device
> 
> Use nbd to export /dev/md5 from machine 2.
> Import /dev/nbd0 on machine 1.
> Add nbd0 to the VG on machine 1
> pvmove the data from /dev/md10 to /dev/nbd0 (ie the md5 on machine2 via nbd)
> remove /dev/md10 from the VG.


Hmm, maybe using LVM's mirror would help me here:

CONFIG_DM_MIRROR: 


Allow volume managers to mirror logical volumes, also 
 
      needed for live data migration tools such as 'pvmove'.


-- 
Tomasz Chmielewski
http://wpkg.org
