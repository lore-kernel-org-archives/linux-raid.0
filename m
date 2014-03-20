From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing RAID5 SSD Array
Date: Thu, 20 Mar 2014 13:54:32 +1100
Message-ID: <532A5868.8060209@websitemanagers.com.au>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532A0200.3070000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/03/14 07:45, Stan Hoeppner wrote:
> On 3/18/2014 6:25 PM, Adam Goryachev wrote:
>> On 18/03/14 22:22, Stan Hoeppner wrote:
>>> On 3/17/2014 8:41 PM, Adam Goryachev wrote:
>>>> On 18/03/14 08:43, Stan Hoeppner wrote:
>>>>> On 3/17/2014 12:43 AM, Adam Goryachev wrote:
>>>>>> On 13/03/14 22:58, Stan Hoeppner wrote:
>>>>>>> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
> ...
>> For now, I've just ordered the 2 x Intel cards
>> plus 1 of the cables (only one in stock right now, the other three are
>> on back order) plus the switch. I should have all that by tomorrow, and
>> if all goes well and I can use the single cable as a direct connect
>> between the two machines, then that's great, if not I will have to wait
>> for more cables.
> Never install new hardware until after you have the root problem(s)
> identified and fixed.  Replacing hardware may cause more additional
> problems and won't solve any.
>
> ...
>> Yes, I was (still am) very scared to replace the DC with a Linux box.
>> Moving the SMB shares would have resulted in changing the "location" of
>> all the files, and means finding and fixing every config file or spot
>> which relies on that. Though I have thought about this a number of
>> times. Currently, the plan is to migrate the authentication, DHCP, DNS,
>> etc to a new win2008R2 machine this weekend.
> So your DHCP and DNS servers are on the DC VM.

Correct.

>> Once that is done, next
>> weekend I will try and migrate the shares to a new win2012R2 machine.
>> The goal being to resolve any issues caused by upgrading the old win NT
>> era machine over and over and over again, by using brand new
>> installations of more modern versions. When the time comes, I may
>> consider migrating the file sharing to a linux VM, I've very slightly
>> played with samba4, but I'm not particularly confident about it yet (it
>> isn't included in Debian stable yet).
> The problem isn't what is serving the shares.  The problem is the
> reliability of the system serving up the shares.
>
> ...
>>> Get out your medical examiner's kit and perform an autopsy on this
>>> Windows DC/SMB server VM.  This is where you'll find the problem I
>>> think.  If not it's somewhere in your Windows infrastructure.
>>>
>>> Two minutes to display the mapped drive list in Explorer?  That might be
>>> a master browser issue.  Go through all the Windows Event logs for the
>>> Terminal Services VMs with a fine toothed comb.
>> The performance issue impacts on unrelated linux VM's as well. I
>> recently setup a new Linux VM to run a new application. When the issue
>> is happening, if I login to this VM, disk IO is severely slow, like
>> running ls will take a long time etc...
> Slow, or delayed?  I'm guessing delayed.  Do Linux VM guests get DNS
> resolution from the Windows DNS server running on the DC?  Do any get
> their IP assignment from the DHCP server running on the DC VM?
>
> Do your Linux hypervisors resolve the IPs of the SAN1 interfaces via
> DNS?  Or do you use /etc/hosts?  Or do you have these statically
> configured in the iSCSI initiator?

Well, slow somewhat equals delayed... if it takes 20 seconds for ls of a 
small directory to return the results, then there is a problem 
somewhere. I've used slow/delayed/performance problem to mean the same 
thing. Sorry for the confusion.
Every machine (VM and physical) are configured with the DC DNS IP. 
However, no server gets any details from DHCP, they are all static 
configurations.

The Linux hypervisors use IP's for iSCSI, in fact the iSCSI servers are 
not configured in DNS, nor are the hypervisor machines, nor any of the 
Linux VM's. The only entries in DNS are the ones that windows 
automatically does as part of active directory. Almost every machine or 
service is configured by IP address.

