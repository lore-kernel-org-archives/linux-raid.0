From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 21:05:11 +1100
Message-ID: <51137C57.7070509@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <511361B3.8060204@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511361B3.8060204@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 19:11, Stan Hoeppner wrote:
> On 2/7/2013 12:48 AM, Adam Goryachev wrote:
> 
>> I'm trying to resolve a significant performance issue (not arbitrary dd
>> tests, etc but real users complaining, real workload performance).
> 
> It's difficult to analyze your situation without even a basic
> description of the workload(s).  What is the file access pattern?  What
> types of files?
> 
>> I'm currently using 5 x 480GB SSD's in a RAID5 as follows:
>> md1 : active raid5 sdf1[0] sdc1[4] sdb1[5] sdd1[3] sde1[1]
>>       1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
> ...
>> Each drive is set to the deadline scheduler.
> 
> Switching to noop may help a little, as may disablig NCQ, i.e. putting
> the driver in native IDE mode, or setting queue depth to 1.

I will make these changes, will see how it goes.
Would that be:
echo 1 > /sys/block/sdb/queue/nr_requests

>> Drives are:
>> Intel 520s MLC 480G SATA3
>> Supposedly Read 550M/Write 520M
> 
>> I think the workload being generated is simply too much for the
>> underlying drives. 
> 
> Not possible.  With an effective spindle width of 4, these SSDs can do
> ~80K random read/write IOPS sustained.  To put that into perspective,
> you would need a ~$150,000 high end FC SAN array controller with 270 15K
> SAS drives in RAID0 to get the same IOPS.
> 
> The problem is not the SSDs.  Probably not the controller either.

Well, that is a relief :) I did hope that spending all that money on the
SSD's was going to provide enough performance.... So, it's probably a
stupid user error... let me provide more info below.

>> I've been collecting the information from
>> /sys/block/<drive>/stat every 10 seconds for each drive. What makes me
>> think the drives are overworked is that the backlog value gets very high
>> at the same time the users complain about performance.
> 
> What is "very high"?  Since you mention "backlog" I'll assume you're
> referring to field #11.  If so, note that on my idle server (field #9 is
> 0), it is currently showing 434045280 for field #11.  That's apparently
> a weighted value of milliseconds.  And apparently it's not reliable as a
> diagnostic value.

Sorry, I was referring to the change in value of field 11 (backlog) over
10 second intervals. It sounded to me like this would be an indication
of how behind the drive was over that time period.

> What you should be looking at is field #9, which simply tells you how
> may IOs are in progress.  But even if this number is high, which it can
> be be very high with SSDs, it doesn't inform you if the drive is
> performing properly or not.  What you should be using is ioptop or
> something similar.  But this still isn't going to be all that informative.

OK, I've uploaded updated graphs showing:
device-8hr.png readsectors (field 3) and writesectors (field 7)
device_backlog-8hour (backlog field 11/activetime field 10)
device_queue-8hour (queue field 9)

I assume ioptop will simply collect values from either /sys or /proc or
similar, and present it in a nice report style format? Did you mean
iotop ? I've downloaded and installed that, but it seems to want to show
IO per process/thread, can you provide any hints on what values I should
be looking at? Maybe the raid5 thread? Is that:
  440 ?        S    183:07  \_ [md1_raid5]


>> The load is a bunch of windows VM's, which were working fine until
>> recently when I migrated the main fileserver/domain controller on
>> (previously it was a single SCSI Ultra320 disk on a standalone machine).
>> Hence, this also seems to indicate a lack of performance.
> 
> You just typed 4 lines and told us nothing of how this relates to the
> problem you wish us to help you solve.  Please be detailed.

I guess I'm not too sure how much information is too much.

OK, the entire system is as follows:
5 x 480G SSD
RAID5
DRBD (with the secondary disconnected during the day because this
improves performance similar to not using DRBD at all, though eventually
I'd like it online all the time...)
LVM to divide into multiple LV's
Each LV is then exported via iSCSI
There is 4 x 1G ethernet (using dual 1G Intel cards)
There are 6 physical machines using Xen 4.1 (debian testing)
Each physical box runs one or two windows VM's and has a single 1G ethernet

3 x Windows 2003 Terminal Servers (with 5 to 20 users each) running misc
apps such as Internet Explorer, MS Outlook, Word, Excel, etc

1 x MS SQL server MS Windows 2008 (basically unused, still in testing)

1 x Domain Controller MS Windows 2000 (this is the new one when the
problems started), this also has about 230G of data which is where most
users pst (outlook data file) lives, as well as word documents/etc.

1 x test workstation (MS Windows XP Pro, mostly unused, just for testing)

1 x MS Windows 2003 Server - Test Terminal Server, AVG (antivirus) admin
server, WSUS server, etc (this is hardly used).

1 x MS Windows 2003 Server - Application server, custom firebird
database application.

From the activity graphs I can see which LV's have lots of read/writes,
and the domain controller is the majority of the load, though if one of
the other machines happens to do lots of read or writes, then it will
impact all of the machines.

>> 1) Get a battery backed RAID controller card (which should improve
>> latency because the OS can pretend it is written while the card deals
>> with writing it to disk).
> 
> [BB/FB]WC is basically useless with SSDs.  LSI has the best boards, and
> the "FastPath" option for SSDs basically disables the onboard cache to
> get it out of the way.  Enterprise SSDs have extra capacitance allowing
> for cache flushing on power loss so battery/flash protection on the RAID
> card isn't necessary.  The write cache on the SSDs themselves is faster
> in aggregate than the RAID card's ASIC and cache RAM interface, thus
> having BBWC on the card enabled with SSDs actually slows you down.
> 
> So, in short, this isn't the answer to your problem, either.

