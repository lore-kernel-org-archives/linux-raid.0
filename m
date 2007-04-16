From: Chris Allen <chris@cjx.com>
Subject: Re: Recovering a raid5 array with strange event count
Date: Mon, 16 Apr 2007 14:55:06 +0100
Message-ID: <4623803A.9050004@cjx.com>
References: <461F5802.4090608@cjx.com> <17951.29662.910442.896659@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17951.29662.910442.896659@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown wrote:
> On Friday April 13, chris@cjx.com wrote:
>   
>> Dear All,
>>
>> I have an 8-drive raid-5 array running under 2.6.11. This morning it 
>> bombed out, and when I brought
>> it up again, two drives had incorrect event counts:
>>
>>
>> sda1: 0.8258715
>> sdb1: 0.8258715
>> sdc1: 0.8258715
>> sdd1: 0.8258715
>> sde1: 0.8258715
>> sdf1: 0.8258715
>> sdg1: 0.8258708
>> sdh1: 0.8258716
>>
>>
>> sdg1 is out of date (expected), but sdh1 has received an extra event.
>>
>> Any attempt to restart with mdadm --assemble --force, results in an an
>> un-startable array with an event count of 0.8258715.
>>
>> Can anybody advise on the correct command to use to get it started again?
>> I'm assuming I'll need to use mdadm --create --assume-clean - but I'm 
>> not sure
>> which drives should be included/excluded when I do this.
>>     
>
> A difference of 1 in event counts is not supposed to cause a problem.
> Have you tried simply assembling the array without including sdg1.
> e.g.
>   mdadm -A /dev/md0 /dev/sd[abcdefh]1
>
>
>   

Further to this, I have tried upgrading the kernel to 2.6.17. I get the 
same errors.

Don't know if it is any use, but here is the tail of an strace for an 
assemble command for
both the bad system and a similar good system:


STRACE FROM ASSEMBLE - BAD ARRAY:

_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0Z\0\0\0\1\0\0\0\0\0\0\0\371S\2621I\311"..., 
4096) = 4096
close(4)                                = 0
stat64("/dev/sdi1", {st_mode=S_IFBLK|0640, st_rdev=makedev(8, 129), 
...}) = 0
open("/dev/sdb1", O_RDONLY|O_EXCL)      = 4
ioctl(4, BLKGETSIZE64, 0xbffdf150)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0Z\0\0\0\1\0\0\0\0\0\0\0\371S\2621I\311"..., 
4096) = 4096
close(4)                                = 0
ioctl(3, 0x40480923, 0xbffdf2c0)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x40140921, 0xbffdf324)        = 0
ioctl(3, 0x400c0930, 0)                 = -1 EIO (Input/output error)
write(2, "mdadm: failed to RUN_ARRAY /dev/"..., 56mdadm: failed to 
RUN_ARRAY /dev/md0: Input/output error
) = 56
exit_group(1)                           = ?



SAME COMMAND, GOOD ARRAY:

_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0Z\0\0\0\0\0\0\0\0\0\0\0\316\360\34;:"..., 
4096) = 4096
close(4)                                = 0
stat64("/dev/sdh1", {st_mode=S_IFBLK|0640, st_rdev=makedev(8, 113), 
...}) = 0
open("/dev/sda1", O_RDONLY|O_EXCL)      = 4
ioctl(4, BLKGETSIZE64, 0xbfcae6d8)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0Z\0\0\0\0\0\0\0\0\0\0\0\316\360\34;:"..., 
4096) = 4096
close(4)                                = 0
ioctl(3, 0x40480923, 0xbfcae800)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x40140921, 0xbfcae85c)        = 0
ioctl(3, 0x400c0930, 0)                 = 0
write(2, "mdadm: /dev/md0 has been started"..., 46mdadm: /dev/md0 has 
been started with 8 drives) = 46
write(2, ".\n", 2.
)                      = 2
exit_group(0)                           = ?



