From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Fri, 15 Sep 2006 10:29:01 +0200
Message-ID: <20060915082900.GF25819@percy.comedia.it>
References: <1155987607.7207.23.camel@localhost.localdomain> <17641.25141.373827.77279@cse.unsw.edu.au> <1156200453.19051.13.camel@fc6.xsintricity.com> <44FC68A8.4010002@tmr.com> <1157867968.3920.4.camel@localhost.localdomain> <4509DABC.7040205@tmr.com> <1158306672.6349.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1158306672.6349.8.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 15, 2006 at 05:51:12PM +1000, Lem wrote:
>On Thu, 2006-09-14 at 18:42 -0400, Bill Davidsen wrote:
>> Lem wrote:
>> >On Mon, 2006-09-04 at 13:55 -0400, Bill Davidsen wrote:
>> >>May I belatedly say that this is sort-of a kernel issue, since 
>> >>/proc/partitions reflects invalid data? Perhaps a boot option like 
>> >>nopart=sda,sdb or similar would be in order?
....
>> 
>> My suggestion was to Neil or other kernel maintainers. If they agree 
>> that this is worth fixing, the option could be added in the kernel. It 
>> isn't there now, I was soliciting responses on whether this was desirable.
>
>My mistake, sorry. It sounds like a nice idea, and would work well in
>cases where the RAID devices are always assigned the same device names
>(sda, sdb, sdc etc), which I'd expect to be the case quite frequently.

that is the issue, quite frequently != always

>> Unfortunately I see no way to avoid data in the partition table 
>> location, which looks like a partition table, from being used.
>
>Perhaps an alternative would be to convert an array with
>non-partition-based devices to partition-based devices, though I
>remember Neil saying this would involve relocating all of the data on
>the entire array (perhaps could be done through some funky resync
>option?).

sorry, i do not agree
ms-dos partitions are a bad idea, and one i would really love to leave
behind.

what i'd do is move the partition detect code to userspace where it
belongs, togheter with lvm, md, dmraid, multipath and evms 

so what userspace would do is:
check if any wholedisk is one of the above mentioned types
or if it is partitionable.

I believe the order would be something like:
dmraid or multipath
evms (*)
md
lvm
partition table (partx or kpartx)
md
lvm

(*) evms should handle all cases by itself

after each check the device list for the next check should be
recalculated removing devices handled and adding new devices just
created.

this is too much to be done in kernel space, but it can be done easily
in initramfs or initscript. just say Y to "CONFIG_PARTITION_ADVANCED"
and N to all other "CONFIG_?????_PARTITION"
and code something in userspace.

L.

P.S. the op can simply use partx to remove partition tables from the
components of the md array just after assembling.

L.



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
