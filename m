From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Mon, 11 Feb 2013 03:16:24 +1100
Message-ID: <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51179F09.1020503@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:

>On 2/9/2013 10:40 PM, Adam Goryachev wrote:
>
>> OK, so I changed the linux iSCSI server to 802.3ad mode, and that
>killed all networking, so I changed the switch config to use LACP, and
>then that was working again.
>
>If not LACP, what mode were the switch ports in previously?

I had them configured as a LAG, and that was in static mode. I just changed the static to LACP.
So I now have:
LAG1 ports 1,2,3,4 in LACP mode
LAG2 ports 5,6,7,8 in LACP mode

>> I then tested single physical machine network performance (just a
>simple dd if=iscsi device of=/dev/null to read a few gig of data. I had
>some interesting results. Initially, each server individually could
>read around 120MB/s, so I tried 2 at the same time, and each got
>120MB/s, so I tried three at a time, same result. Finally, testing 4 in
>parallel, two got 120MB/s and the other two got around 60MB/s.
>Eventually I worked out this:
>
>When you say "machine" above, are you referring to physical machines,
>or
>virtual machines?  Based on the 120/120/60/60 result with "4 machines",
>I'm guessing you were only using 3 physical machines, testing from two
>Windows guests on one of them.  If this is the case, the 60/60 is the
>result of the two VMs sharing one physical GbE port.

I'm referring to physical machines... This entire email is based on all VM's being shutdown during testing. I have 8 physical boxes to run the VM's on, and 2 physical boxes for the storage servers. Only one storage server is operating at one time.

>> Server    Switch port
>> 1               6
>> 2               5
>> 3               7
>> 4               7
>> 5               7
>> 6               7
>> 7               7
>> 8               6
>
>I don't follow this at all.

Server number is the 8 physical machines, switch port is the physical switch port number that the SAN server used to send the data to the physical machine.

>> So, for some reason, port 8 was never used, (unless I physically
>disconnected ports 5, 6 and 7). Also, a single port was shared for 5
>machines, resulting in around 20MB/s for each (when testing all in
>parallel).
>
>What exactly are you testing here?  To what end?

Trying to ensure:
a) all physical boxes are working at full 1Gbps speeds
b) that the LACP is working to balance the traffic across the 4 links

>> I eventually changed the iSCSI server to use xmit_hash_policy to 1
>(layer3+4) instead of layer2 hashing. This resulted in a minor
>improvement as follows:
>> Server    Switch port
>> 1               6
>> 2               5
>> 3               8
>> 4               6
>> 5               6
>> 6               6
>> 7               6
>> 8               7
>> 
>> So now, I still have 5 machines sharing a single port, but the other
>three get a full port each. I'm not sure why the balancing is so
>poor... The port number should be the same for all machines (iscsi),
>but the IP's are consecutive (x.x.x.31 - x.x.x.38).
>
>Ok, you've completely lost me.  5 hosts (machines) cannot share an
>ethernet port.  So you must be referring to 5 VMs on a single host.  In
>that case they share the ethernet bandwidth.  5 concurrent file
>operations will result in ~20MB/s each.  The fact that you're getting
>that from a Realtek 8111 is shocking.  Usually these chips suck with
>this type of workload.

Nope, I'm saying that on 5 different (specifically machines 1, 4, 5, 6, 7) physical boxes, (the xen host) if I do a dd if=/dev/disk/by-path/iscsivm1 of=/dev/null on 5 machines concurrently, then they only get 20Mbps each. If I do one at a time, I get 130Mbps, if I do two at a time, I get 60Mbps, etc... If I do the same test on machines 1, 2, 3, 8 at the same time, each gets 130Mbps 

