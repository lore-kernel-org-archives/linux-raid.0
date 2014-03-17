From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Mon, 17 Mar 2014 16:43:32 -0500
Message-ID: <53276C84.5040805@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53268B87.4060203@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/17/2014 12:43 AM, Adam Goryachev wrote:
> On 13/03/14 22:58, Stan Hoeppner wrote:
>> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
>> ...
>>>      Number   Major   Minor   RaidDevice State
>>>         7       8       33        0      active sync   /dev/sdc1
>>>         6       8        1        1      active sync   /dev/sda1
>>>         8       8       49        2      active sync   /dev/sdd1
>>>         5       8       81        3      active sync   /dev/sdf1
>>>         9       8       65        4      active sync   /dev/sde1
>> ...
>>> /dev/sda    Total_LBAs_Written	845235
>>> /dev/sdc    Total_LBAs_Written	851335
>>> /dev/sdd    Total_LBAs_Written	804564
>>> /dev/sde    Total_LBAs_Written	719767
>>> /dev/sdf    Total_LBAs_Written	719982
>> ...
>>> So the drive with the highest writes 851335 and the drive with the
>>> lowest writes 719982 show a big difference. Perhaps I have a problem
>>> with the setup/config of my array, or similar?
>> This is normal for striped arrays.  If we reorder your write statistics
>> table to reflect array device order, we can clearly see the effect of
>> partial stripe writes.  These are new file allocations, appends, etc
>> that are smaller than stripe width.  Totally normal.  To get these close
>> to equal you'd need a chunk size of 16K or smaller.
> 
> Would that have a material impact on performance?

Not with SSDs.  If this was a rust array you'd probably want an 8KB or
16KB chunk to more evenly spread the small write IOs.

> While current wear stats (Media Wearout Indicator) are all 98 or higher,
> at some point, would it be reasonable to fail the drive with the lowest
> write count, and then use it to replace the drive with the highest write
> count, repeating twice, so that over the next period of time usage
> should merge toward the average? Given the current wear rate, will
> probably replace all the drives in 5 years, which is well before they
> reach 50% wear anyway.

Given the level of production write activity on your array, doing what
you suggest above will simply cause leapfrogging, taking drives with
lesser wear on them and shooting them way out in front of the drives
with the most wear.  In fact, any array operations you perform are
putting far more wear on the flash cells than normal operation is.

>>> So, I could simply do the following:
>>> mdadm --manage /dev/md1 --add /dev/sdb1
>>> mdadm --grow /dev/md1 --raid-devices=6
>>>
>>> Probably also need to remove the bitmap and re-add the bitmap.
>> Might want to do
>>
>> ~$ echo 250000 > /proc/sys/dev/raid/speed_limit_min
>> ~$ echo 500000 > /proc/sys/dev/raid/speed_limit_min
>>
>> That'll bump min resync to 250 MB/s per drive, max 500 MB/s.  IIRC the
>> defaults are 1 MB/s and 100 MB/s.
> 
> Worked perfectly on one machine, the second machine hung, and basically
> crashed. Almost turned into a disaster, but thankfully having two copies
> over the two machines I managed to get everything sorted. After a
> reboot, the second machine recovered and it grew the array also.

See:  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=629442

This is the backup machine, yes?  Last info I had from you said this box
was using rust not SSD.  Is that still the case?  If so you should not
have bumped the reshape speed upward as rust can't handle it, especially
with load other than md on it.  Also, I recall you had to install a
backport kernel on san1 as well as a new iscsi-target package.

What kernel and iscsi-target version is running on each of san1 and
san2.  I'm guessing they're not the same.

What elevator is configured on san1 and san2?  It should be noop for SSD
and deadline for rust.

