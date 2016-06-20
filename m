From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: unbalanced RAID5 / performance issues
Date: Tue, 21 Jun 2016 09:41:11 +1000
Message-ID: <57687F17.3010002@websitemanagers.com.au>
References: <57678E2D.9080705@websitemanagers.com.au>
 <20160620104455.Horde.Cu9WNhgOSFjDC3hgl4ZCm01@www3.nde.ag>
 <20160620092600.GA3549@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160620092600.GA3549@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/06/16 19:26, Andreas Klauer wrote:
> On Mon, Jun 20, 2016 at 10:44:55AM +0200, Jens-U. Mozdzen wrote:
>> Zitat von Adam Goryachev <adam@websitemanagers.com.au>:
>>> As you can see, sdc (and sda) has a much higher utilisation compared
>>> to all the other drives, but we can see the actual reads/writes are
>>> similar across all drives.
>> looking at those numbers, it might not be the (effective) utilization
>> that's higher, but the time the SSDs spend handling the requests.
> sdc also happens to be the last drive in your array.
>
> When creating raid5, the initial sync will overwrite this drive completely.
> Are you using fstrim / discard? Without TRIM this SSD might consider itself
> completely full and take longer for new writes.
I'm fairly certain that all drives have been completely written to by 
now. The system is around 4 years old, and we do approx 200GB or more of 
writes per day....
I'm also fairly certain that TRIM is not working through the entire stack:
Windows 2012R2
Xen GPLPV drivers (old ones)
Xen 4.1
Linux open-iSCSI 2.0.873
Linux iscsitarget (iet) 1.4.20.3+svn502-1
DRBD 8.4.x
LVM2
Linux MD RAID5
Partitions
SSD

I never really tried to test for TRIM support through the stack, but I'd 
be shocked if it was working.....
> Also there might be an issue with SF-2281 controller used by these SSDs:
>
> http://www.anandtech.com/show/5508/intel-ssd-520-review-cherryville-brings-reliability-to-sandforce/7
>
> They state that even after TRIM the SSD does not return to
> its prime condition...
The performance seems better on the 520 series (older series) than the 
530 one.... I'm not sure which chipset/firmware the 530 series use, but 
I would have expected it to be better...
Looking at the spec sheets for each I see:
Model                    Seq Read    Seq Write    Random Read Random Write
2.5" 480GB 520Series    540MB/s      490MB/s    41KIOPS        80KIOPS
2.5" 480GB 530Series    550MB/s      520MB/s 50KIOPS        42KIOPS

For some reason, maybe the Random Write IOPS being almost half is 
causing the problems?
> Apart from that, double check that your partitions are aligned.
> This is usually the case but may be a huge problem if overlooked.

All of the drives are partitioned identically:
Disk /dev/sdh: 480 GB, 480101368320 bytes
255 heads, 63 sectors/track, 58369 cylinders, total 937697985 sectors
Units = sectors of 1 * 512 = 512 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdh1              64   937697984   468848961   fd  Lnx RAID auto

Not sure if that is "correctly aligned". I note that on newer 
systems/drives I see partitions starting at 2048 instead of 64, but I 
think that is just to allow extra space for grub/etc...
I think I'll try to swap the single 530 drive with another one if I dare 
(means dropping redundancy on the array during the re-sync....)

My main concern is that it could be due to the way the array is 
configured, ie, chunk size/etc, but it does also seem to be related to 
the model number of the drive.

BTW, the array has been grown a couple of times, it wasn't created new 
with all 8 drives, so originally, sdc wasn't the last drive, it is 
probably the most recently added drive though.

Regards,
Adam
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