(Note, this doesn't test the SSD speed etc since all the machines are reading the same data at the same time, so it should be all cached at the iSCSI server side)

>> Anyway, so I've configured the DC on machine 2, the three testing
>servers and two of the TS on the "shared port" machines, and the third
>TS and DB server onto the remaining machines.
>
>> Any suggestions on how to better balance the traffic would be
>appreciated!!!
>
>What type of traffic balancing are you asking for here?  Once you have
>at least two bonded ports in the physical machine on which the DC VM
>resides, and your 6 bonded links (IO server 4, DC 2) in LACP dynamic
>mode, the switch will automatically balance session traffic on those
>links.  I thought I explained this already.

The problem is that (from my understanding) LACP will balance the traffic based on the destination MAC address, by default. So the bandwidth between any two machines is limited to a single 1Gbps link. So regardless of the number of ethernet ports on the DC box, it will only ever use a max of 1Gb[s to talk to the iSCSI server.

However, if I configure Linux to use xmit_hash_policy=1 it will use the IP address and port (layer 3+4) to decide which trunk to use. It will still only use 1Gbps to talk to that IP:port combination.

>>> That said, disabling the Windows write
>>> caching on the local drives backed by the iSCSI LUNs might fix this
>as
>>> well.  It should never be left enabled in a configuration such as
>>> yours.
>> 
>> Have now done this across all the windows servers for all iSCSI
>drives, left it enabled for the RAM drive with the pagefile
>
>That setting is supposed to enables/disable the cache *CHIP* on
>physical drives.  A RAM drive doesn't have a cache chip.  Disable it just to
>keep Windows from confusing itself.  Given that all of your Windows 'hosts'
>are guest VMs, the command sent through the SCSI driver to disable the
>drive cache is intercepted by Xen and discarded anyway.
>
>I recommend disabling it so Windows doesn't confuse itself.  Windows is
>infamous for doing all manner of undocumented things.  On the off
>chance
>that having this setting enabled changes the behavior of something else
>in Windows, which is expecting a drive cache to be present and enabled
>when it in fact doesn't exist, you *need* to have it disabled for
>safety.  Undocumented behavior is why I suspect having it enabled may
>have contributed to those mysterious errors.  Give Windows enough rope
>and it will hang itself.
>
>Take away the rope.

OK, will do. Just to recap, windows is limited to 4G RAM, so the xen host is allocating 4G RAM to the windows VM, it is also passing in a virtual SCSI drive 4G in size. This virtual SCSI drive is a Linux 4G RAM drive. Windows has formatted it as a 4G drive and using it for a 4G pagefile.

Anyway, I will disable it, I doubt it will make any difference, but as you said, best to remove the rope.

>> I'm assuming that is what I have now, but I didn't do write tests so
>I can't be sure the switch will properly balance the traffic back to
>the server
>
>There is no "balancing" unless the load of two or more TCP sessions is
>sufficiently high.  I tried to explain this previously.  When LACP
>bonding is working properly, the only time you will see packet traffic
>roughly evenly distributed across the DC host's bonded ports is when
>two
>or more TS physical boxes have sustained file transfers going.  If that
>switch can monitor port traffic in real time, you'll see the balancing
>across the two ports.  You'll also see this on two ports in the IO
>server's bond group.  If you simply look at the total metrics, those
>you
>pasted here, 80-90% or more of the traffic to/from the DC box will be
>on
>only one port.  Same with the IO server.  This is by design.  It is how
>it is supposed to work.

OK, so I think this is the problem, I haven't properly explained my environment...

There are 8 physical boxes used to run Xen
Each box has iscsi configured to connect to the iSCSI server
This produces one device on the xen host /dev/sdX for each of the LV's on the SAN
However, the SAN will see all iSCSI traffic as being from a single IP:port for each xen server (a total of 8 sessions)
Regardless of the number of TS users, or simultaneous copies to/from the DC, if the DC needs to read 5 different files, it will do so from it's virtual SCSI drive that xen has provided, xen will pass those to Linux, which will pass the requests to the iSCSI software, which will send them to the SAN (from the same IP:Port), and the san will reply over the same 1Gbps link for all 5 requests. Thus, the DC has a max of 1Gbps bandwidth to talk to the DC. 

>>> Ah, here you go.  It does have port based ingress/egress rate
>limiting.
>>> So you should be able to slow down the terminal server hosts so no
>>> single one can flood the DC.  Very nice.  I wouldn't have expected
>this
>>> in this class of switch.
>> 
>> I don't know if I want to do this, as it will also limit SMB, RDP.
>etc traffic just as much.... I'll leave it for now, and perhaps come
>back to it if it is still an issue.
>
>Once you have at least two bonded ports in the DC box this shouldn't be
>necessary.  If you put 4 bonded ports in, the issue is moot as then no
>single box can flood any other single box, no matter which box we're
>talking about --TS servers, DC, IO server-- no matter how many users
>are
>doing what.  You could slap a DVD in every TS box on the network and
>start a CIFS copy to any/all shares on the DC server.  Won't skip a
>beat.

OK, thinking about this extreme example....

Assume the DC box has a 4port ethernet, and the TS boxes are limited to the existing single port ethernet.

4 TS machines are each copying 8G of data to a share on the DC
Each TS tries to send data at 1Gbps to the DC using SMB
The switch will load balance based on MAC addresses, which may potentially place more than one stream on the same physical port, but assuming best case, the DC will receive the SMB data at 4Gbps, worst case is all traffic is on a single port and receives at 1Gbps.
The DC will then write 4 streams of data to its SCSI disk (it doesn't know this is iSCSI)
The xen host of the DC VM will then write the 4 streams to the iSCSI disk (to the same destination IP:port and same MAC)
The switch will send all data to a single ethernet port of the SAN, maximum of 1Gbps

Thus, all TS boxes combined have a max write performance of 1Gbps to the SAN

> And if you configure a VLAN on that switch and enable QOS
>traffic shaping, TS sessions wouldn't slow down, as you'd reserve
> priority for RDP.  That's another thing that surprised me about this
> switch.  It's got a ton of advanced features for its class.

Sure, I could setup the QoS to prioritize the RDP traffic, then SMB traffic and then iSCSI traffic..... or are you suggesting bandwidth reservation per protocol? This will just carve the 1Gbps link speed into smaller pieces, does ensure that each protocol gets it's own bit, and none is starved, although using different networks (physical network cards/ports) would do this as well, and without reducing anything to less than 1Gbps...

>>> So, you can fix the network performance problem without expending
>any
>>> money.  You'll just have on TS host and its users bogged down when
>>> someone does a big file copy.  And if you can find a Windows policy
>to
>>> limit IO per user, you can solve it completely.
>> 
>> I'll look into this later, but this is pretty much acceptable, the
>main issue is where one machine can impact other machines.
>
>Now that you know how to configure LACP properly on the bonded ports,
>once you have a quad port NIC in the DC box this particular issue is
>solved.  As I mentioned, with a dual port NIC this problem could still
>occur if two users on two physical TS boxes both do a big file copy. 
>If
>this was my project, I wouldn't do anything at this point but the quad
>port card as it eliminates all doubt.  The extra $120 USD would
>guarantee I didn't have this issue occur again.  But that's me.

As mentioned, I don;t see how this will be enough... The DC box with quad port will only use one of the four ports to talk to the SAN, since the switch will only send data form that MAC address to that MAC address down a single port.

Unless I use RR on both the SAN and the DC, and both have 4 port cards. Then the SAN server will still flood the TS boxes, but that shouldn't matter, and the DC box can consume 100% of the bandwidth to the SAN, which will limit performance of the rest of the TS/DB servers.....

>>> That said, I'd still get two or 4 bonded ports into that DC share
>>> server to speed things up for everyone.
>> 
>> OK, I'll need to think about this one carefully. I wanted all the 8
>machines to be identical so that we can do live migration of the
>virtual machines, and also if physical hardware fails, then it is easy
>to reboot a VM on another physical host. If I add specialised hardware,
>then it requires the VM to run on that host, (well, would still work on
>another host with reduced performance, which is somewhat acceptable,
>but not preferable since might end up trying to fix a hardware failure
>and a performance issue at the same time, or other random issues
>related to the reduced performance.
>
>I've been wondering since the beginning of this thread why you didn't
>simply stick Samba on the IO server, format the LVM slice with XFS, and
>serve CIFS shares directly.  You'd have had none of these problems, but
>for the rr bonding mode.  File serving would simply scream.  The DC
>could be a DC with a single NIC, same as the other boxen.  That's the
>only way I'd have done this setup.  And the load of the DC VM is low
>enough I'd have put it on one of the TS boxen and saved the cost of one
>box.

To be honest, I wanted to move the DC and file server to a Linux VM, since at the time it was only an NT box, but I did need to upgrade to provide proper AD for one new machine, and I didn't want to upgrade to the new samba just released last year... Also, I couldn't split the data shares from the DC since that would change the UNC path for the shares, and that would be a complicated job to fix everything that breaks.... This is an old environment with plenty of legacy apps. The reason it still ran NT was partly because nobody wanted to be responsible for breaking things. Anyway, it's upgraded to win2k now, and running in a VM, it will get upgraded to win2k3 soon, but I'm stuck working on this performance issue first...

>> OK, so apparently the motherboard on the physical machines will work
>fine with the dual or quad ethernet cards.
>Great.  This keeps your options open.
>
>> I'm not sure how this solves the problem though.
>> 
>> 1) TS user asks the DC to copy file1 from the shareA to shareA in a
>different folder
>> 2) TS user asks the DC to copy file1 from the shareA to shareB
>> 3) TS user asks the DC to copy file1 from the shareA to local drive
>C:
>> 
>> In cases 1 and 2, I assume the DC will not actually send the file
>content over SMB, it will just do the copy locally, but the DC will
>read from the SAN at single ethernet speed and write to the san  at
>single ethernet speed,  since even if the DC uses RR to send the data
>at 2x1Gbps, the switch is LACP so will forward to the iSCSI server at
>1Gbps. Hence, iSCSI is maxed out at 1Gbps... The iSCSI potentially can
>satisfy other servers if LACP is not making them share the same
>ethernet. The DC can possibly, if LACP happens to choose the second
>port, be able to maintain SMB/RDP traffic. but if LACP shares the same
>port, then the second ethernet is wasted.
>
>And now you you finally understand, I think, the limitations of
>bonding.
> To clearly spell them out, again:
>
>1.  Ethernet bonding increases throughput for multi stream workloads
>2.  Ethernet bonding does not increase the throughput of single stream
>    workloads
>3.  To increase throughput of single stream workloads a single faster
>    link is required, in this case 10GbE.

So, ignoring the SMB traffic, we are saying that iSCSI performance is workload number 2, and will not benefit from multi NIC's in each box...

>Thankfully you have a multi-user workload, the perfect fit for bonding.
>You don't need 10Gb/s for a single user.  You need multiple 1Gb/s links
>for the occasion that multiple users each need one GbE link worth of
>throughput without starving others.

I don't think so, the SMB traffic can be balanced, but the DC can still only read/write at a max of 1Gbps from the SAN....

>Have you ever owned or driven a turbocharged vehicle?  Cruising down
>the
>highway the turbo is spinning at a low idle RPM.  When you need to pass
>someone, you drop a gear and hammer the throttle.   The turbo spins up
>from 20K RPM to 160K RPM in about 1/5th of a second, adding 50-100HP to
>the engine's output.
>
>This is in essence what bonding does for you.  It kicks in the turbo
>when you need it, but leaves it at idle when you don't.  In this case
>the turbo being extra physical links in the bond.

No, but I would like to think I understand how it should work... in an ideal environment....

>> Regardless of what number of network ports are on the physical
>machines, the SAN will only send/receive at a max of 1G per machine 
>
>The IO server has 4 ports, so if you get the SSD array working as it
>should, the IO server could move up to 8Gb/s, 1Gb/s each way.
>
>> so the DC is still limited to 1G total iSCSI bandwidth. 
>
>No.  With a bonded dual port NIC, it's 2Gb/s aggregate each way.  To
>reach that requires at least two TCP session streams (or UDP).  This
>could be two users on two TS servers each doing one file copy.  Or it
>could be a combination of 100 streams from 100 users all doing large or
>small CIFS transfers concurrently.  The more streams the better, if you
>want to get both links into play.

Nope, since there is a max of 8 streams to the iSCSI server, and they are being balanced really badly with 5 out of 8 on the same physical port...

>You can test this easily yourself once you get a multiport NIC in the
>DC box.  SSH into a Xen console on the DC box and launch iftop.
>Then log into two TS servers and start two large file copies from one
> DC share to another.  This will saturate both Tx/Rx on both NIC ports.
>Watch iftop.
>You should see pretty close to 4Gb/s throughput, 2Gb/s out and 2Gb/s
>in.

Again, assuming a quad port NIC in the DC
The two TS boxes ask to read a file from SMB
The DC box asks to read two files from disk
The Xen box asks to read two files (just random block) from the iSCSI
The iSCSI replies with the data
The xen box passes up the layer
The DC box asks to write the data back to disk
The xen box passes the data to iSCSI
The iSCSI receives the data and writes to disk

The problem is there is only a single stream for the iscsi replies with the data and the iscsi receives the data, so both are limited to 1Gbps (a total of 2Gbps full duplex) bandwidth on both the DC and the iSCSI regardless of the number of ports each has.

>> If I use RR on the DC, then it has 2G write and only 1G read
>performance, which seems strange.
>
>Don't use RR.  Recall the problem RR on the IO server's 4 ports caused?
> Those 1.2 million pause frames being kicked back by the switch?  This
>was due to the 4:1 b/w gap between the IO server NICs and the DC server
>NIC.  If you configure balance-rr on the DC Xen host you'll get the
>same
>problem talking to the TS boxen with single NICs.

Only when the TS is reading from SMB will the DC flood it... or when the TS is reading from iSCSI will it get flooded also.

However, using different networks, where the DC has only 1Gbps for the SMB network and 4Gbps for iSCSI will solve the first half of that problem, and prevent the second half. In fact, if all xen hosts had 4 port ethernet, then there is no flooding anywhere, except that each box could consume 100% of the SAN bandwidth, though I think TCP is pretty good at reducing the speed of the first connection until they are about equal...

>> The more I think about this, the worse it seems to get... It almost
>seems I should do this:
>
>Once you understand ethernet bonding a little better, how the different
>modes work, the capabilities and limitations of each, you'll realize
>things are getting better, not worse.
>
>> 1) iSCSI uses RR and switch uses LAG (LACP)
>> 2) All physical machines have a dual ethernet and use RR, and the
>switch uses LAG (LACP)
>> 3) On the iSCSI server, I configure some sort of bandwidth shaping,
>so that the DC gets 2Gbps, and all other machines get 1Gbps
>> 4) On the physical machines, I configure some sort of bandwidth
>shaping so that all VM's other than the DC get limited to 1Gbps
>> 
>> This seems like a horrible, disgusting hack, and I would really hate
>myself for trying to implement it, and I don't know that Linux will be
>good at limiting speeds this fast including CPU overhead concerns, etc
>> 
>> I'm in a mess here, and not sure any of this makes sense...
>
>You're moving in the wrong direction, fast.  Must be lack of sleep or
>something. ;)

