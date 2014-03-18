From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing RAID5 SSD Array
Date: Wed, 19 Mar 2014 10:25:32 +1100
Message-ID: <5328D5EC.7090303@websitemanagers.com.au>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53282C6C.4090502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/03/14 22:22, Stan Hoeppner wrote:
> On 3/17/2014 8:41 PM, Adam Goryachev wrote:
>> On 18/03/14 08:43, Stan Hoeppner wrote:
>>> On 3/17/2014 12:43 AM, Adam Goryachev wrote:
>>>> On 13/03/14 22:58, Stan Hoeppner wrote:
>>>>> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
>>>>>
>>>>>
>>>>>
> But again you should have had no iSCSI sessions active, and if you 
> didn't shutdown DRBD during a reshape then you're asking for it 
> anyway. Recall in my initial response I recommended you shutdown DRBD 
> before doing the reshapes? 

Yes, and I did ignore that very good, sane advice. However, it should 
have worked... So a kernel bug somewhere happened to bite me, hopefully 
it has been fixed in a newer kernel already, and I will definitely learn 
from the experience and shutdown all iscsi clients prior to the next 
upgrade. However, I don't think I can stop drbd when I grow the array, 
because drbd uses information at the "end" of the block device, and if 
the array has grown, then it won't find the right information. I need to 
grow the MD device, and then grow drbd while it is on-line to work 
smoothly. Though if I shutdown iscsi, then stop lvm, then nothing will 
even have the drbd device open, so it should be totally idle.
>>>> It was usually around 250 to
>>>> 300MB/s, the maximum achieved was around 420MB/s. I also noticed that
>>>> idle CPU time on one of the cores was relatively low, though I never saw
>>>> it hit 0 (minimum I saw was 12% idle, average around 20%).
>>> Never look at idle, but what's eating the CPU.  Was that 80+% being
>>> eaten by sys, wa, or a process?  Without that information it's not
>>> possible to definitely answer your questions below.
>> Unfortunately I should have logged the info but didn't. I am pretty sure
>> md1_resync was at the top of the task list...
> A reshape reads and writes all drives concurrently.  You're likely not
> going to get even one drive worth of write throughput.  Your FIO testing
> under my direction showed 1.6GB/s div 4 = 400MB/s peak per drive write
> throughput with a highly parallel workload, i.e. queue depth >4.  I'd
> say these reshape numbers are pretty good.  If it peaked at 420MB/s and
> average 250-300 then other processes were accessing the drives.  If DRBD
> was active that would probably explain it.  This isn't something to
> spend any time worrying about because it's not relevant to your
> production issues.

