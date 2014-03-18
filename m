From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Tue, 18 Mar 2014 06:22:20 -0500
Message-ID: <53282C6C.4090502@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5327A462.2060303@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/17/2014 8:41 PM, Adam Goryachev wrote:
> On 18/03/14 08:43, Stan Hoeppner wrote:
>> On 3/17/2014 12:43 AM, Adam Goryachev wrote:
>>> On 13/03/14 22:58, Stan Hoeppner wrote:
>>>> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
>>>>> So, I could simply do the following:
>>>>> mdadm --manage /dev/md1 --add /dev/sdb1
>>>>> mdadm --grow /dev/md1 --raid-devices=6
>>>>>
>>>>> Probably also need to remove the bitmap and re-add the bitmap.
>>>> Might want to do
>>>>
>>>> ~$ echo 250000 > /proc/sys/dev/raid/speed_limit_min
>>>> ~$ echo 500000 > /proc/sys/dev/raid/speed_limit_min
>>>>
>>>> That'll bump min resync to 250 MB/s per drive, max 500 MB/s.  IIRC the
>>>> defaults are 1 MB/s and 100 MB/s.
>>> Worked perfectly on one machine, the second machine hung, and basically
>>> crashed. Almost turned into a disaster, but thankfully having two copies
>>> over the two machines I managed to get everything sorted. After a
>>> reboot, the second machine recovered and it grew the array also.
>> See:https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=629442
>>
>> This is the backup machine, yes?  Last info I had from you said this box
>> was using rust not SSD.  Is that still the case?  If so you should not
>> have bumped the reshape speed upward as rust can't handle it, especially
>> with load other than md on it.
> 
> The second machine is hardware and software identical to the primary
> now, ie, both had 5 x 480GB SSD, and I added 1 x 480GB SSD to each.
> 
>> Also, I recall you had to install a
>> backport kernel on san1 as well as a new iscsi-target package.
>>
>> What kernel and iscsi-target version is running on each of san1 and
>> san2.  I'm guessing they're not the same.
> 
> Yep, I did install 3.2.41-2~bpo60+1 some time ago, but it looks like
> I've upgraded to 3.2.54-2 since then, and that is the version currently
> running.
> ii  iscsitarget 1.4.20.2-10.1                 amd64        iSCSI
> Enterprise Target userland tools
> ii  iscsitarget-dkms 1.4.20.2-10.1                 all          iSCSI
> Enterprise Target kernel module source - dkms version
> 
> Versions are identical on both machines. I don't think it is a iscsi
> issue, I think iscsi had a problem because the kernel stopped providing
> IO...

Given the multi-gigabyte/sec throughput of your block hardware I'd say
it's fairly certain that you had plenty of idle HBA and SSD when this
warning and stack trace occurred.  Thus you hit a kernel bug.  I don't
have time to track it down.  And since this only occurred on one of two
identical machines performing identical reshape operations, it's likely
not something that will affect your production workload.

>> What elevator is configured on san1 and san2?  It should be noop for SSD
>> and deadline for rust.
> This is from /etc/rc.local:
> for disk in sda sdb sdc sdd sde sdf sdg
> do
>         echo noop > /sys/block/${disk}/queue/scheduler
>         echo 128 > /sys/block/${disk}/queue/nr_requests
> done
> echo 4096 > /sys/block/md1/md/stripe_cache_size
> 
> It is identical on both machines.
> NOTE: I just added sdg to the end now, so it wasn't there before.
> However, sdg is/would have been the OS 120G SSD, therefore shouldn't
> make any difference with the raid array.
> 
> I was thinking recently that maybe I should try and use cfq or deadline,
> as one of the issues I'm getting is IO starvation with multiple heavy IO
> workloads. 

First, CFQ and deadline are coded specifically for rotational disks.
They are designed to do basically the same thing as TCQ/NCQ.  With SSD
they will do nothing but add latency, not decrease it.  Regardless, if
you simply look at iostat you'll see that the SSD latency isn't your
problem.

I know what the TS client performance problem with your production
workload is and it has nothing to do with your iSCSI servers.  You know
what it is as well but you've forgotten over the past year since I
helped you track it down.  See below.

