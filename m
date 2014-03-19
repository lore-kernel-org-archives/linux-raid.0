From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Wed, 19 Mar 2014 15:45:52 -0500
Message-ID: <532A0200.3070000@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5328D5EC.7090303@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/18/2014 6:25 PM, Adam Goryachev wrote:
> On 18/03/14 22:22, Stan Hoeppner wrote:
>> On 3/17/2014 8:41 PM, Adam Goryachev wrote:
>>> On 18/03/14 08:43, Stan Hoeppner wrote:
>>>> On 3/17/2014 12:43 AM, Adam Goryachev wrote:
>>>>> On 13/03/14 22:58, Stan Hoeppner wrote:
>>>>>> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
...
> I'm still somewhat concerned that this might cause problems, given a new
> motherboard is around $350, I'd prefer to replace it if that is going to
> help at all. Even if I solve the "other" problem, I'd prefer the users
> to *really* notice the difference, rather than just "normal". ie, I want
> the end result to be excellent rather than good, considering all the
> time, money and effort... 

Replacing the motherboards, CPUs, memory, etc in the storage servers
isn't going to increase your user performance.

None of your problems are due to faulty hardware, or lack of hardware
horsepower in your SAN machines nor network hardware.  You have far more
than sufficient bandwidth, both network and SSD array.  The problems you
are experiencing are due to configuration issues and/or faults.

> For now, I've just ordered the 2 x Intel cards
> plus 1 of the cables (only one in stock right now, the other three are
> on back order) plus the switch. I should have all that by tomorrow, and
> if all goes well and I can use the single cable as a direct connect
> between the two machines, then that's great, if not I will have to wait
> for more cables.

Never install new hardware until after you have the root problem(s)
identified and fixed.  Replacing hardware may cause more additional
problems and won't solve any.

...
> Yes, I was (still am) very scared to replace the DC with a Linux box.
> Moving the SMB shares would have resulted in changing the "location" of
> all the files, and means finding and fixing every config file or spot
> which relies on that. Though I have thought about this a number of
> times. Currently, the plan is to migrate the authentication, DHCP, DNS,
> etc to a new win2008R2 machine this weekend. 

So your DHCP and DNS servers are on the DC VM.

> Once that is done, next
> weekend I will try and migrate the shares to a new win2012R2 machine.
> The goal being to resolve any issues caused by upgrading the old win NT
> era machine over and over and over again, by using brand new
> installations of more modern versions. When the time comes, I may
> consider migrating the file sharing to a linux VM, I've very slightly
> played with samba4, but I'm not particularly confident about it yet (it
> isn't included in Debian stable yet).

The problem isn't what is serving the shares.  The problem is the
reliability of the system serving up the shares.

...
>> Get out your medical examiner's kit and perform an autopsy on this
>> Windows DC/SMB server VM.  This is where you'll find the problem I
>> think.  If not it's somewhere in your Windows infrastructure.
>>
>> Two minutes to display the mapped drive list in Explorer?  That might be
>> a master browser issue.  Go through all the Windows Event logs for the
>> Terminal Services VMs with a fine toothed comb.
>
> The performance issue impacts on unrelated linux VM's as well. I
> recently setup a new Linux VM to run a new application. When the issue
> is happening, if I login to this VM, disk IO is severely slow, like
> running ls will take a long time etc...

Slow, or delayed?  I'm guessing delayed.  Do Linux VM guests get DNS
resolution from the Windows DNS server running on the DC?  Do any get
their IP assignment from the DHCP server running on the DC VM?

Do your Linux hypervisors resolve the IPs of the SAN1 interfaces via
DNS?  Or do you use /etc/hosts?  Or do you have these statically
configured in the iSCSI initiator?

> I see the following event logs on the DC:
> NTDS (764)NTDSA: A request to write to the file "C:\WINNT\NTDS\edb.chk"
> at offset 0 (0x0000000000000000) for 4096 (0x00001000) bytes succeeded
> but took an abnormally long time (72 seconds) to be serviced by the OS.
> This problem is likely due to faulty hardware. Please contact your
> hardware vendor for further assistance diagnosing the problem.