OK, good :) Less to worry about is a good thing.
>>>> Currently I'm looking to replace at least the motherboard with
>>>> http://www.supermicro.com/products/motherboard/Xeon/C202_C204/X9SCM-F.cfm
>>>> in
>>>> order to get 2 of the PCIe 2.0 8x slots (one for the existing LSI SATA
>>>> controller and one for a dual port 10Gb ethernet card. This will provide
>>>> a 10Gb cross-over connection between the two server, plus replace the 8
>>>> x 1G ports with a single 10Gb port (solving the load balancing across
>>>> the multiple links issue). Finally, this 28 port (4 x 10G + 24 x 1G)
>>>> switch
>>> Adam if you have the budget now I absolutely agree that 10 GbE is a much
>>> better solution than the multi-GbE setup.
>> Well, I've been tasked to fix the problem..... Whatever it takes. I just
>> don't know what I should be targetting....
>>> But you don't need a new
>>> motherboard.  The S1200BTLR has 4 PCIe 2.0 slots: one x8 electrical in
>>> x16 physical slot, and three x4 electrical in x8 physical slots.  Your
>>> bandwidth per slot is:
>>>
>>> x8    4 GB/s unidirectional x2  <-  occupied by LSI SAS HBA
>>> x4    2 GB/s unidirectional x2  <-  occupied by quad port GbE cards
>>>
>>> 10 Gbps Ethernet has a 1 GB/s effective data rate one way.  Inserting an
>>> x8 PCIe card into an x4 electrical/x8 physical slot gives you 4 active
>>> lanes for 2+2 GB/s bandwidth.  This is an exact match for a dual port 10
>>> GbE card.  You could install up to three dual port 10 GbE cards into
>>> these 3 slots of the S1200BTLR.
>> This is somewhat beyond my knowledge, but I'm trying to understand, so
>> thank you for the information. From
>> http://en.wikipedia.org/wiki/PCI_Express#PCI_Express_2.0 it says:
>>
>> "Like 1.x, PCIe 2.0 uses an 8b/10b encoding
>> <http://en.wikipedia.org/wiki/8b/10b_encoding> scheme, therefore
>> delivering, per-lane, an effective 4 Gbit/s max transfer rate from its 5
>> GT/s raw data rate."
>>
>> So, it suggests that we can get 4Gbit/s * 4 (using the x4 slots) which
>> provides a maximum throughput of 16Gbit/s  which wouldn't quite manage
>> the full 20Gb/s capable from a dual port 10Gb card.
> Except for the fact that you'll never get close to 10 Gbps with TCP due
> to protocol overhead, host latency, etc.  Your goal in switching to 10
> GbE should not be achieving 10 Gb/s throughput, as that's not possible
> with your workload.  Your goal should be achieving more bandwidth more
> of the time than what you can achieve now with 8 GbE interfaces, and
> simplifying your topology.
>
> Again, your core problem isn't lack of bandwidth in the storage network.
I'm still somewhat concerned that this might cause problems, given a new 
motherboard is around $350, I'd prefer to replace it if that is going to 
help at all. Even if I solve the "other" problem, I'd prefer the users 
to *really* notice the difference, rather than just "normal". ie, I want 
the end result to be excellent rather than good, considering all the 
time, money and effort... For now, I've just ordered the 2 x Intel cards 
plus 1 of the cables (only one in stock right now, the other three are 
on back order) plus the switch. I should have all that by tomorrow, and 
if all goes well and I can use the single cable as a direct connect 
between the two machines, then that's great, if not I will have to wait 
for more cables.

>> One option is to
>> only use a single port for the cross connect, but it would probably help
>> to be able to use the second port to replace the 8x1Gb ports. (BTW, the
>> pci and ethernet bandwidth is apparently full duplex, so that shouldn't
>> be a problem AFAIK).
>>
>> Or, I'm reading something wrong?
> Everything is full duplex today, has been for many years.  Yes, you'd
> use one port on each 2-port 10 GbE NIC for DRBD traffic and the other to
> replace the 8 GbE ports.  Again, this won't solve the current core
> problem but it will provide benefits.
>
>>>> http://www.netgear.com.au/business/products/switches/stackable-smart-switches/GS728TXS.aspx#
>>>>
>>>> should allow the 2 x 10G connections to be connected through to the 8
>>>> servers with 2 x 1G connections each using multipath scsi to setup two
>>>> connections (one on each 1G port) with the same destination (10G port)
>>>>
>>>> Any suggestions/comments would be welcome.
>> Finally, can you suggest a reasonable solution on how or what to monitor
>> to rule out the various components?
> You don't need to.  You already found the problem, a year ago.  I'm
> guessing you simply forgot to fix it, or didn't sufficiently fix it.
>
>> I know in the past I've used fio on the server itself, and got excellent
>> results (2.5GB/s read + 1.6GB/s write), I know I've done multiple
>> parallel fio tests from the linux clients and each gets around 180+MB/s
>> read and write, I know I can do fio tests within my windows VM's, and
>> still get 200MB/s read/write (one at a time recently). Yet at times I am
>> seeing *really* slow disk IO from the windows VM's (and linux VM's),
>> where in windows you can wait 30 seconds for the command prompt to
>> change to another drive, or 2 minutes for the "My Computer" window to
>> show the list of drives. I have all this hardware, and yet performance
>> feels really bad, if it's not hardware, then it must be some config
>> option that I've seriously stuffed up...
> I may have some details incorrect as I'm going strictly from organic
> memory here, so please pardon me if I fubar a detail or two.
>
> You had a Windows 2000 Directory Controller VM that hosts all of your
> SMB file shares.  You were giving it only one virtual CPU, i.e. one
> core, and not enough RAM.  It was peaking the core during any sustained
> SMB file copy in either direction while achieving less than 100 MB/s SMB
> throughput IIRC.  In addition, your topology limits SMB traffic between
> the hypervisor nodes to a single GbE link, 100 MB/s.
I only ran win2000 for a very minimal time, I think less than one day, 
which was part of the process of migrating from the old winNT 4.0 
physical machine to the VM. It has been running win2003 for over a year 
now.
I know in the initial period I did have an issue where I couldn't 
upgrade to multiple CPU's, but it seems I did eventually manage to solve 
that, because it is now running with 4 vCPU's and has been for a long 
time. I think I also had issues with running win2003sp1, but an upgrade 
to sp2 resolved that issue, something to do with the way the CPU was 
being used the the virtualisation layer.

