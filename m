From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Strange behaviour on "toy array"
Date: Tue, 17 May 2005 00:12:07 -0700
Message-ID: <42899947.6080107@ucolick.org>
References: <200505170228.j4H2Sim20649@www.watkins-home.com> <42898989.8060201@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42898989.8060201@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just as a further comment on what happened when my system hung: The 
process [md0_sync] was rapidly respawning and the syslog filled with 
thousands of messages like these:

May 16 23:16:44 localhost kernel: md: syncing RAID array md0
May 16 23:16:44 localhost kernel: md: minimum _guaranteed_ 
reconstruction speed\
: 1000 KB/sec/disc.
May 16 23:16:44 localhost kernel: md: using maximum available idle IO 
bandwith \
(but not more than 200000 KB/sec) for reconstruction.
May 16 23:16:44 localhost kernel: md: using 128k window, over a total of 
960 bl\
ocks.
May 16 23:16:44 localhost kernel: md: md0: sync done.
May 16 23:16:44 localhost kernel: md: syncing RAID array md0
May 16 23:16:44 localhost kernel: md: minimum _guaranteed_ 
reconstruction speed\
: 1000 KB/sec/disc.
May 16 23:16:44 localhost kernel: md: using maximum available idle IO 
bandwith \
(but not more than 200000 KB/sec) for reconstruction.
May 16 23:16:44 localhost kernel: md: using 128k window, over a total of 
960 bl\
ocks.
May 16 23:16:45 localhost kernel: md: md0: sync done.
... etc etc...

I had to halt the system to make it stop. I tried to stop the array with 
mdadm -S /dev/md0 but got "device or resource busy". Did i do something 
illegal here?

Thanks,

/Patrik

Patrik Jonsson wrote:

> Ok, so I did as Guy suggested, and tried to write to the array after 
> failing more than one disk. It says:
>
> [root@localhost raidtest]# echo test > junk/test
> -bash: junk/test: Read-only file system
>
> so that's at least an indication that not all is well. The syslog 
> contains:
>
> May 16 22:49:31 localhost kernel: raid5: Disk failure on loop2, 
> disabling device. Operation continuing on 3 devices
> May 16 22:49:31 localhost kernel: RAID5 conf printout:
> May 16 22:49:31 localhost kernel:  --- rd:5 wd:3 fd:2
> May 16 22:49:31 localhost kernel:  disk 1, o:1, dev:loop1
> May 16 22:49:31 localhost kernel:  disk 2, o:0, dev:loop2
> May 16 22:49:31 localhost kernel:  disk 3, o:1, dev:loop3
> May 16 22:49:31 localhost kernel:  disk 4, o:1, dev:loop4
> May 16 22:49:31 localhost kernel: RAID5 conf printout:
> May 16 22:49:31 localhost kernel:  --- rd:5 wd:3 fd:2
> May 16 22:49:31 localhost kernel:  disk 1, o:1, dev:loop1
> May 16 22:49:31 localhost kernel:  disk 3, o:1, dev:loop3
> May 16 22:49:31 localhost kernel:  disk 4, o:1, dev:loop4
> May 16 22:49:39 localhost kernel: Buffer I/O error on device md0, 
> logical block 112
> May 16 22:49:39 localhost kernel: lost page write due to I/O error on md0
> May 16 22:49:39 localhost kernel: Aborting journal on device md0.
> May 16 22:49:44 localhost kernel: ext3_abort called.
> May 16 22:49:44 localhost kernel: EXT3-fs error (device md0): 
> ext3_journal_start_sb: Detected aborted journal
> May 16 22:49:44 localhost kernel: Remounting filesystem read-only
> May 16 22:50:14 localhost kernel: Buffer I/O error on device md0, 
> logical block 19
> May 16 22:50:14 localhost kernel: lost page write due to I/O error on md0
>
> So I guess I'm happy with that, remounting to read-only seems smart, 
> that way the disks aren't messed up more.
> Now I added the disks back with
>
> mdadm --add /dev/loop0
> mdadm --add /dev/loop2
>
> and the (actual hard-) drive started chugging, the md0_raid5 process 
> is sucking cpu and I don't know what it's trying to do... the system 
> has become unresponsive, but the drive is still ticking. Is hot-adding 
> the drives back in a bad thing to do?
>
> This is educational, at least... :-)
>
> /Patrik
>
> Guy wrote:
>
>> My guess is it will not change state until it needs to access a disk.
>> So, try some writes!
>>
>>  
>>
>>  
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> !DSPAM:428989ab396844711317!
>