I won't deny that... though I've just had about 6 hours sleep, and it's only 3am.. will go back to sleep after this email to ensure I'm ready for a busy day tomorrow.

>> How about:
>> 1) Add dual port ethernet to each physical box
>> 2) Use the dual port ethernet in RR to connect to the iSCSI
>> 3) Use the onboard ethernet for the user network
>> 4) Configure the iSCSI server in RR again
>
>/rolls eyes
>
>You don't seem to be getting this...
>
>> This means the TS and random desktop's get a full 1Gbps for SMB
>access, the same as they had when it was a physical machine
>> The DC gets a full 2Gbps access to the iSCSI server, the iSCSI server
>might send/flood the link, but I assume since there is only iSCSI
>traffic, we don't care.
>> The TS can also do 2Gbps to the iSCSI server, but again this is OK
>because the iSCSI has 4Gbps available
>> If a user copies a large file from the DC to local drive, it floods
>the 1G user LAN with SMB, which uses only 1Gbps on the iSCSI LAN for
>the DC, and 1Gbps for the TS on the iSCSI LAN (total 2Gbps on the iSCSI
>SAN).
>> 
>> To make this work, I need 8 x dual port cards, or in reality, 2 x
>4port cards plus 4 x 2port cards (putting 4port cards into the san, and
>moving existing 2port cards), then I need a 48 port switch to connect
>everything up, and then I'm finished.
>> 
>> Add SATA card to the SAN, and I'm laughing.... sure, it's a chunk of
>new hardware, but it just doesn't seem to work right any other way I
>think about it.
>
>No, no, no, no, no.  No....
>
>> So, purchase list becomes:
>> 2 x 4port ethernet card $450 each
>> 4 x 2port ethernet card $161 each
>> 1 x 48 port switch (any suggestions?) $600
>> 2 x LSI HBA  $780
>> Total Cost: $2924
>> 
>>> Again, you have all the network hardware you need, so this is
>>> completely unnecessary.  You just need to get what you have
>>> configured correctly.
>> 
>>> Everything above should be even more helpful.  My apologies for not
>>> having precise LACP insight in my previous post.  It's been quite a
>>> while and I was rusty, and didn't have time to refresh my knowledge
>>> base before the previous post.
>> 
>> I don't see how LACP will make it better, well, it will stop sending
>pause commands, but other than that, it seems to limit the bandwidth to
>even less than 1Gbps. The question was asked if it would be worthwhile
>to just upgrade to 10Gbps network for all machines.... I haven't looked
>at costing on that option, but I assume it is really just the same
>problem anyway, either speeds are unbalanced if server has more
>bandwidth, or speeds are balanced if server has equal bandwidth/limited
>balancing with LACP asiide)
>
>Please re-read my previous long explanation email, and what I wrote
>above.  This is so so simple...
>
>Assuming you don't put Samba on the IO server which will fix all of
>this
>with one silver bullet, the other silver bullet is to stick a quad port
>NIC in the DC server, then configure it, the IO server, and the bonded
>switch ports for LACP Dynamic mode, AND YOU'RE DONE with the networking
>issues.