Microsoft engineers always assume drive C: is a local disk.  This is why
the error msg says "faulty hardware".  But in your case, drive C: is
actually a SAN LUN mapped through to Windows by the hypervisor, correct?
 To incur a 72 second delay attempting to write to drive C: indicates
that the underlying hypervisor is experiencing significant delay in
resolving the IP of the SAN1 network interface containing the LUN, or IP
packets are being dropped, or the switch is malfunctioning.

"C:\WINNT\NTDS\edb.chk" is the Active Directory database checkpoint
file.  I.e. it is a journal.  AD updates are written to the journal,
then written to the database file "NTDT.DIT", and when that operation is
successful the transaction is removed from the checkpoint file (journal)
edb.chk.  Such a file will likely be read/write locked when written due
to its critical nature.  NTDT.DIT will also likely be read/write locked
when being written.  Look for errors in your logs related to NTDT.DIT
and Active Directory in general.

> That type of event hasn't happened often:
> 20140314 11:15:35   72 seconds
> 20131124 17:55:48   55 minutes 12 seconds
> 20130422 20:45:23   367 seconds
> 20130410 23:57:16   901 seconds

Large delays/timeouts like this are nearly always resolution related,
DNS, NIS, etc.  I'm surprised that Windows would wait 55 minutes to
write to a local AD file, without timing out and producing a hard error.

> Though these look like they may have happened at times when DRBD crashed
> or similar, since I've definitely had a lot more times of very slow
> performance....

I serious doubt this is part of the delay problem since none of your
hosts map anything on SAN2, according to what you told me a year ago
told me anyway.

However, why is DRBD crashing?  And what do you mean by "crashed"?  You
mean the daemon crashed?  On which host?  Or both?

"may have happened at times when"...

Did you cross reference the logs on the Windows DC with the Linux logs?
 That should give you a definitive answer.

> Also looking on the terminal servers has produced a similar lack of
> events, except some auth errors when the DC has crashed recently.

This DC is likely the entirety of your problems.  This is what I was
referring to above about reliability.  Why is the DC VM crashing?  How
often does it crash?  Is it just the VM crashing, or the physical box?
That DC provides the entire infrastructure for your Windows Terminal
Servers and any Windows PC on the network and, from the symptoms and log
information you're provided, it seems pretty clear you're experiencing
delays of some kind when the hypervisors access the SAN LUNs.  Surely
you're not using DNS resolution for the IPs on SAN1, are you?

An unreliable AD/DNS server could explain the vast majority of the
problems you're experiencing.

> The newest terminal servers (running Win 2012R2) show this event for
> every logon:
> Remote Desktop services has taken too long to load the user
> configuration from server \\DC for user xyz

Slow AD/DNs.

> Although the logins actually do work, and seems mostly normal after
> login, except for times when it runs really slow again.

Same problem, slow AD/DNS.

> Finally, on the old terminal servers, the PST file for outlook contained
> *all* of the email and was stored on the SMB server, on the new terminal
> servers, the PST file on the SMB server only contains contacts and
> calendars (ie, very small) and the email is stored in the "local"
> profile on the C: (which is iSCSI still). I'm hopeful that this will
> reduce the file sharing load on the domain controller. (If the C: pst
> file is lost, then it is automatically re-created and all the email is
> re-downloaded from the IMAP server, so nothing is lost, but it
> drastically increases the SAN load to re-download 2GB of email for each
> user, which had a massive impact on performance on Friday last week!).

You have an IMAP server which is already storing all the mail.  The
entire point of IMAP is keeping all the mail on the IMAP server.  Each
message is transferred to a client only when the user opens it, thus
network load is nonexistent.

Why, again, are you not having Outlook use IMAP as intended?  For the
life of me I can't imagine why you don't...

...
> I'm really not sure, I still don't like the domain controller and file
> server being on the same box, and the fact it has been upgraded so many
> times, but I'm doubtful that it is the real cause.

Being on the same physical box is fine.  You just need to get it
reliable.  And I would never put a DNS server inside a VM if any bare
metal outside the VM environment needs that DNS resolution.  DNS is
infrastructure.  VMs are NOT infrastructure, but reside on top of it.