Additional evidence that iSCSI doesn't rely on DNS is that when 
*everything* is down, I can start the san1/san2, and then start the 
linux hypervisors, and then bootup the VM's, all while obviously the 
DNS/DHCP server is not yet up. There is absolutely no external DNS 
resolution at all (though that isn't really relevant at the iSCSI/etc 
level).

>> I see the following event logs on the DC:
>> NTDS (764)NTDSA: A request to write to the file "C:\WINNT\NTDS\edb.chk"
>> at offset 0 (0x0000000000000000) for 4096 (0x00001000) bytes succeeded
>> but took an abnormally long time (72 seconds) to be serviced by the OS.
>> This problem is likely due to faulty hardware. Please contact your
>> hardware vendor for further assistance diagnosing the problem.
> Microsoft engineers always assume drive C: is a local disk.  This is why
> the error msg says "faulty hardware".  But in your case, drive C: is
> actually a SAN LUN mapped through to Windows by the hypervisor, correct?
>   To incur a 72 second delay attempting to write to drive C: indicates
> that the underlying hypervisor is experiencing significant delay in
> resolving the IP of the SAN1 network interface containing the LUN, or IP
> packets are being dropped, or the switch is malfunctioning.
>
> "C:\WINNT\NTDS\edb.chk" is the Active Directory database checkpoint
> file.  I.e. it is a journal.  AD updates are written to the journal,
> then written to the database file "NTDT.DIT", and when that operation is
> successful the transaction is removed from the checkpoint file (journal)
> edb.chk.  Such a file will likely be read/write locked when written due
> to its critical nature.  NTDT.DIT will also likely be read/write locked
> when being written.  Look for errors in your logs related to NTDT.DIT
> and Active Directory in general.

This event happened last week, in the midst of when all the users were 
re-caching all their email. At the same time, before I had worked that 
out, I was attempting to "fix" a standalone PC users problems with their 
PST file (stored on the SMB server). The PST file was approx 3GB, and I 
copied it from the SMB server to the local PC, ran scanpst to repair the 
file. When I attempted to copy the file back to the server (the PC is on 
a 100Mbps connection), the server stopped responding (totally), even 
though the console was not BSOD, all network responses stopped, no 
console activity could be seen, and SMB shares were no longer 
accessible. I assumed the server had been overloaded and crashed, in 
actual fact it was probably just overloaded and very, very, very, slow. 
I forced a reboot from the hypervisor, and the above error message was 
logged in the event viewer about 10 minutes after the crash, probably 
when I tried to copy the same file again. After it did the same thing 
the second time (stopped responding) I cancelled the copy, and 
everything recovered (without rebooting the server). In the end I copied 
the file after hours, and it completed normally. So, I would suspect the 
72 seconds occurred during that second 'freeze' when the server wasn't 
responding but I patiently waited for it to recover. This DC VM doesn't 
crash, at least I don't think it ever has, except when the san 
crashed/got lost/etc...

>> That type of event hasn't happened often:
>> 20140314 11:15:35   72 seconds
>> 20131124 17:55:48   55 minutes 12 seconds
>> 20130422 20:45:23   367 seconds
>> 20130410 23:57:16   901 seconds
> Large delays/timeouts like this are nearly always resolution related,
> DNS, NIS, etc.  I'm surprised that Windows would wait 55 minutes to
> write to a local AD file, without timing out and producing a hard error.

As part of all the previous work, every layer has been configured to 
stall rather than return disk failures, so even if the san vanishes, no 
disk read/write should be handed a failure, though I would imagine that 
sooner or later windows should assume no answer is a failure, so 
surprising indeed.

20131124 17:55:48   55 minutes 12 seconds

Records show that san1 iscsi process was stopped at 5:03:44 (or up to 5 minutes earlier), san2 never kicked in and started serving, and san1 recovered at 17:58:59 (or up to 5 minutes earlier). So I'm not sure *why* san1 failed, but I do have records showing that it did. I know it wasn't rebooted in order to recover it, and san2 wasn't offline at the time, nor did it become active (automatically or manually), nor was it rebooted.

