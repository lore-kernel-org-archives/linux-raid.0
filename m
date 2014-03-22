From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Growing RAID5 SSD Array
Date: Sat, 22 Mar 2014 14:39:40 -0500
Message-ID: <532DE6FC.5010301@hardwarefreak.com>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532A5868.8060209@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/19/2014 9:54 PM, Adam Goryachev wrote:
> On 20/03/14 07:45, Stan Hoeppner wrote:
>> On 3/18/2014 6:25 PM, Adam Goryachev wrote:
>>> On 18/03/14 22:22, Stan Hoeppner wrote:
>>>> On 3/17/2014 8:41 PM, Adam Goryachev wrote:
>>>>> On 18/03/14 08:43, Stan Hoeppner wrote:
>>>>>> On 3/17/2014 12:43 AM, Adam Goryachev wrote:
>>>>>>> On 13/03/14 22:58, Stan Hoeppner wrote:
>>>>>>>> On 3/12/2014 9:49 PM, Adam Goryachev wrote:
...
>> Do your Linux hypervisors resolve the IPs of the SAN1 interfaces via
>> DNS?  Or do you use /etc/hosts?  Or do you have these statically
>> configured in the iSCSI initiator?
> 
> Well, slow somewhat equals delayed... if it takes 20 seconds for ls of a
> small directory to return the results, then there is a problem
> somewhere. 

Agreed.  But where exactly?  Hmmm... this 'ls' delay sounds vaguely
familiar.

> I've used slow/delayed/performance problem to mean the same
> thing. Sorry for the confusion.

An example of the distinction between "delayed" and "slow" would be
clicking a link in your browser.  In the "delayed" case it takes 10
seconds for IP resolution but the file downloads at max throughput in 30
seconds.  In the "slow" case IP resolution is instant but network
congestion causes a 2 minute download.

With a browser it's easy to see where the problem is, but not here.  In
your case the delays are not necessarily distinguishable without using
tools.  For slow 'ls' on the new Linux guest you can see where the
individual latencies exist in execution by running the 'ls' command
through strace.  And that reminds me...

Nearly every time I've seen this 'slow ls' problem reported, the cause
has been delayed or slow response from an LDAP server in a single
sign-on, global authentication environment.  With such a setup, during
'ls' of a local filesystem, the Linux group and user data must be looked
up on the LDAP server for each file in the directory, not locally as is
the case with standard Linux passwd security.

Do you have such a single sign on configuration on the new Linux VM you
mentioned?  If so this may tend to explain why 'ls' in the Linux guest
is slow at the same time Windows share operations are also slow, as both
rely on the AD/DC server.

> Every machine (VM and physical) are configured with the DC DNS IP.
> However, no server gets any details from DHCP, they are all static
> configurations.

Got it.  Just covering the bases.

...
>>> I see the following event logs on the DC:
>>> NTDS (764)NTDSA: A request to write to the file "C:\WINNT\NTDS\edb.chk"
>>> at offset 0 (0x0000000000000000) for 4096 (0x00001000) bytes succeeded
>>> but took an abnormally long time (72 seconds) to be serviced by the OS.
>>> This problem is likely due to faulty hardware. Please contact your
>>> hardware vendor for further assistance diagnosing the problem.
>>
>> Microsoft engineers always assume drive C: is a local disk.  This is why
>> the error msg says "faulty hardware".  But in your case, drive C: is
>> actually a SAN LUN mapped through to Windows by the hypervisor, correct?
>>   To incur a 72 second delay attempting to write to drive C: indicates
>> that the underlying hypervisor is experiencing significant delay in
>> resolving the IP of the SAN1 network interface containing the LUN, or IP
>> packets are being dropped, or the switch is malfunctioning.
>>
>> "C:\WINNT\NTDS\edb.chk" is the Active Directory database checkpoint
>> file.  I.e. it is a journal.  AD updates are written to the journal,
>> then written to the database file "NTDT.DIT", and when that operation is
>> successful the transaction is removed from the checkpoint file (journal)
>> edb.chk.  Such a file will likely be read/write locked when written due
>> to its critical nature.  NTDT.DIT will also likely be read/write locked
>> when being written.  Look for errors in your logs related to NTDT.DIT
>> and Active Directory in general.
> 
> This event happened last week, in the midst of when all the users were
> re-caching all their email. At the same time, before I had worked that
> out, I was attempting to "fix" a standalone PC users problems with their
> PST file (stored on the SMB server). The PST file was approx 3GB, and I
> copied it from the SMB server to the local PC, ran scanpst to repair the
> file. When I attempted to copy the file back to the server (the PC is on
> a 100Mbps connection), 