For less than the $375 cost of that mainboard you mentioned you can
build/buy a box for AD duty, install Windows and configure from scratch.
 It only needs the one inbuilt NIC port for the user LAN because it
won't host the shares/files.

You'll export the shares key from the registry of the current SMB
server.  After you have the new bare metal AD/DNS server up, you'll shut
the current one down and never fire it up again because you'll get a
name collision with the new VM you are going to build...

You build a fresh SMB server VM for file serving and give it the host
name of the now shut down DC SMB server.  Moving the shares/files to the
this new server is as simple as mounting/mapping the file share SAN LUN
to the new VM, into the same Windows local device path as on the old SMB
server (e.g. D:\).  After that you restore the shares registry key onto
the new SMB server VM.

This allows all systems that currently map those shares by hostname and
share path to continue to do so.  Basic instructions for migrating
shares in this manner can be found here:

http://support.microsoft.com/kb/125996

> On Thursday night after the failed RAID5 grow, I decided not to increase
> the allocated space for the two new terminal servers (in case I caused
> more problems), and simply deleted a number of user profiles on each
> system. (I assumed the roaming profile would simply copy back when the
> user logged in the next day). However, the roaming profile didn't copy,
> and windows logged users in with a temp profile, so eventually the only
> fix was to restore the profile from the backup server. Once I did this,
> the user could login normally, except the backup doesn't save the pst
> file, so outlook was forced to re-download all of the users email from
> IMAP. 

...
> This then caused the really, really, really bad performance across
> the SAN, 

Can you quantify this?  What was the duration of this really, really,
really bad performance?  And how do you know the bad performance existed
on the SAN links and not just the shared LAN segment?  You don't have
your network links, or systems, instrumented, so how do you know?

Given that you've had continuous problems with this particular mini
datacenter, and the fact that you don't document problems in order to
track them, you need to instrument everything you can.  Then when
problems arise you can look at the data and have a pretty good idea of
where the problems are.  Munin is pretty decent for collecting most
Linux metrics, bare metal and guest, and it's free:

http://munin-monitoring.org/

It may help identify problem periods based on array throughput, NIC
throughput, errors, etc.

> yet it didn't generate any traffic on the SMB shares from the
> domain controller. In addition, as I mentioned, disk IO on the newest
> Linux VM was also badly delayed. 

Now you say "delayed", not "bad performance".  Do all of your VMs
acquire DHCP and DNS from the DC VM?  If so, again, there's your problem.

Linux does not cache DNS information.  It queries the remote DNS server
every time it needs a name to address mapping.

> Also, copying from a smb share on a
> different windows 2008 VM (basically idle and unused) showed equally bad
> performance copying to my desktop (linux), etc.

Now you say "bad performance" again.  So you have a combination of DNS
problems, "delay", and throughput issues, "bad performance".  Again, can
you quantify this "bad performance"?

I'm trying my best to help you identify and fix your problems, but your
descriptions lack detail.

> So, essentially the current plans are:
> Install the Intel 10Gb network cards
> Replace the existing 1Gbps crossover connection with one 10Gbps connection
> Replace the existing 8 x 1Gbps connections with 1 x 10Gbps connection

You can't fix these problems by throwing bigger hardware at them.
Switching to 10 GbE links might fix your current "bad performance" by
eliminating the ALB bonds, or by eliminating ports that are currently
problematic but unknown, see link speed/duplex below.  However, as I
recommended when you acquired the quad port NICs, you shouldn't have
used bonds in the first place.  Linux bonding relies heavily on ARP
negotiation and the assumption that the switch properly updates its MAC
routing tables and in a timely manner.  It also relies on the bond
interfaces having a higher routing priority than all the slaves, or that
the slaves have no route configured.  You probably never checked nor
ensured this when you setup your bonding.