Potentially I could run xen on the storage server, but I really wanted to have clearly defined storage servers and VM servers... They run different Linux kernels/etc, storage server has less RAM, etc.... Though yes, I suppose that could work. Equally, I don't/can't use samba on the storage server due to the change in path for the data storage... This just seems like replacing the current challenging task with another...

>Then all you have left straightening out the disk IO performance on the
>IO server.
>
>> BTW, reading at
>www.kernel.org/doc/Documentation/networking/bonding.txt in chapter
>12.1.1 I think maybe balance-alb might be a better solution? It sounds
>like it would at least do a better job at avoiding 5 machines being on
>the same link .... 
>
>"It sounds like it would at least do a better job at avoiding 5
>machines
>being on the same link .... "
>
>The "5 machines" on one link are 5 VMs on a host with one NIC.  Bonding
>doesn't exist on single NIC ports.  You've totally lost me here...

Nope, they are 5 ethernet links, 5 physical boxes.... sharing 4 ethernet link at the storage server side. Except all the data only uses one out of the 4 ports.

>> I will suggest the HBA anyway, might as well improve that now anyway,
>and it also adds options for future expansion (up to 8 x SSD's). 
>
>I usually suggest a real SAS/SATA HBA right away, but given what you
>said about the client's state of mind, troubleshooting the current
>stuff
>made more sense.
>
>> I can't find that exact one, my supplier has suggested the LSI SAS
>9211-8i pack for $390 or the LSI MegaRAID SAS 9240-8i pack for $429, is
>one of these equivalent/comparable?
>
>9211-8i pack for $390  -- this should be the one with cables.  Confirm
>first as you'll need to order 2 breakout cables if it doesn't come with
>them.  LSI calls it "kit" instead of "pack".  This is one of the two
>models I mentioned, good HBA.  The other was the 9207-8i which has
>double the IOPS.  Your vendor doesn't offer it?  Wow...

>Neither is a great candidate for SSDs, but better than all competing
>brands in this class.  The 9207-8i is the HBA you really want for SSDs.
>The chip on it is 3 generations newer than these two, and it has double
>the IOPS.  It's a PCIe 3.0 card, LSI's newest HBA.  As per PCIe spec it
>works in 2.0 and 1.0 slots as well.  I think your Intel server board is
>2.0.  It's only $40 USD more over here.  If you get up to 8 of those
>SSDs you'll really want to have this in the box instead of the 9211-8i
>which won't be able to keep up.

I'll push again for the 9207-8i, I was asking the question of my supplier on a Saturday, which happened to also be Chinese New Year Eve.... so hopefully Monday will allow them to search the chain more easily.... 

>> When doing the above dd tests, I noticed one machine would show
>2.6GB/s for the second or subsequent reads (ie, cached) while all the
>other machines would show consistent read speeds equivalent to uncached
>speeds. If this one machine had to read large enough data (more than
>RAM) then it dropped back to normal expected uncached speeds. I worked
>out this machine I had experimented with installing multipath-tools, so
>I installed this on all other machines, and hopefully it will allow
>improved performance through caching of the iSCSI devices.
>
>The boxes have a single NIC.  If MS multipath increases performance
>it's because of another undocumented feature(bug).  You can't multipath
>down a single ethernet link.

No, this is linux multipath... the iSCSI is running at the Linux layer... all windows VM's think they are talking to normal physical SCSI drives.
Yes, linux multipath still only has a single path to the server, but the reason I was originally investigating is that it apparently provided better resilience by not timing out and failing requests. In the end, I found the right parameter to tune for the standard iscsi driver in Linux, and tuned that instead. Now I see that multipath also somehow adds caching at the linux layer, so by installing that across all physical boxes, cached iSCSI reads should be a lot faster. Since all the TS boxes only have 100G drives, half of that is free space, and the physical boxes have about 10G free RAM, I can cache about 20% of the HDD. The DC reduces this to about 7% because it has 300G data drive, about 50% full, but has more spare RAM (because it doesn't get the 4G RAM drive for the pagefile)

So, it should improve read performance (for cached reads anyway)

>> I haven't done anything with the partitions as yet, but are you
>basically suggesting the following:
>> 1) Make sure the primary and secondary storage servers are in sync
>and running
>> 2) Remove one SSD from the RAID5, delete the partition, clear the
>superblock/etc
>> 3) Add the same SSD back as /dev/sdx instead of /dev/sdx1
>> 4) Wait for sync
>> 5) Go to 2 with the next SSD etc
>
>No.  Simply execute 'fdisk -lu /dev/sdX' for each SSD and post the
>output.  The critical part is to make sure the partitions start at the
>first sector, and if they don't they should start at a sector number
>divisible by either the physical sector size or the erase block size.
>I'm not sure what the erase block size is for these Intel SSDs.
 