Let's assume for now that this was just an ugly byproduct of the NT
kernel going out for lunch at the time.  And this would make sense in
the case of the kernel driver issue in the KB article below.

> the server stopped responding (totally), even
> though the console was not BSOD, all network responses stopped, no
> console activity could be seen, and SMB shares were no longer
> accessible. I assumed the server had been overloaded and crashed, in
> actual fact it was probably just overloaded and very, very, very, slow.

A 3GB file copy to a share over 100FDX won't overload a windows server
if it's configured properly.  These may apply to your problem, probably
many more:

http://support.microsoft.com/kb/822219
http://support.microsoft.com/kb/2550581

These don't address AD non-responsiveness, but with Windows, it's
certainly possible that the SMB problem described here is negatively
impacting the AD service, and/or other services.  Windows is rather
notorious for breakage in one service causing problems with others due
to the interdependent design or Windows processes, unlike in the UNIX
world where daemons tend to be designed for fault isolation.

> I forced a reboot from the hypervisor, and the above error message was
> logged in the event viewer about 10 minutes after the crash, probably
> when I tried to copy the same file again. After it did the same thing
> the second time (stopped responding) I cancelled the copy, and
> everything recovered (without rebooting the server). In the end I copied
> the file after hours, and it completed normally. So, I would suspect the
> 72 seconds occurred during that second 'freeze' when the server wasn't
> responding but I patiently waited for it to recover. This DC VM doesn't
> crash, at least I don't think it ever has, except when the san
> crashed/got lost/etc...

Windows event logging is anything but realtime.  It will often log an
error that occurred before a reboot long after the system comes back up.
 Sometimes the time stamp tells you this, sometimes it doesn't...

>>> That type of event hasn't happened often:
>>> 20140314 11:15:35   72 seconds
>>> 20131124 17:55:48   55 minutes 12 seconds
>>> 20130422 20:45:23   367 seconds
>>> 20130410 23:57:16   901 seconds

Looks like the SAN LUNs were unavailable at these times.  The above are
all on the DC Xen host correct?  Did the other Windows VMs log delayed
C: writes at these times?

> As part of all the previous work, every layer has been configured to
> stall rather than return disk failures, so even if the san vanishes, no
> disk read/write should be handed a failure, though I would imagine that
> sooner or later windows should assume no answer is a failure, so
> surprising indeed.

This is "designing for failure" and I recommend against it.  If one's
SAN is properly designed and implemented this should not be necessary.
All this does is delay detection of serious problems.  Even with a home
brew SAN this shouldn't be necessary.  I've done a few boot from SAN
systems and never did anything like you describe here, but not on home
brew hardware, but IBM blades with Qlogic FC HBAs.

...
> I do have an installation of Xymon (actually the older version still
> called Hobbit) which catches things like logs, cpu, memory, disk,
> processes, etc and stores those things as well as alerts. I've never

Ok, good, so you've got some monitoring/collection going on.

> actually setup munin, but I have seen some of what it produces, and I
> did like the level of detail it logged (ie, the graphs I saw logged
> every smart counter from a HDD).

It can be pretty handy.

>>> Also looking on the terminal servers has produced a similar lack of
>>> events, except some auth errors when the DC has crashed recently.
>>
>> This DC is likely the entirety of your problems.  This is what I was
>> referring to above about reliability.  Why is the DC VM crashing?  How
>> often does it crash?
...
>> An unreliable AD/DNS server could explain the vast majority of the
>> problems you're experiencing.
...
> Nope, definitely not using DNS for the SAN config, iscsi, etc.. I'm
> somewhat certain that this isn't a DNS issue.

And at this point I agree.  It's not DNS, but most likely the SMB
redirector and kernel on the DC going out to lunch, and the AD service
with them, likely many services on this Windows VM as well.

>>> The newest terminal servers (running Win 2012R2) show this event for
>>> every logon:
>>> Remote Desktop services has taken too long to load the user
>>> configuration from server \\DC for user xyz

>> Slow AD/DNs.

Malfunctioning SMB redirector.

>>> Although the logins actually do work, and seems mostly normal after
>>> login, except for times when it runs really slow again.

>> Same problem, slow AD/DNS.

Malfunctioning SMB redirector.

...
> However, the good news is that it means I don't need to store the PST
> file with the massive cache on the SMB server, since it doesn't contain
> any data that can't be automatically recovered. I create a small pst
> file on SMB to store contacts and calendars, but all other IMAP cached
> data is stored on the local C: of the terminal server. So, reduced load
> on SMB, but still the same load on iSCSI.