20130422 20:45:23   367 seconds
This one looks strange... at 7:37pm all the VM's stopped responding to network (ping), at 7:41 all the physical boxes CPU went high, at 7:45 the DC logged this in the event log:
Sys: E 'Mon Apr 22 19:45:23 2013': XenVbd - " The device, \Device\Scsi\XenVbd1, did not respond within
the timeout period.  "
Sys: E 'Mon Apr 22 19:45:23 2013': MRxSmb - " The master browser has received a server announcement from
the computer BACKUPPC  that believes that it is the master browser for the domain on transport NetBT_Tcpip_{AB8F434F-3023-498C-.
  The master browser is stopping or an election is being forced.  "
Sys: E 'Mon Apr 22 19:45:23 2013': XenVbd - " The device, \Device\Scsi\XenVbd1, did not respond within
the timeout period.  "
Finally at 19:51pm the physical boxes CPU recovered,
At 19:53 san1 was rebooted
At 19:56 the physical CPU's load went high again
At 19:58 san1 came back online
At 20:01 the physical CPU's load went normal again
By 20:21 all VM's had been rebooted and were back to normal

I think at this stage, the sync between san1/san2 was disabled, and there was no automatic failover. It might also have been me changing networking on the SAN systems, I know a lot of changes were being made between Jan and April last year...

20130410 23:57:16   901 seconds

Without checking, I'm almost certain this would have been caused by me messing around, or changing things around. The timeframe is correct, (late at night, in April last year)...


>
>> Though these look like they may have happened at times when DRBD crashed
>> or similar, since I've definitely had a lot more times of very slow
>> performance....
> I serious doubt this is part of the delay problem since none of your
> hosts map anything on SAN2, according to what you told me a year ago
> told me anyway.
>
> However, why is DRBD crashing?  And what do you mean by "crashed"?  You
> mean the daemon crashed?  On which host?  Or both?

I generally mean that I did something (like adding a new SSD and growing 
the MD array) which caused a crash. I have also had issues with LVM 
snapshots where it would get into a state I couldn't add/list/delete any 
snapshots any longer, though the machine would continue to work. 
Generally these were solved by migrating to san2, reboot san1, and 
everything worked normally on san2 (or fail back to san1).

I am pretty sure that I haven't had any 'crashes' on san1/san2 under 
normal workload or without a known cause (at least for a very long time, 
probably after I installed that kernel from backports).

> "may have happened at times when"...
>
> Did you cross reference the logs on the Windows DC with the Linux logs?
>   That should give you a definitive answer.
I do have an installation of Xymon (actually the older version still 
called Hobbit) which catches things like logs, cpu, memory, disk, 
processes, etc and stores those things as well as alerts. I've never 
actually setup munin, but I have seen some of what it produces, and I 
did like the level of detail it logged (ie, the graphs I saw logged 
every smart counter from a HDD).

>
>> Also looking on the terminal servers has produced a similar lack of
>> events, except some auth errors when the DC has crashed recently.
> This DC is likely the entirety of your problems.  This is what I was
> referring to above about reliability.  Why is the DC VM crashing?  How
> often does it crash?  Is it just the VM crashing, or the physical box?
> That DC provides the entire infrastructure for your Windows Terminal
> Servers and any Windows PC on the network and, from the symptoms and log
> information you're provided, it seems pretty clear you're experiencing
> delays of some kind when the hypervisors access the SAN LUNs.  Surely
> you're not using DNS resolution for the IPs on SAN1, are you?
>
> An unreliable AD/DNS server could explain the vast majority of the
> problems you're experiencing.

Nope, definitely not using DNS for the SAN config, iscsi, etc.. I'm 
somewhat certain that this isn't a DNS issue.

>> The newest terminal servers (running Win 2012R2) show this event for
>> every logon:
>> Remote Desktop services has taken too long to load the user
>> configuration from server \\DC for user xyz
> Slow AD/DNs.
>
>> Although the logins actually do work, and seems mostly normal after
>> login, except for times when it runs really slow again.
> Same problem, slow AD/DNS.
>
>> Finally, on the old terminal servers, the PST file for outlook contained
>> *all* of the email and was stored on the SMB server, on the new terminal
>> servers, the PST file on the SMB server only contains contacts and
>> calendars (ie, very small) and the email is stored in the "local"
>> profile on the C: (which is iSCSI still). I'm hopeful that this will
>> reduce the file sharing load on the domain controller. (If the C: pst
>> file is lost, then it is automatically re-created and all the email is
>> re-downloaded from the IMAP server, so nothing is lost, but it
>> drastically increases the SAN load to re-download 2GB of email for each
>> user, which had a massive impact on performance on Friday last week!).
> You have an IMAP server which is already storing all the mail.  The
> entire point of IMAP is keeping all the mail on the IMAP server.  Each
> message is transferred to a client only when the user opens it, thus
> network load is nonexistent.
>
> Why, again, are you not having Outlook use IMAP as intended?  For the
> life of me I can't imagine why you don't...
>
> ...
Well, I'm trying to do the best (most sensible) thing that is possible 
within the constraints of MS Outlook (not my first preference for email 
client, but that's another story). To the best of my knowledge, MS 
Outlook (various versions) has never worked properly with IMAP, however, 
Outlook 2013 is one of the best versions yet. You can actually tell it 
how much email to cache (timeframe of 1 month, 3 months, etc), but if 
you tell it to only cache 3 months, then you simply can't see or access 
any email older than that. Don't ask me, but that seems to be what 
happens. Change the cache time to 6 months, and you can suddenly access 
up to 6 months of email. So the only solution is to cache ALL email 
(yes, luckily it does have a forever option).

However, the good news is that it means I don't need to store the PST 
file with the massive cache on the SMB server, since it doesn't contain 
any data that can't be automatically recovered. I create a small pst 
file on SMB to store contacts and calendars, but all other IMAP cached 
data is stored on the local C: of the terminal server. So, reduced load 
on SMB, but still the same load on iSCSI.

>> I'm really not sure, I still don't like the domain controller and file
>> server being on the same box, and the fact it has been upgraded so many
>> times, but I'm doubtful that it is the real cause.
> Being on the same physical box is fine.  You just need to get it
> reliable.  And I would never put a DNS server inside a VM if any bare
> metal outside the VM environment needs that DNS resolution.  DNS is
> infrastructure.  VMs are NOT infrastructure, but reside on top of it.

Nope, nothing requires DNS to work.... at least not to bootup, etc... 
Probably windows needs some DNS/AD for file sharing, but that is a 
higher level issue anyway.

> For less than the $375 cost of that mainboard you mentioned you can
> build/buy a box for AD duty, install Windows and configure from scratch.
>   It only needs the one inbuilt NIC port for the user LAN because it
> won't host the shares/files.

Well, I'll be doing this as a new VM... Windows 2008R2. While I hope 
this will help to split DNS/AD from SMB, I'm doubtful it will resolve 
the issues.

> You'll export the shares key from the registry of the current SMB
> server.  After you have the new bare metal AD/DNS server up, you'll shut
> the current one down and never fire it up again because you'll get a
> name collision with the new VM you are going to build...
>
> You build a fresh SMB server VM for file serving and give it the host
> name of the now shut down DC SMB server.  Moving the shares/files to the
> this new server is as simple as mounting/mapping the file share SAN LUN
> to the new VM, into the same Windows local device path as on the old SMB
> server (e.g. D:\).  After that you restore the shares registry key onto
> the new SMB server VM.
>
> This allows all systems that currently map those shares by hostname and
> share path to continue to do so.  Basic instructions for migrating
> shares in this manner can be found here:
>
> http://support.microsoft.com/kb/125996

Thank you for the pointer, that makes me more confident about copying 
share configuration and permissions. The only difference to the above is 
I plan on creating a new disk, formatting with win2012R2, and copy the 
data from the old disk across. The reason is that the old disk was 
originally formatted by Win NT, it was suggested that it might be a good 
idea to start with a newly formatted/clean filesystem. The concern with 
this is copying of the ACL information on those files, hence some 
testing beforehand will be needed.

>
>> On Thursday night after the failed RAID5 grow, I decided not to increase
>> the allocated space for the two new terminal servers (in case I caused
>> more problems), and simply deleted a number of user profiles on each
>> system. (I assumed the roaming profile would simply copy back when the
>> user logged in the next day). However, the roaming profile didn't copy,
>> and windows logged users in with a temp profile, so eventually the only
>> fix was to restore the profile from the backup server. Once I did this,
>> the user could login normally, except the backup doesn't save the pst
>> file, so outlook was forced to re-download all of the users email from
>> IMAP.
> ...
>> This then caused the really, really, really bad performance across
>> the SAN,
> Can you quantify this?  What was the duration of this really, really,
> really bad performance?  And how do you know the bad performance existed
> on the SAN links and not just the shared LAN segment?  You don't have
> your network links, or systems, instrumented, so how do you know?

Well running an ls from a linux VM CLI doesn't rely on the user LAN 
segment... (other than the ssh connection).
I do collect and graph a lot of various numbers, though generally I 
don't find graphs to produce fine grained values which are so useful, 
but I keep trying to collect more information in the hope that it might 
tell me something eventually...

For example, I am graphing the "Backlog" and "ActiveTime" on each 
physical disk, DRBD, and each LV in san1, at the time of my tests, when 
I said I did an "ls" command on this test VM, I see BackLog values on 
the LV for the VM of up to 9948, which AFAIK, means a 10second delay. 
This was either consistently around 10seconds for a number of minutes, 
or varied much higher and lower to produce this average/graph figure.

Using these same graphs, I can see the much higher than normal BackLog 
and ActiveTime values for the two terminal servers that I expected were 
re-caching all the IMAP emails. So again, there is some correlation to 
iSCSI load and the issues being seen.

In addition, I can see much higher (at least three time higher) values 
on the SMB/DC server.

If I look at read/write sectors/sec graphs, then I can see:
1) Higher than normal read activity on the IMAP VM
2) Significantly higher than normal write activity on the two Terminal 
Servers between 10am (when I fixed the user profiles) and 3pm.
3) Higher than normal read/write activity on the SMB/DC between 9am and 
12pm, but much lower than backup read rates for example.

