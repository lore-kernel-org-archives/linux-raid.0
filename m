From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Software RAID5 write issues
Date: Thu, 11 Jun 2009 10:05:20 +1000
Message-ID: <916523ED-3D03-4AB1-A64A-1797852ABE9B@crc.id.au>
References: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au> <1244667422.21347.210.camel@firewall.xsintricity.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1244667422.21347.210.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On 11/06/2009, at 6:57 AM, Doug Ledford wrote:

> On Thu, 2009-06-11 at 03:17 +1000, Steven Haigh wrote:
>> Hi all,
>>
>> After a week and a bit of googling, experimenting and frustration I'm
>> posting here and hoping I can get some clues on what could be wrong
>> with my 5 disk RAID5 SATA array.
>>
>> The array in question is:
>> md1 : active raid5 sdg1[0] sdf1[1] sde1[3] sdd1[2] sdc1[4]
>>       1172131840 blocks level 5, 1024k chunk, algorithm 2 [5/5]  
>> [UUUUU]
>>
>> All 5 drives are connection to a sil_sata controller (a 3112 & a  
>> 3114)
>> set up as a simple SATA controller (ie no RAID here).
>>
>> Once the system buffer is full, write speeds to the array are usually
>> under 20MB/sec.
>>
>> I am currently running CentOS 5.3 (kernel
>> 2.6.18-128.1.10.el5.centos.plus).
>>
>> I have lodged a bug report against RHEL 5.3, as I believe something  
>> is
>> not quite right here, but haven't been able to narrow down the exact
>> issue.
>> 	https://bugzilla.redhat.com/show_bug.cgi?id=502499
>>
>> Using bonnie++ to benchmark the array, it shows sequential block  
>> reads
>> at 90MB/sec but writes at 11MB/sec across the RAID5 array - a
>> difference I really didn't expect.
>>
>> Any pointers on how to try to tackle this one and figure out the root
>> cause of the problem would be VERY helpful!
>
> OK, so I read the bug report.  There are two distinctly different
> problems you are experiencing.  One, is a slow down specific to our
> recent kernels.  The slow down in your case takes your normally  
> abysmal
> raid and makes it even worse.  The original bug report was mainly  
> about
> the slowdown, so I'll address that in the bug report.  However, in
> regards to your raid setup, I'll try to address why your array  
> performs
> so poorly regardless of kernel version and maybe that will help you
> build up a better raid setup.
>
> You have 4 motherboard SATA ports, and 4 SATA ports on a PCI card.
> Right now you have your two OS drives on motherboard SATA ports, two  
> of
> the five raid5 drives on motherboard SATA ports, and the three  
> remaining
> raid5 drives on the PCI card SATA ports.  You need to get as many of  
> the
> raid5 SATA disks on motherboard ports as possible.  I would decide if
> you are more concerned about the raid5 array performing well  
> (common, as
> it's usually the data you access most often) or the base OS array
> performing well (not so common, as it gets loaded largely into cache  
> and
> doesn't get hit nearly so often as the data drive).  If you can deal
> with slowing down the OS drives, then I would move one of the OS  
> drives
> to the PCI card and move one of the raid5 drives to the motherboard  
> SATA
> port (and whichever drive you just moved over to the PCI card, I would
> mark it's raid1 arrays as write-mostly so that you don't read from it
> normally).  If your BIOS will allow you to select drives on the PCI  
> card
> as boot drives, and you can tolerate the slow down, then I would move
> both of the OS drives to the PCI card (and don't worry about using
> write-mostly on the raid1 arrays any more) and get 4 of the 5 raid5
> drives onto motherboard SATA ports.
>

This would also be an interesting test - as from memory, now that I  
have updated the firmware on the 3114 card, the BIOS will see those  
drives and allow me to boot from them (hopefully). I will experiment  
here and post the results.

> Your big problem is that with 3 out of 5 raid5 drives on that PCI  
> card,
> and sharing bandwidth, your total theoretical raid speed is abysmal.
> When the three drives are sharing bandwidth on the card, they tend to
> split it up fairly evenly.  That means each drive gets roughly 1/3 of
> the PCI card's total available bandwidth over the PCI bus, which is
> generally poor in the first place.  Understand that a slow drive drags
> down *all* the drives in a raid5 array.  The faster drives just end up
> idling while waiting on the slower drive to finish its work (the  
> faster
> drives will run ahead up to a point, then they eventually just get so
> far ahead that there isn't anything else for them to do until the
> slowest drive finishes up its stuff so old block requests can be
> completed, etc).  On the other hand, if you get 4 of the 5 drives on  
> the
> motherboard ports, then that 5th drive on the PCI card won't be
> splitting bandwidth up and the overall array performance will shoot up
> (assuming the OS drives aren't also heavily loaded).

Isn't the PCI Bus limited to around 133MB/sec? If so, even with 3  
drives on the same controller, you would expect divided equally that  
each drive would get ~44MB/sec before overheads - not around 7MB/sec  
per drive. I know I'm not going to get phenomenal performance with my  
setup, but as most the data is archiving (and then copied to tape), I  
would like to get things at least up to a reasonable level instead of  
having a write speed of ~12% of the read speed.

> If you move one OS drive to the PCI card, then that leaves two raid5
> drives on the card.  In that case, I would seriously consider dropping
> back to a 4 drive array if you can handle the space reduction.  I  
> would
> also seriously consider using raid4 instead of raid5 depending on your
> normal usage pattern.  If the data on the raid5 array is written once
> and then read over and over again, a raid4 can be beneficial in that  
> you
> can stick the parity drive off on the PCI card and it won't be read  
> from
> unless there is a drive failure or one the rare occasions when you  
> write
> new data.  If, on the other hand, you write lots of new data, then
> either don't use raid4, or put the parity drive on a motherboard port
> where it won't hog so much bandwidth on the PCI card.  Ideally, I  
> would
> say get both OS drives on the PCI card, and if you need all 5 drives  
> for
> the data raid, then use raid4 with the parity on the PCI card if the
> array is mostly static, use raid5 otherwise.  If you only move one OS
> drive to the PCI card and still have two raid5 drives on the PCI card,
> then again think about whether your data is static or not and possibly
> use raid4 in an attempt to reduce the traffic on the PCI card.


Hmmm - a very interesting read - but I am a little confused when it  
comes to PCI bandwidth. I would assume (maybe wrongly) that if I can  
READ from the array at 95MB/sec (as measured by bonnie++), then I  
should be able to write to the same array at a little faster than 11MB/ 
sec - as a read would usually read from 4 of 5 drives, however a write  
would go to all drives. This being said, I wouldn't expect one extra  
write to equal 12% of a read speed!

The other thing I wonder is if it has something to do with the  
sil_sata driver - as ALL the drives in the RAID5 are handled by that  
kernel module. The boot RAID1 is on the ICH5 SATA controller - and  
suffers no performance issues at all. It shows a good 40MB/sec+ read  
AND write speeds per drive.

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