The block IO load is probably small, as your throughput numbers below
demonstrate.  The problem here will be CPU load in the VM as Outlook
parses 2-3GB or larger cached mail files.

>>> I'm really not sure, I still don't like the domain controller and file
>>> server being on the same box, and the fact it has been upgraded so many
>>> times, but I'm doubtful that it is the real cause.
>>
>> Being on the same physical box is fine.  You just need to get it
>> reliable.  And I would never put a DNS server inside a VM if any bare
>> metal outside the VM environment needs that DNS resolution.  DNS is
>> infrastructure.  VMs are NOT infrastructure, but reside on top of it.
> 
> Nope, nothing requires DNS to work.... at least not to bootup, etc...
> Probably windows needs some DNS/AD for file sharing, but that is a
> higher level issue anyway.

In modern MS networks since Win2000 AD/DNS are required for all hostname
resolution if NETBIOS is disabled across the board, as it should be.
Every machine in the AD domain registers its hostname in DNS.  So if AD
goes down, machines can't find one another after their local DNS caches
have expired.

TTBOMK AD is required for locating shares, user/group permissions, etc
in a domain based network.  For workgroups this is still handled solely
by the SMB redirector and local machine SAM.

>> For less than the $375 cost of that mainboard you mentioned you can
>> build/buy a box for AD duty, install Windows and configure from scratch.
>>   It only needs the one inbuilt NIC port for the user LAN because it
>> won't host the shares/files.
> 
> Well, I'll be doing this as a new VM... Windows 2008R2. While I hope
> this will help to split DNS/AD from SMB, I'm doubtful it will resolve
> the issues.

It very well may fix it, based on what the MS knowledge base had to say.
 Just make sure all service packs go on immediately, obviously, and
automatic updates enabled/scheduled to install in the wee a.m.

The next time this happens, manually stop and restart the Server service
on the DC and see if that breaks the SMB hang.  Of course, if the CPU is
racing this may be difficult.

>> You'll export the shares key from the registry of the current SMB
>> server.  After you have the new bare metal AD/DNS server up, you'll shut
>> the current one down and never fire it up again because you'll get a
>> name collision with the new VM you are going to build...
>>
>> You build a fresh SMB server VM for file serving and give it the host
>> name of the now shut down DC SMB server.  Moving the shares/files to the
>> this new server is as simple as mounting/mapping the file share SAN LUN
>> to the new VM, into the same Windows local device path as on the old SMB
>> server (e.g. D:\).  After that you restore the shares registry key onto
>> the new SMB server VM.
>>
>> This allows all systems that currently map those shares by hostname and
>> share path to continue to do so.  Basic instructions for migrating
>> shares in this manner can be found here:
>>
>> http://support.microsoft.com/kb/125996
> 
> Thank you for the pointer, that makes me more confident about copying
> share configuration and permissions. The only difference to the above is
> I plan on creating a new disk, formatting with win2012R2, and copy the
> data from the old disk across. 

I assume you read the caveat about duplicate hostnames.  You can't have
both hosts running simultaneously.  And AFAIK you can't change the
hostname of a DC after the Windows install.  So plan this migration
carefully.  You also must have the AD database dumped and imported to
the new host -before- you copy the files from the old "disk" to the new
disk, and before you import the registry shares file.  The users and
groups must exist before importing the shares.

> The reason is that the old disk was
> originally formatted by Win NT, it was suggested that it might be a good
> idea to start with a newly formatted/clean filesystem. The concern with
> this is copying of the ACL information on those files, hence some
> testing beforehand will be needed.

"Volumes formatted with previous versions of NTFS are upgraded
automatically by Windows 2000 Setup."

http://technet.microsoft.com/en-us/library/cc938945.aspx

The only on disk format change since NTFS 3.0 (Windows 2000) and NTFS
3.1 (all later Windows version) is the addition of symbolic links, which
you won't be using since you never have and none of your apps require
them.  Normally the sole reason to copy the files to a fresh NTFS
filesystem would be to eliminate fragmentation.  This filesystem resides
on SSD, where fragmentation effects are non existent.

Thus there is no advantage of any kind to your new filesystem plan.
Mount the current filesystem on the new VM and continue.  This will also
ensure the shares transfer procedure works, whereas your copy plan might
break that.