Disk /dev/sdb: 480 GB, 480101368320 bytes
255 heads, 63 sectors/track, 58369 cylinders, total 937697985 sectors
Units = sectors of 1 * 512 = 512 bytes
 
   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63   931769999   465884968   fd  Lnx RAID auto

All drives are identically partitioned....
So, the start value should be 1 instead of 63? or should I just get rid of the partitions and use the raw disks as raid members?

The one thing partitioning added was to over-provision and leave a small amount of space at the end of each drive unallocated.... but I don't think that is as important given the comments about that on this list....

>> This would move everything to the beginning of the disk by a small
>amount, but not change anything relatively regarding DRBD/LVM/etc .... 
>
>Oh, ok.  So you already know you created the partitions starting some
>number of sectors after the start of the driver.  If they don't start
>at a sector number described above, that would explain at least some of
>the apparently low block IO performance.
>
>> Would I then need to do further tests to see if I need to do
>something more to move DRBD/LVM to the correct offset to ensure
>alignment? How would I test if that is needed?
>
>Might need to get Neil or Phil, somebody else, involved here.  I'm not
>sure if you'd want to do this on the fly with multiple md rebuilds, or
>if you'd need to blow away the array and start over.  They sit atop md
>and its stripe parameters won't change, so there's probably nothing
>needed to be done with them.