> ie, if I leave the DRBD connection up between the machines,
> single copy from a client is around 25 to 30MB/s, but if I do two copies
> I can see each copy take turns for around 5 or more seconds each.
> Although I'm hoping the below faster interconnect will help to resolve
> this.
> 
>>> Some of the logs from that time:
>>> Mar 13 23:05:59 san2 kernel: [42511.418380] RAID conf printout:
>>> Mar 13 23:05:59 san2 kernel: [42511.418385]  --- level:5 rd:6 wd:6
>>> Mar 13 23:05:59 san2 kernel: [42511.418388]  disk 0, o:1, dev:sdc1
>>> Mar 13 23:05:59 san2 kernel: [42511.418390]  disk 1, o:1, dev:sde1
>>> Mar 13 23:05:59 san2 kernel: [42511.418392]  disk 2, o:1, dev:sdd1
>>> Mar 13 23:05:59 san2 kernel: [42511.418394]  disk 3, o:1, dev:sdf1
>>> Mar 13 23:05:59 san2 kernel: [42511.418396]  disk 4, o:1, dev:sda1
>>> Mar 13 23:05:59 san2 kernel: [42511.418399]  disk 5, o:1, dev:sdb1
>>> Mar 13 23:05:59 san2 kernel: [42511.418444] md: reshape of RAID array
>>> md1
>>> Mar 13 23:05:59 san2 kernel: [42511.418448] md: minimum _guaranteed_
>>> speed: 1000 KB/sec/disk.
>>> Mar 13 23:05:59 san2 kernel: [42511.418451] md: using maximum available
>>> idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
>>> Mar 13 23:05:59 san2 kernel: [42511.418493] md: using 128k window, over
>>> a total of 468847936k.
>>> Mar 13 23:06:00 san2 kernel: [42511.512165] md: md_do_sync() got signal
>>> ... exiting
>>> Mar 13 23:07:01 san2 kernel: [42573.067781] iscsi_trgt: Abort Task (01)
>>> issued on tid:9 lun:0 by sid:8162774362161664 (Function Complete)
>>> Mar 13 23:07:01 san2 kernel: [42573.067789] iscsi_trgt: Abort Task (01)
>>> issued on tid:11 lun:0 by sid:7318349599801856 (Function Complete)
>>> Mar 13 23:07:01 san2 kernel: [42573.067797] iscsi_trgt: Abort Task (01)
>>> issued on tid:12 lun:0 by sid:6473924787110400 (Function Complete)
>>> Mar 13 23:07:01 san2 kernel: [42573.067838] iscsi_trgt: Abort Task (01)
>>> issued on tid:14 lun:0 by sid:5348025014485504 (Function Complete)
>>> Mar 13 23:07:02 san2 kernel: [42573.237591] iscsi_trgt: Abort Task (01)
>>> issued on tid:8 lun:0 by sid:4503599899804160 (Function Complete)
>>> Mar 13 23:07:02 san2 kernel: [42573.237600] iscsi_trgt: Abort Task (01)
>>> issued on tid:2 lun:0 by sid:14918173819994624 (Function Complete)
>> ...
>>> I probably hit CTRL-C causing the "got signal... exiting" because the
>>> system wasn't responding. There are a *lot* more iscsi errors and then
>>> these:
>>> Mar 13 23:09:09 san2 kernel: [42700.645060] INFO: task md1_raid5:314
>>> blocked for more than 120 seconds.
>> The md write thread blocked for more than 2 minutes.  Often these
>> timeouts are due to multiple processes fighting for IO.  This leads me
>> to believe san2 has rust based disk, and that the kernel and other
>> tweaks applied to san1 were not applied to san2.
>>
>> ...
> Nope, both san1 and san2 are identical.... however, yes, it looks like
> IO starvation, which I suspect is because md1 was blocking, which is
> where drbd/lvm2/iscsi gets the data from.

But again you should have had no iSCSI sessions active, and if you
didn't shutdown DRBD during a reshape then you're asking for it anyway.
 Recall in my initial response I recommended you shutdown DRBD before
doing the reshapes?

>>> This did lead to another observation.... The speed of the resync seemed
>>> limited by something other than disk IO.
>> On both san1/san2 or just san1?  I'm assuming for now you mean san1 only.
> 
> I watched the resync a lot closer on san2, because while san1 did the
> resync I was driving into the office :)
> 
>>> It was usually around 250 to
>>> 300MB/s, the maximum achieved was around 420MB/s. I also noticed that
>>> idle CPU time on one of the cores was relatively low, though I never saw
>>> it hit 0 (minimum I saw was 12% idle, average around 20%).
>> Never look at idle, but what's eating the CPU.  Was that 80+% being
>> eaten by sys, wa, or a process?  Without that information it's not
>> possible to definitely answer your questions below.
> 
> Unfortunately I should have logged the info but didn't. I am pretty sure
> md1_resync was at the top of the task list...