>>> On Thursday night after the failed RAID5 grow, I decided not to increase
>>> the allocated space for the two new terminal servers (in case I caused
>>> more problems), and simply deleted a number of user profiles on each
>>> system. (I assumed the roaming profile would simply copy back when the
>>> user logged in the next day). However, the roaming profile didn't copy,
>>> and windows logged users in with a temp profile, so eventually the only
>>> fix was to restore the profile from the backup server. Once I did this,
>>> the user could login normally, except the backup doesn't save the pst
>>> file, so outlook was forced to re-download all of the users email from
>>> IMAP.
>> ...
>>> This then caused the really, really, really bad performance across
>>> the SAN,
>>
>> Can you quantify this?  What was the duration of this really, really,
>> really bad performance?  And how do you know the bad performance existed
>> on the SAN links and not just the shared LAN segment?  You don't have
>> your network links, or systems, instrumented, so how do you know?
> 
> Well running an ls from a linux VM CLI doesn't rely on the user LAN
> segment... (other than the ssh connection).

Unless as I mentioned up above you're using LDAP for global auth/single
sign on in this Linux VM.

> I do collect and graph a lot of various numbers, though generally I
> don't find graphs to produce fine grained values which are so useful,
> but I keep trying to collect more information in the hope that it might
> tell me something eventually...

Munin provides trends.  It can assist in proactive monitoring, but can
also assist in troubleshooting when things break or performance drops,
often allowing one to quickly zero in on which daemon or hardware is
causing problems.  For this benefit one need be familiar with the data,
which requires looking at one's Munin graphs regularly, as in daily,
every other day, etc.

> For example, I am graphing the "Backlog" and "ActiveTime" on each
> physical disk, DRBD, and each LV in san1, at the time of my tests, when
> I said I did an "ls" command on this test VM, I see BackLog values on
> the LV for the VM of up to 9948, which AFAIK, means a 10second delay.
> This was either consistently around 10seconds for a number of minutes,
> or varied much higher and lower to produce this average/graph figure.

I can tell you this right now--any value for a "backlog" metric relating
to block devices is not likely to be elapsed time.  It's going to be
outstanding requests, pages, kbytes, etc.  And if it is a time value
then your LVM setup is totally fubar'ed.

Is this a Xymon or Munin graph you're referring to?  I can't find any
information on LVM metrics captured for either, because as is typical
with most FOSS, the documentation is non-existent.  It would really help
if you'd:

A.  pastebin or include the raw data and heading quantities
B.  look up "backlog" and "activetime" in the documentation that came
    with the package(s) you installed.  That way we don't have to guess
    as to the meaning of "backlog" and what the value quantity is

> Using these same graphs, I can see the much higher than normal BackLog
> and ActiveTime values for the two terminal servers that I expected were
> re-caching all the IMAP emails. So again, there is some correlation to
> iSCSI load and the issues being seen.

No, the correlation is simply between application use and IO.  The
amount of IO isn't causing the problems.  The cause of those lie
elsewhere, probably in what I described above in the KB references, or
similar.

Your md arrays are capable of approximately 6*50,000 = 300,000 4KB read
IOPs, and 250,000 write.  A backlog of 10K open/outstanding LVM read
pages is insignificant as it will be drained in 0.03 seconds, writes in
0.04 seconds.

> In addition, I can see much higher (at least three time higher) values
> on the SMB/DC server.

And this tells you (and me) absolutely squat without knowing the meaning
of "backlog" and the quantity it is providing.  You're walking around in
the dark without that information.

> If I look at read/write sectors/sec graphs, then I can see:
> 1) Higher than normal read activity on the IMAP VM

Because Outlook is syncing.  Nothing abnormal about this.

> 2) Significantly higher than normal write activity on the two Terminal
> Servers between 10am (when I fixed the user profiles) and 3pm.

Again, simply users doing work.

> 3) Higher than normal read/write activity on the SMB/DC between 9am and
> 12pm, but much lower than backup read rates for example.

Define "normal" and then "higher".  User loads fluctuate.  If something
happens to break when user load is "higher than normal", it's not
because your storage infrastructure can't handle the load.  It's because
some piece of software, 99% sure to be MS, is broken, and that's why it
can't handle the load.

> Looking at the user LAN, I also take the values from the hypervisor for
> each network interface. During testing I can see the new win2008R2
> server was doing 28Mbps receive and 21Mbps transmit. Though given the

3.5 MB/s and 2.6 MB/s, which is nothing.

> intermittent nature of my testing, it may not have been long enough to
> generate accurate average values that can be seen on the graphs, even
> though the rates somewhat match what I was reporting, around 20 to
> 25MB/s transfer rates.

Are you talking about the same thing?  You just switched bandwidths by a
factor of 8, bits to bytes.  In either case, that amount of traffic is
nothing given your hardware horsepower.

