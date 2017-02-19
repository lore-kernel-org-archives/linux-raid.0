From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID10 and 'writemostly' support
Date: Sun, 19 Feb 2017 18:48:25 +0100
Message-ID: <ec41ab80-df21-a0f3-9cdd-b7e1fe6ce8dc@thelounge.net>
References: <07e8d394-2f95-caae-d971-a5fef009fefe@thelounge.net>
 <033aa14d-32a0-531d-7d7d-c01a0aeb13eb@youngman.org.uk>
 <f6ed7560-97b8-78ef-26be-789a8bc372b5@thelounge.net>
 <7090c5c7-7f02-14a3-36f1-23b8bfe53043@turmel.org>
 <5a11be45-1793-d4b7-7cf5-3adaef5740d6@thelounge.net>
 <08f52436-9de4-76d0-99c0-c90dedee8ae1@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <08f52436-9de4-76d0-99c0-c90dedee8ae1@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 19.02.2017 um 18:31 schrieb Phil Turmel:
> On 02/18/2017 06:35 PM, Reindl Harald wrote:
>>
>> Am 18.02.2017 um 23:20 schrieb Phil Turmel:
>
>>> If there are features (other than layouts) of raid10 that make you
>>> prefer it to raid1, it would make sense to ask for those features to
>>> be implemented in raid1.
>>
>> writemostly it's also very appealing on existing setups, the machine
>> from where i type was installed in 2011
>>
>> RAID1 don't have the benefit of doubled performance (also for writes, on
>> a hybrid RAID slower but still faster than RAID1) *and* doubled space
>> compared to a single disk combined with mirroring
>
> Doubled capacity?  Vs. raid1?  No.  Raid10,n2 (,n2 is default) on two
> devices yields the same capacity as raid1 on two devices.  Unless I'm
> misunderstanding your point.

you are misunderstanding

RAID1:  2x2 TB = 2 TB usable
RAID10: 4x2 TB = 4 TB useable

typically smaller disks are cheaper and when i installed the 4x2 TB 
RAID10 4 TB disks where not that common and 4 TB SSD not available at 
all (and 2 TB SSD unpaibale)

>> another example: on machines like a HP microserver with only 4 drive
>> slots that you could easily improve read-performance which is for many
>> workloads the most important part by just switch half of the disk to SSD
>>
>> price calculation for a hybrid RAID10 with 10 disks:
>> 5x4 TB SSD = 5 x 1400€ = 7000€
>> 5x4 TB HDD = 5 x 100€ = 500€
>> total price 7500€ versus 14000€ for flash-only
>
> What is preventing you from using the existing raid1 in pairs with
> write mostly, then layering raid0 on top of them for the capacity you
> are trying to achieve?  No new code required.  What you are asking for
> really is raid1+0, which MD raid allows you to assemble yourself.

already existing setups and the easier configuraion of RAID10 than wrap 
2 RAID1 into a RAID0 especially at inital setup time when you also cover 
the os setup itself

/dev/md0         ext4        485M     33M  448M    7% /boot
/dev/md1         ext4         29G    6,8G   22G   24% /
/dev/md2         ext4        3,6T    2,3T  1,4T   63% /mnt/data

md0: RAID1
md1: RAID10
md2: RAID10

it's really not funny to change that existing layout from RAID10 to 
RAID0+RAID1

>> i would be *seriously* willing to pay the inital patch for any kernel
>> maintainer who takes it over - Fedora regulary does kernel-rebases on GA
>> versions
>
> Since no new kernel code is needed to achieve what you desire, I doubt
> a kernel patch for it would be accepted. (But I'm not a maintainer, so
> YMMV.)  This is really a user-space question, along the lines of
> "should/could mdadm automate creation of dual layers like raid1+0?"

at least "mdadm" in the current state should just refuse 
"--write-mostly" when the array is a RAID10 - in that case i would have 
known by testing it based on http://www.tansi.org/hybrid/ in a virtual 
machine that it *really* don't work with RAID10

obviously there is code needed to achieve "writemostly" on the most 
common setup of 4 disks for a RAID10 where you later try to replace half 
of the disks with SSD and have writes only on the remaining HDD

there are so many workloads where read-performance is more imprtant 
(boot, start of large applications, start virtual machines, rsync large 
data...)