Generally, it has always been the only VM running on the physical 
machine (to ensure network/cpu/etc priority), and has 4 vCPU's mapped to 
4 physical CPU's which are not shared with anything. The dom0 has two 
dedicated CPU's as well. All the win2003 machines are allocated 4GB RAM 
(maximum for win2003 32bit).
The windows VM is limited to 1Gbps for SMB traffic, in fact the entire 
"user" LAN is 1Gbps, at least for all the VM's.

> The W2K VM simply couldn't handle more than 200 MB/s of combined SMB and
> block IO processing.  I did some research at that time and found that
> 2003/2008 had many enhancements for running in VMs that solved many of
> the virtualization performance problems of W2K.  I suggested you
> wholesale move SMB file sharing directly to the storage servers running
> Samba to fix this once and for all, with a sledgehammer, but you did not
> want to part with a Windows VM hosting the SMB shares.  I said your next
> best option was to upgrade and give the DC VM 4 virtual CPUs and 2GB of
> RAM.  IIRC you said you needed to allocate as much CPU/RAM as possible
> to the other VMs on that box and you couldn't spare it.

Yes, I was (still am) very scared to replace the DC with a Linux box. 
Moving the SMB shares would have resulted in changing the "location" of 
all the files, and means finding and fixing every config file or spot 
which relies on that. Though I have thought about this a number of 
times. Currently, the plan is to migrate the authentication, DHCP, DNS, 
etc to a new win2008R2 machine this weekend. Once that is done, next 
weekend I will try and migrate the shares to a new win2012R2 machine. 
The goal being to resolve any issues caused by upgrading the old win NT 
era machine over and over and over again, by using brand new 
installations of more modern versions. When the time comes, I may 
consider migrating the file sharing to a linux VM, I've very slightly 
played with samba4, but I'm not particularly confident about it yet (it 
isn't included in Debian stable yet).

> So, as of the last information I have, you had not fixed this.  Given
> the nature of the end user issues you describe, which are pretty much
> identical to a year ago, I can only assume you didn't properly upgrade
> or replace this Windows DC file server VM and it is still the
> bottleneck.  The long delays you mention tend to indicate it is trying
> to swap heavily but is experiencing tremendous latency in doing so.  Is
> the swap file for this DC VM physically located on the iSCSI server?  If
> so the round trip latency is exacerbating the VM's attempts to swap.

The VM isn't swapping at all. At one stage I allocated an additional 4GB 
ram drive for each VM (DC plus terminal servers), which simply looked 
like a normal 4GB hard drive to windows. Then moved the pagefile to this 
drive. It didn't make any difference to the performance issues, and in 
the end I removed it because it meant I couldn't live migrate VM's to 
different physical boxes, etc. In any case, swap is not in use for the 
DC at all, right now (9:15am) there is 17% physical memory in use, and 
CPU load is under 1%. The next time things are running slowly I'll take 
another look at these numbers, but I don't suspect the issue is memory 
or cpu on this box.

> Get out your medical examiner's kit and perform an autopsy on this
> Windows DC/SMB server VM.  This is where you'll find the problem I
> think.  If not it's somewhere in your Windows infrastructure.
>
> Two minutes to display the mapped drive list in Explorer?  That might be
> a master browser issue.  Go through all the Windows Event logs for the
> Terminal Services VMs with a fine toothed comb.
The performance issue impacts on unrelated linux VM's as well. I 
recently setup a new Linux VM to run a new application. When the issue 
is happening, if I login to this VM, disk IO is severely slow, like 
running ls will take a long time etc...