> During the day (Friday) I can see much higher than normal activity on
> the mail server, up to around 5MB/s peak value.
> Again, the two new terminal servers show TX rates up to 3.4MB/s and
> 2.5MB/s, which is lot higher than a "normal" work day peak, and also
> these high traffic levels were consistent over the time periods above
> (10am to 3pm).

So what were your users doing?  Maybe the extra traffic was a single
user doing data transformations or something.  Who knows.

> Finally, on the SMB/DC I see RX traffic peaking at 4MB/s and TX at
> 3MB/s, but other than those peaks (probably when I was copying that PST
> file that caused the "crash") traffic levels look similar to other days.

Just to be thorough, run ifconfig on the DC hypervisor and look at
errors, dropped packets, overruns, frame errors, carrier errors, and
collisions for the user NIC port and the two SAN NIC ports.  Also do the
same for all 8 ports on SAN1.  Check the switch for any errors on the
ports that the DC box connects to.  Check the user switch for errors on
the DC box port.

If the PC on which you had to reload the Outlook data is connected to
the same user switch as the DC box, check stats/errors on that port at
well, and check for network related errors in the event log.  If you
find any corresponding to that time period, I'd replace the patch cables
on both ends, especially if that user has reported any odd problems,
more so than other users.  If you see a lot of errors, replace the NIC
as well.

The reason I mention this is that I've seen low end intelligent switches
get "knocked out" temporarily when a client NIC goes bad, VRM fail, etc,
and it starts putting too much voltage on the wire.  Some switches
aren't designed to drain the extra voltage to ground, or they simply
aren't grounded and can't, and they literally "lock up" the client stops
transmitting.

You said that copying the PST down from the DC went fine, but as soon as
you starting copying the repaired version back up to the DC, everything
went to hell.

Makes ya go "hmmm" doesn't it?  This can happen even if the client is on
an upstream switch as well, but it's far less likely in that case, as it
usually just makes the upstream switch go brain dead for a bit.

> I also graph CPU load. This is the number of seconds of CPU time given
> to the VM divided by the interval. So if the VM was given 20 seconds of
> CPU time in the past minute, then we record a value of 0.33, however we
> should also remember that a value of 4.0 would be expected for a VM with
> 4 vCPU's. On the Friday, no VM was especially busy, the mail server was
> about the same as normal, and still below 0.4, and it has 2 vCPU's.
> 
> Also, I graph the "disk" IO performed by each VM, as reported by the
> hypervisor, in bytes read/write per second.
> During my late night Friday testing, I can see the test win2008R2 VM
> peaking at 185MB/s write, I don't recall what I did to generate the
> traffic, I think I was copying a file from it's C: to the same drive. So
> the read was probably cached, but re-writing the same file multiple
> times generated a lot of write load.

But this did not involve the DC correct?

> On the Friday, I again see the high disk IO for the two new terminal
> servers, higher than the normal load. Of course, for most other machines
> their peak is lower than the backup load peak, but for these two the
> backup is done from LVM snapshots, so the load doesn't show up on the VM
> at all. (BTW, due to the load that LVM snapshots seem to place, the
> backup system takes a snapshot, does the backup, and immediately removes
> the snapshot when done). All backups are done at night time, to avoid
> any issues with users etc.

As is usually done.

> I also have MRTG graphs for each port on each switch.
> I can see that for each physical machine (hypervisor) it is balancing
> the traffic evenly across both iSCSI links. Both send and receive
> traffic is equal across the pair of links.

Which is great.

> Also, for san1, I can see the switch reports IN traffic (which would be
> outbound from san1) is not evenly balanced across all 8 links, but there
> is definite amounts of traffic across all 8 links. I can also see OUT

This is because balance-alb is transmit load adaptive.  It only
transmits from more than one link when packet load is sufficiently high.
 This data tells you what I did from the time I got involved in this:
that you don't *need* anything more than a dual GbE iSCSI NIC in each
SAN server.  If you'd have done that, and used straight scsi-multipath,
you'd have had perfectly even scaling across both ports this entire past
year, and plenty of headroom.

Quite frankly, after seeing the bandwidth numbers you're posting, I'd
cancel the order or send the 10 GbE gear back for a refund.  It's
absolutely unnecessary, total overkill.

Instead, ditch the bonding, go straight scsi-multipath as I recommended
last year.  Use two ports of each quad NIC for iSCSI.  Export each LUN
on one port of each NIC going in a round robin fashion, wrapping back
around, while separating any "heavy hitter" LUNs, such as the file
share, on different ports.  With the remaining 2 ports on each quad HBA,
use x-over cables and connect the two SAN servers.  Configure a
balance-rr bond of these 4 ports on each server.