Looking at the user LAN, I also take the values from the hypervisor for 
each network interface. During testing I can see the new win2008R2 
server was doing 28Mbps receive and 21Mbps transmit. Though given the 
intermittent nature of my testing, it may not have been long enough to 
generate accurate average values that can be seen on the graphs, even 
though the rates somewhat match what I was reporting, around 20 to 
25MB/s transfer rates.

During the day (Friday) I can see much higher than normal activity on 
the mail server, up to around 5MB/s peak value.
Again, the two new terminal servers show TX rates up to 3.4MB/s and 
2.5MB/s, which is lot higher than a "normal" work day peak, and also 
these high traffic levels were consistent over the time periods above 
(10am to 3pm).

Finally, on the SMB/DC I see RX traffic peaking at 4MB/s and TX at 
3MB/s, but other than those peaks (probably when I was copying that PST 
file that caused the "crash") traffic levels look similar to other days.

I also graph CPU load. This is the number of seconds of CPU time given 
to the VM divided by the interval. So if the VM was given 20 seconds of 
CPU time in the past minute, then we record a value of 0.33, however we 
should also remember that a value of 4.0 would be expected for a VM with 
4 vCPU's. On the Friday, no VM was especially busy, the mail server was 
about the same as normal, and still below 0.4, and it has 2 vCPU's.