I don't mind multiple rebuilds, since even with a failure during a rebuild, I will have all data on the secondary storage server. Of course I would do this after hours though....

>>>>> Keep us posted.
>>>>
>>>> Will do, I'll have to price up the above options, and get approval
>>> for
>>>> purchase, and then will take a few days to get it all in
>place/etc...
>>>
>>> Given the temperature under the collar of the client, I'd simply
>spend
>>> on adding the 2 bonded ports to the DC box, make all of the LACP
>>> changes, and straighten out alignment/etc issues on the SSDs, md
>stripe
>>> cache, etc.  This will make substantial gains.  Once the client sees
>>> the
>>> positive results, then recommend the HBA for even better
>performance.
>>> Remember, Intel's 520 SSD data shows nearly double the performance
>>> using
>>> SATA3 vs SATA2.  Once you have alignment and md tuning squared away,
>>> moving to the LSI should nearly double your block throughput.
>> 
>> I;d prefer to do everything at once, then they will only pay once,
>and they should see a massive improvement in one jump. Smaller
>incremental improvement is harder for them to see..... Also, the HBA is
>not so expensive, I always assumed they were at least double or more in
>price....
>
>Agreed.  I must have misunderstood the level of, ahem, discontent of
>the
>client.  WRT to the HBAs, you were probably thinking of the full up LSI
>RAID cards, which run ~$350-1400 USD.
>
>> Apologies if the above is 'confused', but I am :)
>
>Hopefully I helped clear things up a bit here.
>
>> PS, was going to move one of the dual port cards from the secondary
>san to the DC machine, but haven't yet since I don't have enough switch
>ports, and now I'm really unsure whether what I have done will be an
>improvement anyway. Will find out tomorrow....
>
>I wasn't aware you were low on Cu ports.