So would it be safe to tell DRBD that I have a battery backed
controller? The system is protected by UPS of course, so power issues
*should* be minimal.

>> 2) Move from a 5 disk RAID5 to a 8 disk RAID10, giving better data
>> protection (can lose up to four drives) and hopefully better performance
>> (main concern right now), and same capacity as current.
> 
> You've got plenty of hardware performance.  Moving to RAID10 will simply
> cost more money with no performance gain.  Here's why:
> 
> md/RAIAD5 and md/RAID10 both rely on a single write thread.  If you've
> been paying attention on this list you know that patches are in the
> works to fix this but are not, AFAIK, in mainline yet, and a long way
> from being in distro kernels.  So, you've got maximum possible read
> performance now, but your *write performance is limited to a single CPU
> core* with both of these RAID drives.  If your problem is write
> performance, your only solution at this time with md is to use a layered
> RAID, such as RAID0 over RAID1 pairs, or linear over RAID1 pairs.  This
> puts all of your cores in play for writes.
> 
> The reason this is an issue is that even a small number of SSDs can
> overwhelm a single md thread, which is limited to one core of
> throughput.  This has also been discussed thoroughly here recently.
> 
>> The real questions are:
>> 1) Is this data enough to say that the performance issue is due to
>> underlying hardware as opposed to a mis-configuration?
> 
> No, it's not.  We really need to have more specific workload data.

Will the graphs showing read/write values assist with this? If not, what
data can I provide which would help? I'm collecting every value in the
/sys/block/<device>/stat file already, on 10sec intervals...

I have another system which collects and graphs the overall CPU load,
during the day this sits around 0.5, so this could certainly be related?
I know loadavg is not so useful, what would be the best tool/number to
watch to determine this?

>> 2) If so, any suggestions on specific hardware which would help?
> 
> It's not a hardware problem.  Given that it's a VM consolidation host,
> I'd guess it's a hypervisor configuration problem.

Possibly, but since the issue appears to be disk IO performance, and
since the various stats I've been collecting seemed to indicate the
backlog was happening at the disk level, I thought this pointed to the
problem. It is pretty challenging to diagnose all of the layers at the
same time! So I started at the bottom...

>> It is possibly to wipe the array and re-create that would help.......
> 
> Unless you're write IOPS starved due to md/RAID5 as I described above,
> blowing away the array and creating a new one isn't going to help.  You
> simply need to investigate further.

So how do I know if I'm write IOPS starved? Is there a number somewhere
which can be used to identify this?

> And if you would like continued assistance, you'd need to provide much
> greater detail of the hardware and workload.  You didn't mention your
> CPU(s) model/freq.  This matters greatly with RAID5 and SSD.  Nor RAM
> type/capacity, network topology, nor number of users and what
> applications they're running when they report the performance problem.
> Nor did you mention which hypervisor kernel/distro you're using, how
> many Windows VMs you're running, and the primary workload of each, etc,
> etc, etc.

Storage server:
Intel S1200BTLR Serverboard - LGA1155 / 4xDDR3 / 6xSATAII / Raid / 2xGbE
Intel Xeon E3-1230V2/3.3GHz/8MB CACHE/4CORE/8THREAD/5GTs/LGA1155 CPU
Kingston 4GB 1333MHz DDR3 ECC CL9 240PIN DIMM with Thermal Sensor
(Intel) (times 2, total 8G RAM)
Intel Dual Port Server PCIe v2.0 Adapter, I350-T2, Rj-45 Copper,
Low Profile & Full Height I350T2 (time 2, total 6 x 1G ethernet)
5 x Intel 520s MLC 480G SATA3
Debian Stable with DRBD 8.3.15, kernel 2.6.32-5-amd64

Physical Servers:
AMD PHENOM II X6 1100T 6CORE/3.3GHz/9MB CACHE/125W/Black Edition
Asus M5A88-M AMD Socket AM3+ Motherboard
Kingston 4GB 1333MHz DDR3 NON-ECC CL9 240pin KVR1333D3N9/4G (total 32G)
Intel 40GB X25M 320 Series SSD Drive
Debian Testing, kernel 3.2.0-4-amd64 and Xen 4.1

All servers connected to:
Netgear GS716T - 16 Port Gigabit Ethernet Switch


The problems are somewhat intermittent, sometimes the users don't even
advise of the problems. Basically, on occasion, when a user copies a
large file from disk to disk, or when a user is using Outlook
(frequently data files are over 2G), or just general workload, the
system will "stall", sometimes causing user level errors, which mostly
affects Outlook.

>> Sorry, graphs can be seen at:
>> http://203.98.89.64/graphs/
> The graphs tell us nothing in isolation Adam.  What is needed is to know
> what workloads are running when the device queues and response times
> start piling up.  Whether rust or SSD, queues will increase, as well as
> IO completion times, when sufficient IO is being performed.

I've updated the graphs and added additional graphs as above. I'm still
not sure exactly what data I can provide. The main thing I do know is
that at some random time (a number of times throughout a normal working
day) a number of users will report issues of freezing, and sometimes
this is over an extended period of time (10 minutes), usually I can see
a large amount of read/write activity which corresponds at the same time
(though I don't know specifically what application or user caused the
read/write activity). I can only imagine copying a 50G file from
directory A to directory B (on the same disk) would be equivalent to
generate the load, and all the other random normal IO at the same time.

So, is there any further information I should provide? What hard numbers
can I look at to guide me?

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