Also, I graph the "disk" IO performed by each VM, as reported by the 
hypervisor, in bytes read/write per second.
During my late night Friday testing, I can see the test win2008R2 VM 
peaking at 185MB/s write, I don't recall what I did to generate the 
traffic, I think I was copying a file from it's C: to the same drive. So 
the read was probably cached, but re-writing the same file multiple 
times generated a lot of write load.

On the Friday, I again see the high disk IO for the two new terminal 
servers, higher than the normal load. Of course, for most other machines 
their peak is lower than the backup load peak, but for these two the 
backup is done from LVM snapshots, so the load doesn't show up on the VM 
at all. (BTW, due to the load that LVM snapshots seem to place, the 
backup system takes a snapshot, does the backup, and immediately removes 
the snapshot when done). All backups are done at night time, to avoid 
any issues with users etc.

I also have MRTG graphs for each port on each switch.
I can see that for each physical machine (hypervisor) it is balancing 
the traffic evenly across both iSCSI links. Both send and receive 
traffic is equal across the pair of links.
Also, for san1, I can see the switch reports IN traffic (which would be 
outbound from san1) is not evenly balanced across all 8 links, but there 
is definite amounts of traffic across all 8 links. I can also see OUT 
traffic (inbound to san1) is 0 on 5 of the links, and the large majority 
of the traffic is on one link (peaking at 40Mbps yesterday during normal 
work day load, and 75Mbps during backup load last night). The other two 
links with load peaked at 18Mbps yesterday, and didn't do very much load 
during the backups being run last night (actually, basically zero). 
Today's peak so far for these two lines is 30Mbps, and the single line 
peak is 30Mbps, all three at the same time.

