From: Adam Talbot <talbotx@comcast.net>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sun, 25 Jun 2006 17:42:40 -0700
Message-ID: <449F2D80.6080100@comcast.net>
References: <449AEB7C.6040108@cjx.com>	<op.tblclqd3cigqcu@apollo13>	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	<449BE381.6070000@cjx.com>	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>	<449C0505.8000601@tmr.com>	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au> <449CF0D0.9080006@comcast.net> <449F22D7.2090604@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F22D7.2090604@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not exactly sure how to tune for stripe size. 
What would you advise?
-Adam


Bill Davidsen wrote:
> winspeareAdam Talbot wrote:
>
>> OK, this topic I relay need to get in on.
>> I have spent the last few week bench marking my new 1.2TB, 6 disk, RAID6
>> array. I wanted real numbers, not "This FS is faster because..." I have
>> moved over 100TB of data on my new array running the bench mark
>> testing.  I have yet to have any major problems with ReiserFS, EXT2/3,
>> JFS, or XFS.  I have done extensive testing on all, including just
>> trying to break the file system with billions of 1k files, or a 1TB
>> file. Was able to cause some problems with EXT3 and RiserFS with the 1KB
>> and 1TB tests, respectively. but both were fixed with a fsck. My basic
>> test is to move all data from my old server to my new server
>> (whitequeen2) and clock the transfer time.  Whitequeen2 has very little
>> storage.  The NAS's 1.2TB of storage is attached via iSCSI and a cross
>> over cable to the back of whitequeen2.  The data is 100GB of user's
>> files(1KB~2MB), 50GB of MP3's (1MB~5MB) and the rest is movies and
>> system backups 600MB~2GB.  Here is a copy of my current data sheet,
>> including specs on the servers and copy times, my numbers are not
>> perfect, but they should give you a clue about speeds...  XFS wins.
>>  
>>
>
> In many (most?) cases I'm a lot more concerned about filesystem
> stability than performance. That is, I want the fastest <reliable>
> filesystem. With ext2 and ext3 I've run multiple multi-TB machines
> spread over four time zones, and not had a f/s problem updating ~1TB/day.
>
>> The computer: whitequeen2
>> AMD Athlon64 3200 (2.0GHz)
>> 1GB Corsair DDR 400 (2X 512MB's running in dual DDR mode)
>> Foxconn 6150K8MA-8EKRS motherboard
>> Off brand case/power supply
>> 2X os disks, software raid array, RAID 1, Maxtor 51369U3, FW DA620CQ0
>> Intel pro/1000 NIC
>> CentOS 4.3 X86_64 2.6.9
>>    Main app server, Apache, Samba, NFS, NIS
>>
>> The computer: nas
>> AMD Athlon64 3000 (1.8GHz)
>> 256MB Corsair DDR 400 (2X 128MB's running in dual DDR mode)
>> Foxconn 6150K8MA-8EKRS motherboard
>> Off brand case/power supply and drive cages
>> 2X os disks, software raid array, RAID 1, Maxtor 51369U3, FW DA620CQ0
>> 6X software raid array, RAID 6, Maxtor 7V300F0, FW VA111900
>> Gentoo linux. X86_64 2.6.16-gentoo-r9
>>   System built very lite, only built as an iSCSI based NAS.
>>
>> EXT3
>> Config=APP+NFS-->NAS+iSCSI
>> RAID6 64K chunk
>> [root@whitequeen2 tmp]# time tar cf - . | (cd /data ; tar xf - )
>> real    371m29.802s
>> user    1m28.492s
>> sys     46m48.947s
>> /dev/sdb1             1.1T  371G  674G  36% /data
>> 6.192 hours @ 61,262M/hour or 1021M/min or 17.02M/sec
>>
>>
>> EXT2
>> Config=APP+NFS-->NAS+iSCSI
>> RAID6 64K chunk
>> [root@whitequeen2 tmp]# time tar cf - . | ( cd /data/ ; tar xf - )
>> real    401m48.702s
>> user    1m25.599s
>> sys     30m22.620s
>> /dev/sdb1             1.1T  371G  674G  36% /data
>> 6.692 hours @ 56,684M/hour or 945M/min or 15.75M/sec
>>
> Did you tune the extN filesystems to the stripe size of the raid?
>