This configuration will yield 400 MB/s peak full duplex dedicated iSCSI
throughput at the SAN server, and 400 MB/s peak dedicated DRBD
throughput.  Currently you have 800 MB/s shared one way for both iSCSI
and DRBD, but only 100 MB/s the other way.

This will also give each Xen client 200 MB/s peak full duplex iSCSI
throughput, about 8x what they're currently using.

This is pretty much exactly what I recommended a year ago.  You rejected
it because in your mind it lacked "symmetry", as IO wasn't
"automatically" balanced.  Well, your way has proven that "automatic
balancing" doesn't work.  And it's proven a 6:1 imbalance for Xen writes
to SAN, all through one SAN port.  My proposed multipath configuration
gets you full bandwidth on all links both ways, 4 write links and peak
200 MB/s write per Xen host.  Which is again about 8x what your iSCSI
clients actually use.

And it costs nothing but your time.

> traffic (inbound to san1) is 0 on 5 of the links, and the large majority
> of the traffic is on one link (peaking at 40Mbps yesterday during normal
> work day load, and 75Mbps during backup load last night). The other two
> links with load peaked at 18Mbps yesterday, and didn't do very much load
> during the backups being run last night (actually, basically zero).
> Today's peak so far for these two lines is 30Mbps, and the single line
> peak is 30Mbps, all three at the same time.

Except for the fact that the SAN boxen are taking all the Xen outbound
down a single port of 8.  This is due to the ARP problem with
balance-alb receive load balancing I previously described.

> One issue I have is that I don't necessarily know which physical machine
> was hosting which VM at what time, although I know I always put the
> DC/SMB server on the same physical box. So this makes it more difficult
> to match the "user" lan traffic with the VM, though the other graphs
> above from the hypervisor should be accurate for network traffic anyway.
> Also, the MRTG graphs are only every 5 minutes, while the hypervisor
> based graphs are 1 minute averages, so MRTG is a lot "coarser".

That's not critical because you know where the DC VM is.  And we know
that network load isn't the issue, unless you have a bad/marginal NIC.

>> Given that you've had continuous problems with this particular mini
>> datacenter, and the fact that you don't document problems in order to
>> track them, you need to instrument everything you can.  Then when
>> problems arise you can look at the data and have a pretty good idea of
>> where the problems are.  Munin is pretty decent for collecting most
>> Linux metrics, bare metal and guest, and it's free:
>>
>> http://munin-monitoring.org/
>>
>> It may help identify problem periods based on array throughput, NIC
>> throughput, errors, etc.
> 
> Thanks, I'll take a look at installing it, will probably start with my
> desktop pc, and then extend to san2 and one of the hypervisor boxes,
> before extending to san1 and the rest. I'm not sure where I'll put the
> "master" node, or how much it will overlap with the existing stats I'm
> collecting, but it certainly promises to help find performance issues....

Munin master (debian package munin-common) is installed on a system with
a web server which provides the munin interface and graphs.  Munin 1.4
worked great on lighttpd.  I tried 2.0 and never got it working.  Last I
knew it required Apache because that's the only platform they developed
it for.  That was over a year ago so it may work with lighttpd now,
maybe nginx and others.

munin-node is a tiny daemon that runs on each Linux host to be
monitored.  It collects the data and sends it to the munin master.

...
>>> Also, copying from a smb share on a
>>> different windows 2008 VM (basically idle and unused) showed equally bad
>>> performance copying to my desktop (linux), etc.

Define "equally bad" in this context.  All of the Realtek GbE NICs I've
used have topped out at ~35 MB/s from Windows to Windows via SMB shares,
and it wasn't consistently that high.  It would jump from 12 to 35, to
22.5, to 28, to 12, etc.  This in bare metal.  Surely it's worth in a
VM.  It you got less than 10MB/s for the entire copy I'd say something
is wrong, other than the Realtek NICs being crap to begin with.

>>> So, essentially the current plans are:
>>> Install the Intel 10Gb network cards
>>> Replace the existing 1Gbps crossover connection with one 10Gbps
>>> connection
>>> Replace the existing 8 x 1Gbps connections with 1 x 10Gbps connection
>>
>> You can't fix these problems by throwing bigger hardware at them.
>> Switching to 10 GbE links might fix your current "bad performance" by
>> eliminating the ALB bonds, or by eliminating ports that are currently
>> problematic but unknown, see link speed/duplex below.  However, as I
>> recommended when you acquired the quad port NICs, you shouldn't have
>> used bonds in the first place.  Linux bonding relies heavily on ARP
>> negotiation and the assumption that the switch properly updates its MAC
>> routing tables and in a timely manner.  It also relies on the bond
>> interfaces having a higher routing priority than all the slaves, or that
>> the slaves have no route configured.  You probably never checked nor
>> ensured this when you setup your bonding.
> 
> I'm not using bonding on the hypervisors, they are using multipath to