One issue I have is that I don't necessarily know which physical machine 
was hosting which VM at what time, although I know I always put the 
DC/SMB server on the same physical box. So this makes it more difficult 
to match the "user" lan traffic with the VM, though the other graphs 
above from the hypervisor should be accurate for network traffic anyway. 
Also, the MRTG graphs are only every 5 minutes, while the hypervisor 
based graphs are 1 minute averages, so MRTG is a lot "coarser".

> Given that you've had continuous problems with this particular mini
> datacenter, and the fact that you don't document problems in order to
> track them, you need to instrument everything you can.  Then when
> problems arise you can look at the data and have a pretty good idea of
> where the problems are.  Munin is pretty decent for collecting most
> Linux metrics, bare metal and guest, and it's free:
>
> http://munin-monitoring.org/
>
> It may help identify problem periods based on array throughput, NIC
> throughput, errors, etc.

Thanks, I'll take a look at installing it, will probably start with my 
desktop pc, and then extend to san2 and one of the hypervisor boxes, 
before extending to san1 and the rest. I'm not sure where I'll put the 
"master" node, or how much it will overlap with the existing stats I'm 
collecting, but it certainly promises to help find performance issues....

>> yet it didn't generate any traffic on the SMB shares from the
>> domain controller. In addition, as I mentioned, disk IO on the newest
>> Linux VM was also badly delayed.
> Now you say "delayed", not "bad performance".  Do all of your VMs
> acquire DHCP and DNS from the DC VM?  If so, again, there's your problem.
>
> Linux does not cache DNS information.  It queries the remote DNS server
> every time it needs a name to address mapping.

Delayed just means it didn't work as quickly as expected but worked 
eventually, bad performance means it took longer than expected but still 
worked. ie, both the same. At least, to me they mean the same thing....

>> Also, copying from a smb share on a
>> different windows 2008 VM (basically idle and unused) showed equally bad
>> performance copying to my desktop (linux), etc.
> Now you say "bad performance" again.  So you have a combination of DNS
> problems, "delay", and throughput issues, "bad performance".  Again, can
> you quantify this "bad performance"?
>
> I'm trying my best to help you identify and fix your problems, but your
> descriptions lack detail.
Apologies, both the same thing.

>> So, essentially the current plans are:
>> Install the Intel 10Gb network cards
>> Replace the existing 1Gbps crossover connection with one 10Gbps connection
>> Replace the existing 8 x 1Gbps connections with 1 x 10Gbps connection
> You can't fix these problems by throwing bigger hardware at them.
> Switching to 10 GbE links might fix your current "bad performance" by
> eliminating the ALB bonds, or by eliminating ports that are currently
> problematic but unknown, see link speed/duplex below.  However, as I
> recommended when you acquired the quad port NICs, you shouldn't have
> used bonds in the first place.  Linux bonding relies heavily on ARP
> negotiation and the assumption that the switch properly updates its MAC
> routing tables and in a timely manner.  It also relies on the bond
> interfaces having a higher routing priority than all the slaves, or that
> the slaves have no route configured.  You probably never checked nor
> ensured this when you setup your bonding.

