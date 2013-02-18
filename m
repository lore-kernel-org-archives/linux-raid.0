From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Best practice for large storage?
Date: Mon, 18 Feb 2013 11:35:57 +0100
Message-ID: <5122040D.9040404@profitbricks.com>
References: <10665743.0.1361018900938.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10665743.0.1361018900938.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Jeff Johnson <jeff.johnson@aeoncomputing.com>
List-Id: linux-raid.ids

On 16.02.2013 13:48, Roy Sigurd Karlsbakk wrote:
>> On 14.02.2013 18:48, Jeff Johnson wrote:
>>> Stable enough where it is being used at Lawrence Livermore Nat'l
>>> Labs on
>>> a 55PB Lustre resource.
>>>
>>> I've been using it on a pre-release Lustre 2.4 and I have not had
>>> any
>>> issues.
>>
>> ZFS completely fragments if you've got massive parallel write IO -
>> especially with Solaris 11. You'll get only 2..3 MiB/s after some time
>> as everything is stored completely random then. So if you don't really
>> need these snapshots you shouldn't use ZFS. NILFS is also good for
>> snapshots.
> 
> This won't be massive parallel I/O, just a fileserver with a limited amount of users. Also, can you document this claim?

Of cause, we had ZFS in production in our IaaS public cloud. In such a
cloud nearly everything is random. Customers create and delete their
storage from time to time and some of them do a lot of small writes. It
fills up quite fast. We even had no snapshots and we already had the ZIL
dedicated on enterprise SSDs.

http://thomas.gouverneur.name/2011/06/20110609zfs-fragmentation-issue-examining-the-zil/
http://www.racktopsystems.com/dedicated-zfs-intent-log-aka-slogzil-and-data-fragmentation/
http://www.eall.com.br/blog/?p=2481
http://www.techforce.com.br/news/layout/set/print/linux_blog/zfs_part_4_sustained_random_small_files_sync_write_iops

ZFS as block device with COMSTAR exports is really crap. You've got
mostly synchronous (and small database) IO. This is why we switched to a
Linux storage with LVM (without thin stuff). The customers run their
file systems in their VMs anyway.

Cheers,
Sebastian