Yes, I knew that.

> make use of each link. I'm using bonding on the san1/san2 server only,

And I recalled this as well.

> which is configured as:
> iface bond0 inet static
>     address x.x.16.1
>     netmask 255.255.255.0
>     slaves eth2 eth3 eth4 eth5 eth6 eth7 eth8 eth9
>>>>     bond-mode balance-alb

Ditch the 10 GbE idea.  Ditch alb.  Go straight scsi-multipath.

>     bond-miimon 100
>     bond-updelay 200

>>>>     mtu 9000

If you have jumbos enabled on the user network, with so many cheap
Realtek NICs, I'd think this may be involved in your stability issues.
If enabled, disable it for a couple of months.  Both throughput and
stability may increase.  Cheap Ethernet ASICs and drives often don't
like jumbo frames too well.

> This is slightly different to what you suggested, from memory, you
> suggested I should have two bond groups on each of san1/san2 of 4

I believe what I originally suggested was 2 Intel GbE iSCSI ports on the
SAN server, 2 on each Xen client, and two on each server for dedicated
DRBD traffic.  I suggested you to use two small switches with each host
port connected to a different switch as this allows balance-rr to fully
utilize both ports in both directions to max bandwidth.  You shot this
suggestion down because you had already ordered a new 48? port switch,
and you were convinced you needed more aggregate Ethernet bandwidth at
the SAN servers, not simply equal to that of one Xen client (but as it
turns out, the bandwidth data you provided in this thread shows a peak
of 75 MB/s, in which case 2 ports on the SAN server would have been more
than sufficient, with one simply for redundancy)

So I then suggested two quad NICs in the servers, and assisted you as
you tried a bunch of different bond modes and scsi-multipath combos.
The last recommendation I made due to difficulties you had with bonding
was to simply used straight scsi-multipath, exporting your LUNs
appropriately across the 8 ports, as this would have guaranteed a peak
of 200 MB/s full duplex per Xen client.  You then made the beginner's
argument that two Xens could each do a big transfer and each only get
half bandwidth, or 50 MB/s per port.  You tried exporting all LUNs on
all ports and doing multipath across all SAN ports to achieve what you
considered "balanced IO".  I don't recall if that worked or not.  Eve if
it did, you needed bonding for the DRBD links.  It was at that opint
that you decided to create bonds so DRBD would get multiple links, and
you exported your iSCSI LUNs atop the bonds for the Xen hosts.

I still don't know exactly what your current setup is.  I thought it was
2x 4 port alb bonds.  But below you seem to indicate it's something
else.  What is the current bonding/iSCSI setup on the servers?

> connections each, and each physical server should have one ethernet
> connection to each bond group. Changing that would probably improve the
> problem mentioned above with almost all the inbound (san1) traffic using
> the one link.

Ditching bonding for pure multipath is the solution.  Always has been.
You didn't like the idea before because it's not "symmetrical" in your
mind.  It doesn't have to be.  Just do it.  Afterward maybe you'll begin
to understand why it works so well.

> None of the slave interfaces are configured at all, so I doubt there is
> any issue with routing or interface priority.

Just one:  ARP negotiation.

>> It's possible that due to bonding issues that all of your SAN1 outbound
>> iSCSI packets are going out only two of the 8 ports, and it's possible
>> that all the inbound traffic is hitting a single port.
> It looks like (from the switch mrtg graphs) that outbound balancing is
> working properly, but inbound balancing is very poor, almost just a
> single link.

See directly above.  You can read the primer again, and again, and
again, as I did, still without fully understanding what needs to be
configured to make the ARP negotiation work.  Or, again, just switch to
pure multipath and you're done.

>>   It's also
>> possible that the master link in either bond may have dropped link
>> intermittently, dropped link speed to 100 or 10, or is bouncing up and
>> down due to a cable or switch issue, or may have switched from full to
>> half duplex.  Without some kind of monitoring such as Munin setup you
>> simply won't know this without manually looking at the link and TX/RX
>> statistic for every port with ifconfig and ethtool, which, at this point
>> is a good idea.  But, if any links are flapping up and down at irregular
>> intervals, note they may all show 1000 FDX when you check manually with
>> ethtool, even though they're dropping link on occasion.
> 
> The switch logs don't show any links dropped or changing speed since at
> least Monday night when I last rebooted one of the san servers. The
> switch also logs via syslog to the mail server, logs there don't show
> any unexpected link drops or speed changes etc. 