I see the following event logs on the DC:
NTDS (764)NTDSA: A request to write to the file "C:\WINNT\NTDS\edb.chk" 
at offset 0 (0x0000000000000000) for 4096 (0x00001000) bytes succeeded 
but took an abnormally long time (72 seconds) to be serviced by the OS. 
This problem is likely due to faulty hardware. Please contact your 
hardware vendor for further assistance diagnosing the problem.

That type of event hasn't happened often:
20140314 11:15:35   72 seconds
20131124 17:55:48   55 minutes 12 seconds
20130422 20:45:23   367 seconds
20130410 23:57:16   901 seconds

Though these look like they may have happened at times when DRBD crashed 
or similar, since I've definitely had a lot more times of very slow 
performance....

Also looking on the terminal servers has produced a similar lack of 
events, except some auth errors when the DC has crashed recently.

The newest terminal servers (running Win 2012R2) show this event for 
every logon:
Remote Desktop services has taken too long to load the user 
configuration from server \\DC for user xyz

Although the logins actually do work, and seems mostly normal after 
login, except for times when it runs really slow again.

Finally, on the old terminal servers, the PST file for outlook contained 
*all* of the email and was stored on the SMB server, on the new terminal 
servers, the PST file on the SMB server only contains contacts and 
calendars (ie, very small) and the email is stored in the "local" 
profile on the C: (which is iSCSI still). I'm hopeful that this will 
reduce the file sharing load on the domain controller. (If the C: pst 
file is lost, then it is automatically re-created and all the email is 
re-downloaded from the IMAP server, so nothing is lost, but it 
drastically increases the SAN load to re-download 2GB of email for each 
user, which had a massive impact on performance on Friday last week!).
>> Firstly I want to rule out MD, so far I am graphing the read/write
>> sectors per second for each physical disk as well as md1, drbd2 and each
>> LVM. I am also graphing BackLog and ActiveTime taken from
>> /sys/block/DEVICE/stat
>> These stats clearly show significantly higher IO during the backups than
>> during peak times, so again it suggests that the system should be
>> capable of performing really well.
> You're troubleshooting what you know because you know how to do it, even
> though you know deep down that's not where the problem is.  You're
> comfortable with it so that's the path you take.  You're avoiding
> troubleshooting Windows, but this is where the heart of this problem is,
> so you simply must.
>
>> Thanks again for any advice or suggestions.
> I hope I helped steer you toward the right path Adam.  Always keep in
> mind that the apparent cause of problems within a virtual machine guest
> are not always what they appear to be.
I'm really not sure, I still don't like the domain controller and file 
server being on the same box, and the fact it has been upgraded so many 
times, but I'm doubtful that it is the real cause.

On Thursday night after the failed RAID5 grow, I decided not to increase 
the allocated space for the two new terminal servers (in case I caused 
more problems), and simply deleted a number of user profiles on each 
system. (I assumed the roaming profile would simply copy back when the 
user logged in the next day). However, the roaming profile didn't copy, 
and windows logged users in with a temp profile, so eventually the only 
fix was to restore the profile from the backup server. Once I did this, 
the user could login normally, except the backup doesn't save the pst 
file, so outlook was forced to re-download all of the users email from 
IMAP. This then caused the really, really, really bad performance across 
the SAN, yet it didn't generate any traffic on the SMB shares from the 
domain controller. In addition, as I mentioned, disk IO on the newest 
Linux VM was also badly delayed. Also, copying from a smb share on a 
different windows 2008 VM (basically idle and unused) showed equally bad 
performance copying to my desktop (linux), etc.

So, essentially the current plans are:
Install the Intel 10Gb network cards
Replace the existing 1Gbps crossover connection with one 10Gbps connection
Replace the existing 8 x 1Gbps connections with 1 x 10Gbps connection
Migrate the win2003sp2 authentication etc to a new win2008R2 server
Migrate the win2003sp2 SMB to a new win2012R2 server

I'd still like to clarify whether there is any benefit to replacing the 
motherboard, if needed, I would prefer to do that now rather than later. 
Mainly I wanted to confirm that the rest of the interfaces on the 
motherboard were not interconnected "worse" than the current one. I 
think from the manual the 2 x PCIe x8 and one PCIe x4 and memory were 
directly connected to the CPU, while everything else including onboard 
sata, onboard ethernet, etc are all connected via another chip.

Thanks again for all your advice, much appreciated.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