I'm not using bonding on the hypervisors, they are using multipath to 
make use of each link. I'm using bonding on the san1/san2 server only, 
which is configured as:
iface bond0 inet static
     address x.x.16.1
     netmask 255.255.255.0
     slaves eth2 eth3 eth4 eth5 eth6 eth7 eth8 eth9
     bond-mode balance-alb
     bond-miimon 100
     bond-updelay 200
     mtu 9000

This is slightly different to what you suggested, from memory, you 
suggested I should have two bond groups on each of san1/san2 of 4 
connections each, and each physical server should have one ethernet 
connection to each bond group. Changing that would probably improve the 
problem mentioned above with almost all the inbound (san1) traffic using 
the one link.

None of the slave interfaces are configured at all, so I doubt there is 
any issue with routing or interface priority.

> It's possible that due to bonding issues that all of your SAN1 outbound
> iSCSI packets are going out only two of the 8 ports, and it's possible
> that all the inbound traffic is hitting a single port.
It looks like (from the switch mrtg graphs) that outbound balancing is 
working properly, but inbound balancing is very poor, almost just a 
single link.

>   It's also
> possible that the master link in either bond may have dropped link
> intermittently, dropped link speed to 100 or 10, or is bouncing up and
> down due to a cable or switch issue, or may have switched from full to
> half duplex.  Without some kind of monitoring such as Munin setup you
> simply won't know this without manually looking at the link and TX/RX
> statistic for every port with ifconfig and ethtool, which, at this point
> is a good idea.  But, if any links are flapping up and down at irregular
> intervals, note they may all show 1000 FDX when you check manually with
> ethtool, even though they're dropping link on occasion.

The switch logs don't show any links dropped or changing speed since at 
least Monday night when I last rebooted one of the san servers. The 
switch also logs via syslog to the mail server, logs there don't show 
any unexpected link drops or speed changes etc. All cables used are new 
cables (from last year), cat6 I think or else cat5e, and all are less 
than 3m long. I've not seen any evidence of a faulty cable or port on 
either the network cards or switches. In addition, any link drop logs a 
kernel message in syslog, which is reported up to hobbit/xymon with an 
associated alert (SMS).

>
> You need to have some monitoring setup, alerting is even better.  If an
> interface in those two bonds drops link you should currently be
> receiving an email or a page.  Same goes for the DRBD link.
Done, any process not running, port not listening (ie TCP port), port 
not in a connected state (DRBD talking), MD alert, or certain log 
entries will all generate an SMS alert.


> Last I recall you had setup two ALB bonds of 4 ports each, with the
> multipath mappings of LUNS atop the bonds--against my recommendation of
> using straight multipath without bonding.  That would have probably
> avoided some of your problems.

I might be wrong, but from memory we had agreed that using 2 groups of 4 
bonded channels on the SAN1/2 side was the best option. I never did get 
around to doing that, because it seemed to be working well enough as is, 
and I didn't want to keep changing things (ie, breaking things and then 
trying to fix them again). Things were never really fully resolved, they 
were just good enough, but the mess on Friday means that now things need 
to be pretty much perfect. I think replacing this group of 8 bonded 
connections with a single 10Gbps connection should solve this even 
better than using 2 groups of 4 bonds, or any other option. I assume I 
will keep the 2 multipath connections on the physical boxes the same as 
current, simply removing the bond group on the san, configuring the new 
10Gbps port with the same IP/netmask as previous, and everything should 
work nicely.

> Anyway, switching to 10 GbE should solve all of this as you'll have a
> single interface for iSCSI traffic at the server, no bond problems to
> deal with, and 200 MB/s more peak potential bandwidth to boot, even
> though you'll never use half of it, and then only in short bursts.

Agreed.