How about dropped frames, CRC errors, etc?

...
>> Last I recall you had setup two ALB bonds of 4 ports each, with the
>> multipath mappings of LUNS atop the bonds--against my recommendation of
>> using straight multipath without bonding.  That would have probably
>> avoided some of your problems.
> 
> I might be wrong, but from memory we had agreed that using 2 groups of 4
> bonded channels on the SAN1/2 side was the best option. I never did get
> around to doing that, because it seemed to be working well enough as is,
> and I didn't want to keep changing things (ie, breaking things and then
> trying to fix them again). Things were never really fully resolved, they
> were just good enough, but the mess on Friday means that now things need
> to be pretty much perfect. I think replacing this group of 8 bonded
> connections with a single 10Gbps connection should solve this even
> better than using 2 groups of 4 bonds, or any other option. I assume I

My 20+ years of experience disagrees.  You may have heard the drum I've
been banging for a while in this reply, the pure scsi-multipath drum.
Ditch bonds, do that, and all your iSCSI IO bandwidth issues are
resolved.  Every Xen host will get 200 MB/s full duplex.  Your
statistics say your peak throughput is 75 MB/s for all hosts aggregate.
 So it's really hard to screw up the LUN assignments so bad it would
make performance worse than it is now.

> will keep the 2 multipath connections on the physical boxes the same as
> current, simply removing the bond group on the san, configuring the new
> 10Gbps port with the same IP/netmask as previous, and everything should
> work nicely.

Again, you're hitting 75 MB/s peak with your real workloads.  A single
GbE is sufficient.  You currently have dual 200 MB/s hardware in the Xen
hosts, and 800 MB/s in the servers.  Why do you need 1 GB/s links?  You
don't.  You simply need to reconfigure what you have so it works
properly.  And it's free.

BTW, what's the peak aggregate data rate on the DRBD links?

>> Anyway, switching to 10 GbE should solve all of this as you'll have a
>> single interface for iSCSI traffic at the server, no bond problems to
>> deal with, and 200 MB/s more peak potential bandwidth to boot, even
>> though you'll never use half of it, and then only in short bursts.
> 
> Agreed.

Seeing your bandwidth numbers for the first time changed my mind.  You'd
be insane to spend any money on hardware to fix this, when you already
have quality gear and over 10 times the throughput you need.

I should have asked you for numbers earlier.  Since you hadn't offered
them I assumed you weren't gathering that info.

...
> Done, I definitely couldn't rely on DNS being provided by the VM as you
> noted. Generally Linux machines (that I configure) don't rely on DNS for
> anything, I don't change IP addresses on servers enough to make that
> even slightly useful (would anyone?).

At least you're doing something right. ;) (heavily tongue in cheek)

...
> OK, so I'll just add the dual port 10Gbps network card, and remove the 2
> quad port 1Gbps cards from each server. That will mean there is only two
> cards installed in each san system. I really don't think it is
> worthwhile right now, but I may re-use these cards by installing one
> quad port card into 4 of the physical machines, and use 2 x dual port
> cards in the other 4, and increase the iSCSI to 4 multipath connections
> on each physical. That is all in the future though, for now I just want
> to obtain at least 50MB/s (minimum, I should expect at least 100MB/s)
> performance for the VM's, consistently....

I don't get the disconnect here.  You want 50 MB/s minimum, you already
show a max of 75 MB/s in your stats, you desire 100 MB/s capability.
Yet you already have 200 MB/s hardware, and you're talking about buying
1 GB/s hardware, which is ten times your requirement...

...
>> If you go ahead and replace the server mobos, I'm buying a ticket,
>> flying literally half way around the world, just to plant my boot in
>> your arse. ;)

I should add the 10 GbE parts in here as well.  Your numbers confirming
what I suspected back when you went 2x quad GbE, your needs aren't
anywhere near this level of throughput.

> I'll save you most of the trouble, I'll be in the USA next month :)
> however, I promise I won't get any new motherboards for now :)
> 
>>> Thanks again for all your advice, much appreciated.
>> You're welcome.  And you're lucky I'm not billing you my hourly rate. :)
>>
>> Believe it or not, I've spent considerable time both this year and last
>> digging up specs on your gear, doing Windows server instability
>> research, bonding configuration, etc, etc.  This is part of my "giving
>> back to the community".  In that respect, I can just idle until June
>> before helping anyone else. ;)
> 
> Absolutely, and I greatly appreciate it all!

Well let's hope you appreciate the advice above, and actually follow it
this time. :)  You'll be glad you did.

Cheers,

Stan