Actually, after driving in (on a sunday) to do this, and not doing it, and now after some sleep, I realise I was wrong. I was MOVING 2 ports from the secondary/idle SAN to a machine. In fact, this would have freed one port.

ie:
remove two ports from san2
remove the single ethernet from DC box
add two ports to DC box

Ooops, amazing what some sleep can do for this...

>> Summary of changes (more for my own reference in case I need to undo
>it tomorrow):
>> 1) disable disk cache on all windows machines
>> 2) san1/2 convert from balance-rr to 802.3ad and add
>xmit_hash_policy=1
>> 3) change switch LAG from Static to LACP
>> 4) install multipath-tools on all physical machines (no config, just
>a reboot)
>
>Hmm... #4  On machines with single NIC ports multipath will do nothing
>good.  On machines with multiple physical interfaces that have been
>bonded, you only have one path, so again, nothing good will arise.
>Maybe you know something here I don't.

All I know is that it seemed to allow Linux to cache the iSCSI reads, which I assume will improve performance by reducing network traffic and load on the SAN...

>Hope things start falling into place for ya.

Well, back to sleep now, but I will find out in 4 hours more when they all get to work whether it is better, worse, or the same.... I'm hoping for a little better since we have:
1) removed the pause at the network layer
2) reduced the iSCSI traffic to a max of 1Gbps, which still floods the single 1Gbps on the DC, but not as badly (ie, can still flood out other SMB traffic, but not as badly I think
3) added iSCSI read caches at the xen hosts

The question remaining will be how this impacts on the TS boxes for access to their local C: data.

So, given the above, would you still suggest only adding a 4port ethernet to the DC box configured with LACP, or should I really look at something else.

1) Adding dual port or quad port to all xen boxes, separate the SAN tarffic from the rest
2) Upgrading to 10G network cards, and maybe 2 x 10G on the SAN
3) Both options will include the LSI HBA anyway

Thanks,
Adam


Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