It's possible that due to bonding issues that all of your SAN1 outbound
iSCSI packets are going out only two of the 8 ports, and it's possible
that all the inbound traffic is hitting a single port.  It's also
possible that the master link in either bond may have dropped link
intermittently, dropped link speed to 100 or 10, or is bouncing up and
down due to a cable or switch issue, or may have switched from full to
half duplex.  Without some kind of monitoring such as Munin setup you
simply won't know this without manually looking at the link and TX/RX
statistic for every port with ifconfig and ethtool, which, at this point
is a good idea.  But, if any links are flapping up and down at irregular
intervals, note they may all show 1000 FDX when you check manually with
ethtool, even though they're dropping link on occasion.

You need to have some monitoring setup, alerting is even better.  If an
interface in those two bonds drops link you should currently be
receiving an email or a page.  Same goes for the DRBD link.

Last I recall you had setup two ALB bonds of 4 ports each, with the
multipath mappings of LUNS atop the bonds--against my recommendation of
using straight multipath without bonding.  That would have probably
avoided some of your problems.

Anyway, switching to 10 GbE should solve all of this as you'll have a
single interface for iSCSI traffic at the server, no bond problems to
deal with, and 200 MB/s more peak potential bandwidth to boot, even
though you'll never use half of it, and then only in short bursts.

> Migrate the win2003sp2 authentication etc to a new win2008R2 server
> Migrate the win2003sp2 SMB to a new win2012R2 server

DNS is nearly always the cause of network delays.  To avoid it, always
hard code hostnames and IPs into the host files of all your operating
systems because your server IPs never change.  This prevents problems in
your DNS server from propagating across everything and causing delays
everywhere.  With only 8 physical boxen and a dozen VMs, it simply
doesn't make sense to use DNS for resolving the IPs of these
infrastructure servers, given the massive problems it causes, and how
easy it is to manually configure hosts entries.

> I'd still like to clarify whether there is any benefit to replacing the
> motherboard, if needed, I would prefer to do that now rather than later.

The Xeon E3-1230V2 CPU has an embedded PCI Express 3.0 controller with
16 lanes.  The bandwidth is 32 GB/s.  This is greater than the 21/25
GB/s memory bandwidth of the CPU, so the interface is downgraded to PCIe
2.0 at 16 GB/s.  In the S1200BTLR motherboard this is split into one x8
slot and two x4 slots.  The third x4 slot is connected to the C204
Southbridge chip.

With this motherboard, CPU, 16GB RAM, 8 of those Intel SSDs in a nested
stripe 2x md/RAID5 on the LSI, and two dual port 10G NICs, the system
could be easily tuned to achieve ~3.5/2.5 GB/s TCP read/write
throughput.  Which is 10x (350/250 MB/s) the peak load your 6 Xen
servers will ever put on it.  The board has headroom to do 4-5 times
more than you're asking of it, if you insert/attach the right combo of
hardware, and tweak the bejesus out of your kernel and apps.

The maximum disk-to-network and reverse throughput one can typically
achieve on a platform with sufficient IO bandwidth, and an optimally
tuned Linux kernel, is typically 20-25% of the system memory bandwidth.
 This is due to cache misses, interrupts, DMA from disk, memcpy into TCP
buffers, DMA from TCP buffers to NIC, window scaling, buffer sizes,
retransmitted packets, etc, etc.  With dual channel DDR3 this is
21/[5|4]= 4-5 GB/s.

As I've said many times over, you have ample, actually excess, raw
hardware performance in all of your machines.

> Mainly I wanted to confirm that the rest of the interfaces on the
> motherboard were not interconnected "worse" than the current one. I
> think from the manual the 2 x PCIe x8 and one PCIe x4 and memory were
> directly connected to the CPU, while everything else including onboard
> sata, onboard ethernet, etc are all connected via another chip.

See above.  Your PCIe slots and everything else in your current servers
are very well connected.

If you go ahead and replace the server mobos, I'm buying a ticket,
flying literally half way around the world, just to plant my boot in
your arse. ;)

> Thanks again for all your advice, much appreciated.

You're welcome.  And you're lucky I'm not billing you my hourly rate. :)

Believe it or not, I've spent considerable time both this year and last
digging up specs on your gear, doing Windows server instability
research, bonding configuration, etc, etc.  This is part of my "giving
back to the community".  In that respect, I can just idle until June
before helping anyone else. ;)

Cheers,

Stan