> Some of the logs from that time:
> Mar 13 23:05:59 san2 kernel: [42511.418380] RAID conf printout:
> Mar 13 23:05:59 san2 kernel: [42511.418385]  --- level:5 rd:6 wd:6
> Mar 13 23:05:59 san2 kernel: [42511.418388]  disk 0, o:1, dev:sdc1
> Mar 13 23:05:59 san2 kernel: [42511.418390]  disk 1, o:1, dev:sde1
> Mar 13 23:05:59 san2 kernel: [42511.418392]  disk 2, o:1, dev:sdd1
> Mar 13 23:05:59 san2 kernel: [42511.418394]  disk 3, o:1, dev:sdf1
> Mar 13 23:05:59 san2 kernel: [42511.418396]  disk 4, o:1, dev:sda1
> Mar 13 23:05:59 san2 kernel: [42511.418399]  disk 5, o:1, dev:sdb1
> Mar 13 23:05:59 san2 kernel: [42511.418444] md: reshape of RAID array md1
> Mar 13 23:05:59 san2 kernel: [42511.418448] md: minimum _guaranteed_ 
> speed: 1000 KB/sec/disk.
> Mar 13 23:05:59 san2 kernel: [42511.418451] md: using maximum available
> idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Mar 13 23:05:59 san2 kernel: [42511.418493] md: using 128k window, over
> a total of 468847936k.
> Mar 13 23:06:00 san2 kernel: [42511.512165] md: md_do_sync() got signal
> ... exiting
> Mar 13 23:07:01 san2 kernel: [42573.067781] iscsi_trgt: Abort Task (01)
> issued on tid:9 lun:0 by sid:8162774362161664 (Function Complete)
> Mar 13 23:07:01 san2 kernel: [42573.067789] iscsi_trgt: Abort Task (01)
> issued on tid:11 lun:0 by sid:7318349599801856 (Function Complete)
> Mar 13 23:07:01 san2 kernel: [42573.067797] iscsi_trgt: Abort Task (01)
> issued on tid:12 lun:0 by sid:6473924787110400 (Function Complete)
> Mar 13 23:07:01 san2 kernel: [42573.067838] iscsi_trgt: Abort Task (01)
> issued on tid:14 lun:0 by sid:5348025014485504 (Function Complete)
> Mar 13 23:07:02 san2 kernel: [42573.237591] iscsi_trgt: Abort Task (01)
> issued on tid:8 lun:0 by sid:4503599899804160 (Function Complete)
> Mar 13 23:07:02 san2 kernel: [42573.237600] iscsi_trgt: Abort Task (01)
> issued on tid:2 lun:0 by sid:14918173819994624 (Function Complete)
...
> I probably hit CTRL-C causing the "got signal... exiting" because the
> system wasn't responding. There are a *lot* more iscsi errors and then
> these:
> Mar 13 23:09:09 san2 kernel: [42700.645060] INFO: task md1_raid5:314
> blocked for more than 120 seconds.

The md write thread blocked for more than 2 minutes.  Often these
timeouts are due to multiple processes fighting for IO.  This leads me
to believe san2 has rust based disk, and that the kernel and other
tweaks applied to san1 were not applied to san2.

...
> This did lead to another observation.... The speed of the resync seemed
> limited by something other than disk IO. 

On both san1/san2 or just san1?  I'm assuming for now you mean san1 only.

> It was usually around 250 to
> 300MB/s, the maximum achieved was around 420MB/s. I also noticed that
> idle CPU time on one of the cores was relatively low, though I never saw
> it hit 0 (minimum I saw was 12% idle, average around 20%).

Never look at idle, but what's eating the CPU.  Was that 80+% being
eaten by sys, wa, or a process?  Without that information it's not
possible to definitely answer your questions below.

Do note, recall that during fio testing you were hitting 1.6 GB/s write
throughput, ~4x greater than the resync throughput stated above.  If one
of your cores was at greater than 80% utilization with only ~420 MB/s of
resync throughput, then something other than the md write thread was
hammering that core.

> So, I'm wondering whether I should consider upgrading the CPU and/or
> motherboard to try and improve peak performance?

As I mentioned after walking you through all of the fio testing, you
have far more hardware than your workload needs.

> Currently I have Intel Xeon E3-1230V2/3.3GHz/8MB
> Cache/4core/8thread/5GTs, my supplier has offered a number of options:
> 1) Compatible with current motherboard
>      Intel Xeon E3-1280V2/3.6GHz/8MB Cache/4core/8thread/5GTs

This may gain you 5% peak RAID5 throughput.

> 2)  Intel Xeon E5-2620V2/2.1GHz/15MB Cache/6core/12thread/5GTs
> 3)  Intel Xeon E5-2630V2/2.6GHz/15MB Cache/6core/12thread/7.2GTs

