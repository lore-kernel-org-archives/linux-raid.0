From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID10 Performance
Date: Fri, 27 Jul 2012 23:02:46 +1000
Message-ID: <50129176.3050604@websitemanagers.com.au>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50123E2C.8090108@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/07/12 17:07, Stan Hoeppner wrote:
> On 7/26/2012 9:16 AM, Adam Goryachev wrote:
> 
>> I've got a system with the following config that I am trying to
>> improve performance on. Hopefully you can help guide me in the
>> best direction please.
> 
>> 3 x 2TB WDC WD2003FYYS-02W0B1
> ...
>> The three HDD's are configured in a single RAID10
> ...
>> Which is then shared with DRBD to another identical system. Then
>> LVM is used to carve the redundant storage into virtual disks 
>> Finally, iSCSI is used to export the virtual disks to the
>> various virtual machines running on other physical boxes.
>> 
>> When a single VM is accessing data, performance is more than
>> acceptable (max around 110M/s as reported by dd)
>> 
>> The two SAN machines have 1 Gb ethernet crossover between them,
>> and 4 x Gb bonded to the switch which connects to the physical
>> machines running the VM's (which have only a single Gb
>> connection).
>> 
>> The issue is poor performance when more than one machine attempts
>> to do disk intensive activity at the same time (ie, when the anti
>> virus scan starts on all VM's at the same time, or during the
>> backup window, etc).
> ...
> 
> I'm really surprised you don't already know the answer, and that
> you gave such a lengthy detailed description.

Ummm, yes, well I was hoping for some magic I didn't already know :)

> Your problem is very simple.  It is suffered by many people, who
> lack basic understanding of rotating drive performance in relation
> to their workloads.
> 
> You don't have enough seek bandwidth.  The drive heads simply can't
> move fast enough to service all sector requests in a timely manner.
> There is no way to fix this by tweaking the operating system.  You
> need to increase your seek rate.
> 
> 1.  Recreate the arrays with 6 or 8 drives each, use a 64KB chunk

Would you suggest these 6 - 8 drives in RAID10 or some other RAID
level? (IMHO, the best performance with reasonable protection is RAID10)

How do you get that many drives into a decent "server"? I'm using a
4RU rackmount server case, but it only has capacity for 5 x hot swap
3.5" drives (plus one internal drive).

> 2.  Replace the 7.2k WD drives with 10k SATA, or 15k SAS drives

Which drives would you suggest? The drives I have are already over
$350 each (AUD)...

> 3.  Replace the drives with SSDs

Yes, I'd love to do this.

> Any of these 3 things will decrease latency per request.

I have already advised adding an additional pair of drives, and
converting to SSD's.

Would adding another 2 identical drives and configuring in RAID10
really improve performance by double?

Would it be more than double (because much less seeking should give
better throughput, similar I expect to performance of two concurrent
reads is less than half of a single read)?

If using SSD's, what would you suggest to get 1TB usable space?
Would 4 x Intel 480GB SSD 520 Series (see link) in RAID10 be the best
solution? Would it make more sense to use 4 in RAID6 so that expansion
is easier in future (ie, add a 5th drive to add 480G usable storage)?

http://www.megaware.com.au/index.php?main_page=product_info&cPath=16_1579&products_id=133503

I'm just trying to get some real life experiences from others. This
system is pretty much the highest performing system I've built to date....

Thank you for your comments, I do appreciate them.

Regards,
Adam

PS, thanks for the reminder that RAID10 grow is not yet supported, I
may need to do some creative raid management to "grow" the array,
extended downtime is possible to get that done when needed...

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