A reshape reads and writes all drives concurrently.  You're likely not
going to get even one drive worth of write throughput.  Your FIO testing
under my direction showed 1.6GB/s div 4 = 400MB/s peak per drive write
throughput with a highly parallel workload, i.e. queue depth >4.  I'd
say these reshape numbers are pretty good.  If it peaked at 420MB/s and
average 250-300 then other processes were accessing the drives.  If DRBD
was active that would probably explain it.  This isn't something to
spend any time worrying about because it's not relevant to your
production issues.

>> Do note, recall that during fio testing you were hitting 1.6 GB/s write
>> throughput, ~4x greater than the resync throughput stated above.  If one
>> of your cores was at greater than 80% utilization with only ~420 MB/s of
>> resync throughput, then something other than the md write thread was
>> hammering that core.

> Shouldn't be any other CPU tasks running on this machine. These machines
> only do MD RAID + DRBD + LVM2 + iSCSI, there are no other tasks that run
> on these systems.

Scratch that.  I wasn't thinking straight here.  A RAID5 reshape is more
CPU intensive than multi-threaded FIO.  With a reshape everything is an
RMW operation, many more cycles are spent managing the stripe cache due
to the reads, etc.

>>> So, I'm wondering whether I should consider upgrading the CPU and/or
>>> motherboard to try and improve peak performance?
>> As I mentioned after walking you through all of the fio testing, you
>> have far more hardware than your workload needs.
> Which is driving me insance..... I really really don't understand why I
> have such horrible performance :(
> I don't know what is missing or lacking to cause things to perform so
> poorly when benchmarks run so well, but live usage is so poor.
> 
> Right now users are complaining about performance, and I see md1_raid5
> in the top 1 or 2 process positions, but CPU utilisation is under 2%
> user, 5% sys, and 3%ni, and over 95% idle, wa is practically 0....

You're looking in the wrong place--on the wrong box.

>>> My understanding is that the RAID5 is single threaded, so will work best
>>> with a higher speed single core CPU compared to a larger number of cores
>>> at a lower speed. However, I'm not sure how much "work" is being done
>>> across the various models. ie, does a E5 CPU do more work even though it
>>> has a lower clock speed? Does this carry over to the E7 class as well?
>> You're chasing a red herring.  Any performance issue you currently have,
>> and I've seen no evidence of such to this point, is not due to the model
>> of CPU in the box.  It's due to tuning, administration, etc.
>
> OK, so forgetting about a newer CPU then (I really can't imagine that
> any near modern CPU should not be capable of this work load, but I'm
> struggling to solve the underlying issues, and I'm hoping that throwing
> hardware at it will help ... Obviously CPU hardware is the wrong fit
> though.
> 
>>> Currently I'm looking to replace at least the motherboard with
>>> http://www.supermicro.com/products/motherboard/Xeon/C202_C204/X9SCM-F.cfm 
>>> in
>>> order to get 2 of the PCIe 2.0 8x slots (one for the existing LSI SATA
>>> controller and one for a dual port 10Gb ethernet card. This will provide
>>> a 10Gb cross-over connection between the two server, plus replace the 8
>>> x 1G ports with a single 10Gb port (solving the load balancing across
>>> the multiple links issue). Finally, this 28 port (4 x 10G + 24 x 1G)
>>> switch

>> Adam if you have the budget now I absolutely agree that 10 GbE is a much
>> better solution than the multi-GbE setup.

> Well, I've been tasked to fix the problem..... Whatever it takes. I just
> don't know what I should be targetting....

>> But you don't need a new
>> motherboard.  The S1200BTLR has 4 PCIe 2.0 slots: one x8 electrical in
>> x16 physical slot, and three x4 electrical in x8 physical slots.  Your
>> bandwidth per slot is:
>>
>> x8    4 GB/s unidirectional x2  <-  occupied by LSI SAS HBA
>> x4    2 GB/s unidirectional x2  <-  occupied by quad port GbE cards
>>
>> 10 Gbps Ethernet has a 1 GB/s effective data rate one way.  Inserting an
>> x8 PCIe card into an x4 electrical/x8 physical slot gives you 4 active
>> lanes for 2+2 GB/s bandwidth.  This is an exact match for a dual port 10
>> GbE card.  You could install up to three dual port 10 GbE cards into
>> these 3 slots of the S1200BTLR.

> This is somewhat beyond my knowledge, but I'm trying to understand, so
> thank you for the information. From
> http://en.wikipedia.org/wiki/PCI_Express#PCI_Express_2.0 it says:
> 
> "Like 1.x, PCIe 2.0 uses an 8b/10b encoding
> <http://en.wikipedia.org/wiki/8b/10b_encoding> scheme, therefore
> delivering, per-lane, an effective 4 Gbit/s max transfer rate from its 5
> GT/s raw data rate."
>
> So, it suggests that we can get 4Gbit/s * 4 (using the x4 slots) which
> provides a maximum throughput of 16Gbit/s  which wouldn't quite manage
> the full 20Gb/s capable from a dual port 10Gb card. 

Except for the fact that you'll never get close to 10 Gbps with TCP due
to protocol overhead, host latency, etc.  Your goal in switching to 10
GbE should not be achieving 10 Gb/s throughput, as that's not possible
with your workload.  Your goal should be achieving more bandwidth more
of the time than what you can achieve now with 8 GbE interfaces, and
simplifying your topology.

Again, your core problem isn't lack of bandwidth in the storage network.

> One option is to
> only use a single port for the cross connect, but it would probably help
> to be able to use the second port to replace the 8x1Gb ports. (BTW, the
> pci and ethernet bandwidth is apparently full duplex, so that shouldn't
> be a problem AFAIK).
>
> Or, I'm reading something wrong?

Everything is full duplex today, has been for many years.  Yes, you'd
use one port on each 2-port 10 GbE NIC for DRBD traffic and the other to
replace the 8 GbE ports.  Again, this won't solve the current core
problem but it will provide benefits.

>>> http://www.netgear.com.au/business/products/switches/stackable-smart-switches/GS728TXS.aspx#
>>>
>>> should allow the 2 x 10G connections to be connected through to the 8
>>> servers with 2 x 1G connections each using multipath scsi to setup two
>>> connections (one on each 1G port) with the same destination (10G port)
>>>
>>> Any suggestions/comments would be welcome.

>> You'll want use SFP+ NICs and passive Twin-Ax cables to avoid paying the
>> $2000 fiber tax, as that is what four SFP+ 10 Gbit fiber LC transceivers
>> cost--$500 each.  The only SFP+ Intel dual port 10 GbE NIC that ships
>> with vacant SFP+ ports is the X520-DA2:
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16833106044
>>
>> To connect the NICs to the switch and to one another you'll need 3 or 4
>> SFP+ passive Twin-Ax cables of appropriate length.  Three if direct
>> server-to-server works, four if it doesn't, in which case you connect
>> all 4 to the 4 SFP+ switch ports.  You'll need to contact Intel and
>> inquire about the NIC-to-NIC functionality.  I'm not using the word
>> cross-over because I don't believe it applies to Twin-Ax cable.  But you
>> need to confirm their NICs will auto negotiate the send/receive pairs.
>> This isn't twisted pair cable Adam.  It's a different beast entirely.
>> You can't run the length you want, cut the cable and terminate it
>> yourself.  These cables must be pre-made to length and terminated at the
>> factory.  One look at the prices tells you that.  The 1 meter Intel
>> cable costs more than a 500ft spool of Cat 5e.  A 1 meter and a 3 meter
>> Passive Twin-Ax cable, Intel and Netgear:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16812128002
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16812638004

> I understand about the cables, though I was planning on trying to use
> Cat6 cables as I thought that would be an option, together with the
> Intel X540T2
> http://www.newegg.com/Product/Product.aspx?Item=N82E16833106083
> Though that has PCIe 2.1 so maybe it wouldn't work, so was then looking
> at X520T2
> http://www.newegg.com/Product/Product.aspx?Item=N82E16833106075
> Which has PCIe 2.0.

All PCIe devices are forward and backward compatible.  That's not a problem.

> However, if the twin-ax cables will offer lower latency, then I think
> that is a better option. I think DRBD will work a lot better with lower
> latency, as I'm sure iSCSI should also benefit.

Definitely go with Twin-Ax.

> Also it seems that finding the SFP+ modules for the netgear switch to
> provide the Cat6 ports might also be challenging and/or more expensive.
> Given the proximity of the two servers (one rack apart) I think the
> Intel card you mentioned above, plus 4 of the 3m cables (might as well
> order the 4th cable now in case we need it later) would be the best
> solution.

10 GBase-T transceivers have limited availability, which drives up the
cost.  The reason is most folks use Twin-Ax due to its advantages in
rack-to-rack connections.  In addition SFP+ transceivers are not
universal.  Many 10 GbE SFP+ NICs don't support 10GBase-T transceivers
due to the power draw.

And I absolutely agree on the 4th cable--if the server-server cable
doesn't work, why wait another week or two to get DRBD running through
the switch?

>> If the server to switch distance is much over 15ft you will need to
>> inquire with Intel and Netgear about the possibility of using active
>> Twin-Ax cables.  If their products do no support active cables you'll
>> have to go with fiber, and spend the extra $2000 for the 4 transceivers,
>> along with one LC-to-LC multimode fiber cable for the server-to-server
>> link, and two straight through LC-LC multimode fiber cables.

> Hopefully not :) I originally thought fibre might provide a lower
> latency, (I'm sure it does for a long distance cable run), but once I
> read that it increases latency in the conversion (copper <-> fibre) then
> I figured it was better to avoid it. Cat6 seemed to provide a suitable
> solution, but as mentioned, if twin-ax is lower latency then thats a
> better solution.

And it's easier to acquire.

> Finally, can you suggest a reasonable solution on how or what to monitor
> to rule out the various components?

You don't need to.  You already found the problem, a year ago.  I'm
guessing you simply forgot to fix it, or didn't sufficiently fix it.

> I know in the past I've used fio on the server itself, and got excellent
> results (2.5GB/s read + 1.6GB/s write), I know I've done multiple
> parallel fio tests from the linux clients and each gets around 180+MB/s
> read and write, I know I can do fio tests within my windows VM's, and
> still get 200MB/s read/write (one at a time recently). Yet at times I am
> seeing *really* slow disk IO from the windows VM's (and linux VM's),
> where in windows you can wait 30 seconds for the command prompt to
> change to another drive, or 2 minutes for the "My Computer" window to
> show the list of drives. I have all this hardware, and yet performance
> feels really bad, if it's not hardware, then it must be some config
> option that I've seriously stuffed up...

I may have some details incorrect as I'm going strictly from organic
memory here, so please pardon me if I fubar a detail or two.

You had a Windows 2000 Directory Controller VM that hosts all of your
SMB file shares.  You were giving it only one virtual CPU, i.e. one
core, and not enough RAM.  It was peaking the core during any sustained
SMB file copy in either direction while achieving less than 100 MB/s SMB
throughput IIRC.  In addition, your topology limits SMB traffic between
the hypervisor nodes to a single GbE link, 100 MB/s.

The W2K VM simply couldn't handle more than 200 MB/s of combined SMB and
block IO processing.  I did some research at that time and found that
2003/2008 had many enhancements for running in VMs that solved many of
the virtualization performance problems of W2K.  I suggested you
wholesale move SMB file sharing directly to the storage servers running
Samba to fix this once and for all, with a sledgehammer, but you did not
want to part with a Windows VM hosting the SMB shares.  I said your next
best option was to upgrade and give the DC VM 4 virtual CPUs and 2GB of
RAM.  IIRC you said you needed to allocate as much CPU/RAM as possible
to the other VMs on that box and you couldn't spare it.

So, as of the last information I have, you had not fixed this.  Given
the nature of the end user issues you describe, which are pretty much
identical to a year ago, I can only assume you didn't properly upgrade
or replace this Windows DC file server VM and it is still the
bottleneck.  The long delays you mention tend to indicate it is trying
to swap heavily but is experiencing tremendous latency in doing so.  Is
the swap file for this DC VM physically located on the iSCSI server?  If
so the round trip latency is exacerbating the VM's attempts to swap.

Get out your medical examiner's kit and perform an autopsy on this
Windows DC/SMB server VM.  This is where you'll find the problem I
think.  If not it's somewhere in your Windows infrastructure.

Two minutes to display the mapped drive list in Explorer?  That might be
a master browser issue.  Go through all the Windows Event logs for the
Terminal Services VMs with a fine toothed comb.

> Firstly I want to rule out MD, so far I am graphing the read/write
> sectors per second for each physical disk as well as md1, drbd2 and each
> LVM. I am also graphing BackLog and ActiveTime taken from
> /sys/block/DEVICE/stat
> These stats clearly show significantly higher IO during the backups than
> during peak times, so again it suggests that the system should be
> capable of performing really well.

You're troubleshooting what you know because you know how to do it, even
though you know deep down that's not where the problem is.  You're
comfortable with it so that's the path you take.  You're avoiding
troubleshooting Windows, but this is where the heart of this problem is,
so you simply must.

> Thanks again for any advice or suggestions.

I hope I helped steer you toward the right path Adam.  Always keep in
mind that the apparent cause of problems within a virtual machine guest
are not always what they appear to be.

Cheers,

Stan
