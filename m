From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Updated MDADM, array dies.
Date: Wed, 26 Nov 2008 17:08:57 -0500
Message-ID: <29a863790811261408h2a8e76eeyc2d7350032226d00@mail.gmail.com>
References: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
	 <20081126211439.M92990@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081126211439.M92990@estone.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: michael <michael@estone.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I haven't renamed anything. rebooted, bam, panic mode for me :)

How can I rename this back?



On Wed, Nov 26, 2008 at 4:16 PM, michael <michael@estone.ca> wrote:
> On Wed, 26 Nov 2008 11:40:52 -0500, Greg Cormier wrote
>> I have a RAID5 array of 4 disks. Was working well. I did a "yum
>> update" and noticed it updated mdadm to mdadm 2.6.7.1, amongst other
>> things (new kernel 2.2.27 instead of .26) , and now my array won't
>> mount.
>>
>> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>> mdadm: cannot open device /dev/sdb1: Device or resource busy
>> mdadm: /dev/sdb1 has no superblock - assembly aborted
>>
>> [root@zeus ~]# cat /proc/mdstat
>> Personalities :
>> md_d0 : inactive sdb1[0](S) sdd1[2](S)
>>       976766976 blocks
>>
>> unused devices: <none>
>>
>
> Did your md devices get renamed?
> You are trying to assemble md0 but yet proc/mdstat shows md_d0
> as the device name.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