>> Migrate the win2003sp2 authentication etc to a new win2008R2 server
>> Migrate the win2003sp2 SMB to a new win2012R2 server
> DNS is nearly always the cause of network delays.  To avoid it, always
> hard code hostnames and IPs into the host files of all your operating
> systems because your server IPs never change.  This prevents problems in
> your DNS server from propagating across everything and causing delays
> everywhere.  With only 8 physical boxen and a dozen VMs, it simply
> doesn't make sense to use DNS for resolving the IPs of these
> infrastructure servers, given the massive problems it causes, and how
> easy it is to manually configure hosts entries.

Done, I definitely couldn't rely on DNS being provided by the VM as you 
noted. Generally Linux machines (that I configure) don't rely on DNS for 
anything, I don't change IP addresses on servers enough to make that 
even slightly useful (would anyone?).

>> I'd still like to clarify whether there is any benefit to replacing the
>> motherboard, if needed, I would prefer to do that now rather than later.
> The Xeon E3-1230V2 CPU has an embedded PCI Express 3.0 controller with
> 16 lanes.  The bandwidth is 32 GB/s.  This is greater than the 21/25
> GB/s memory bandwidth of the CPU, so the interface is downgraded to PCIe
> 2.0 at 16 GB/s.  In the S1200BTLR motherboard this is split into one x8
> slot and two x4 slots.  The third x4 slot is connected to the C204
> Southbridge chip.
>
> With this motherboard, CPU, 16GB RAM, 8 of those Intel SSDs in a nested
> stripe 2x md/RAID5 on the LSI, and two dual port 10G NICs, the system
> could be easily tuned to achieve ~3.5/2.5 GB/s TCP read/write
> throughput.  Which is 10x (350/250 MB/s) the peak load your 6 Xen
> servers will ever put on it.  The board has headroom to do 4-5 times
> more than you're asking of it, if you insert/attach the right combo of
> hardware, and tweak the bejesus out of your kernel and apps.
>
> The maximum disk-to-network and reverse throughput one can typically
> achieve on a platform with sufficient IO bandwidth, and an optimally
> tuned Linux kernel, is typically 20-25% of the system memory bandwidth.
>   This is due to cache misses, interrupts, DMA from disk, memcpy into TCP
> buffers, DMA from TCP buffers to NIC, window scaling, buffer sizes,
> retransmitted packets, etc, etc.  With dual channel DDR3 this is
> 21/[5|4]= 4-5 GB/s.
>
> As I've said many times over, you have ample, actually excess, raw
> hardware performance in all of your machines.

OK, so I'll just add the dual port 10Gbps network card, and remove the 2 
quad port 1Gbps cards from each server. That will mean there is only two 
cards installed in each san system. I really don't think it is 
worthwhile right now, but I may re-use these cards by installing one 
quad port card into 4 of the physical machines, and use 2 x dual port 
cards in the other 4, and increase the iSCSI to 4 multipath connections 
on each physical. That is all in the future though, for now I just want 
to obtain at least 50MB/s (minimum, I should expect at least 100MB/s) 
performance for the VM's, consistently....

>> Mainly I wanted to confirm that the rest of the interfaces on the
>> motherboard were not interconnected "worse" than the current one. I
>> think from the manual the 2 x PCIe x8 and one PCIe x4 and memory were
>> directly connected to the CPU, while everything else including onboard
>> sata, onboard ethernet, etc are all connected via another chip.
> See above.  Your PCIe slots and everything else in your current servers
> are very well connected.
>
> If you go ahead and replace the server mobos, I'm buying a ticket,
> flying literally half way around the world, just to plant my boot in
> your arse. ;)

I'll save you most of the trouble, I'll be in the USA next month :) 
however, I promise I won't get any new motherboards for now :)

>> Thanks again for all your advice, much appreciated.
> You're welcome.  And you're lucky I'm not billing you my hourly rate. :)
>
> Believe it or not, I've spent considerable time both this year and last
> digging up specs on your gear, doing Windows server instability
> research, bonding configuration, etc, etc.  This is part of my "giving
> back to the community".  In that respect, I can just idle until June
> before helping anyone else. ;)

Absolutely, and I greatly appreciate it all!

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