Both of these will decrease your peak RAID5 throughput quite markedly.
md raid5 is clock sensitive, not cache sensitive.

> My understanding is that the RAID5 is single threaded, so will work best
> with a higher speed single core CPU compared to a larger number of cores
> at a lower speed. However, I'm not sure how much "work" is being done
> across the various models. ie, does a E5 CPU do more work even though it
> has a lower clock speed? Does this carry over to the E7 class as well?

You're chasing a red herring.  Any performance issue you currently have,
and I've seen no evidence of such to this point, is not due to the model
of CPU in the box.  It's due to tuning, administration, etc.

> Currently I'm looking to replace at least the motherboard with
> http://www.supermicro.com/products/motherboard/Xeon/C202_C204/X9SCM-F.cfm in
> order to get 2 of the PCIe 2.0 8x slots (one for the existing LSI SATA
> controller and one for a dual port 10Gb ethernet card. This will provide
> a 10Gb cross-over connection between the two server, plus replace the 8
> x 1G ports with a single 10Gb port (solving the load balancing across
> the multiple links issue). Finally, this 28 port (4 x 10G + 24 x 1G)
> switch

Adam if you have the budget now I absolutely agree that 10 GbE is a much
better solution than the multi-GbE setup.  But you don't need a new
motherboard.  The S1200BTLR has 4 PCIe 2.0 slots: one x8 electrical in
x16 physical slot, and three x4 electrical in x8 physical slots.  Your
bandwidth per slot is:

x8	4 GB/s unidirectional x2  <-  occupied by LSI SAS HBA
x4	2 GB/s unidirectional x2  <-  occupied by quad port GbE cards

10 Gbps Ethernet has a 1 GB/s effective data rate one way.  Inserting an
x8 PCIe card into an x4 electrical/x8 physical slot gives you 4 active
lanes for 2+2 GB/s bandwidth.  This is an exact match for a dual port 10
GbE card.  You could install up to three dual port 10 GbE cards into
these 3 slots of the S1200BTLR.

> http://www.netgear.com.au/business/products/switches/stackable-smart-switches/GS728TXS.aspx#
> should allow the 2 x 10G connections to be connected through to the 8
> servers with 2 x 1G connections each using multipath scsi to setup two
> connections (one on each 1G port) with the same destination (10G port)
>
> Any suggestions/comments would be welcome.

You'll want use SFP+ NICs and passive Twin-Ax cables to avoid paying the
$2000 fiber tax, as that is what four SFP+ 10 Gbit fiber LC transceivers
cost--$500 each.  The only SFP+ Intel dual port 10 GbE NIC that ships
with vacant SFP+ ports is the X520-DA2:
http://www.newegg.com/Product/Product.aspx?Item=N82E16833106044

To connect the NICs to the switch and to one another you'll need 3 or 4
SFP+ passive Twin-Ax cables of appropriate length.  Three if direct
server-to-server works, four if it doesn't, in which case you connect
all 4 to the 4 SFP+ switch ports.  You'll need to contact Intel and
inquire about the NIC-to-NIC functionality.  I'm not using the word
cross-over because I don't believe it applies to Twin-Ax cable.  But you
need to confirm their NICs will auto negotiate the send/receive pairs.
This isn't twisted pair cable Adam.  It's a different beast entirely.
You can't run the length you want, cut the cable and terminate it
yourself.  These cables must be pre-made to length and terminated at the
factory.  One look at the prices tells you that.  The 1 meter Intel
cable costs more than a 500ft spool of Cat 5e.  A 1 meter and a 3 meter
Passive Twin-Ax cable, Intel and Netgear:

http://www.newegg.com/Product/Product.aspx?Item=N82E16812128002
http://www.newegg.com/Product/Product.aspx?Item=N82E16812638004

If the server to switch distance is much over 15ft you will need to
inquire with Intel and Netgear about the possibility of using active
Twin-Ax cables.  If their products do no support active cables you'll
have to go with fiber, and spend the extra $2000 for the 4 transceivers,
along with one LC-to-LC multimode fiber cable for the server-to-server
link, and two straight through LC-LC multimode fiber cables.

-- 
Stan
