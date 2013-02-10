From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Sun, 10 Feb 2013 07:22:17 -0600
Message-ID: <51179F09.1020503@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/9/2013 10:40 PM, Adam Goryachev wrote:

> OK, so I changed the linux iSCSI server to 802.3ad mode, and that killed all networking, so I changed the switch config to use LACP, and then that was working again.

If not LACP, what mode were the switch ports in previously?

> I then tested single physical machine network performance (just a simple dd if=iscsi device of=/dev/null to read a few gig of data. I had some interesting results. Initially, each server individually could read around 120MB/s, so I tried 2 at the same time, and each got 120MB/s, so I tried three at a time, same result. Finally, testing 4 in parallel, two got 120MB/s and the other two got around 60MB/s. Eventually I worked out this:

When you say "machine" above, are you referring to physical machines, or
virtual machines?  Based on the 120/120/60/60 result with "4 machines",
I'm guessing you were only using 3 physical machines, testing from two
Windows guests on one of them.  If this is the case, the 60/60 is the
result of the two VMs sharing one physical GbE port.

> Server    Switch port
> 1               6
> 2               5
> 3               7
> 4               7
> 5               7
> 6               7
> 7               7
> 8               6

I don't follow this at all.

> So, for some reason, port 8 was never used, (unless I physically disconnected ports 5, 6 and 7). Also, a single port was shared for 5 machines, resulting in around 20MB/s for each (when testing all in parallel).

What exactly are you testing here?  To what end?

> I eventually changed the iSCSI server to use xmit_hash_policy to 1 (layer3+4) instead of layer2 hashing. This resulted in a minor improvement as follows:
> Server    Switch port
> 1               6
> 2               5
> 3               8
> 4               6
> 5               6
> 6               6
> 7               6
> 8               7
> 
> So now, I still have 5 machines sharing a single port, but the other three get a full port each. I'm not sure why the balancing is so poor... The port number should be the same for all machines (iscsi), but the IP's are consecutive (x.x.x.31 - x.x.x.38).

Ok, you've completely lost me.  5 hosts (machines) cannot share an
ethernet port.  So you must be referring to 5 VMs on a single host.  In
that case they share the ethernet bandwidth.  5 concurrent file
operations will result in ~20MB/s each.  The fact that you're getting
that from a Realtek 8111 is shocking.  Usually these chips suck with
this type of workload.

> Anyway, so I've configured the DC on machine 2, the three testing servers and two of the TS on the "shared port" machines, and the third TS and DB server onto the remaining machines.

> Any suggestions on how to better balance the traffic would be appreciated!!!

What type of traffic balancing are you asking for here?  Once you have
at least two bonded ports in the physical machine on which the DC VM
resides, and your 6 bonded links (IO server 4, DC 2) in LACP dynamic
mode, the switch will automatically balance session traffic on those
links.  I thought I explained this already.

>> That said, disabling the Windows write
>> caching on the local drives backed by the iSCSI LUNs might fix this as
>> well.  It should never be left enabled in a configuration such as
>> yours.
> 
> Have now done this across all the windows servers for all iSCSI drives, left it enabled for the RAM drive with the pagefile

That setting is supposed to enables/disable the cache *CHIP* on physical
drives.  A RAM drive doesn't have a cache chip.  Disable it just to keep
Windows from confusing itself.  Given that all of your Windows 'hosts'
are guest VMs, the command sent through the SCSI driver to disable the
drive cache is intercepted by Xen and discarded anyway.

I recommend disabling it so Windows doesn't confuse itself.  Windows is
infamous for doing all manner of undocumented things.  On the off chance
that having this setting enabled changes the behavior of something else
in Windows, which is expecting a drive cache to be present and enabled
when it in fact doesn't exist, you *need* to have it disabled for
safety.  Undocumented behavior is why I suspect having it enabled may
have contributed to those mysterious errors.  Give Windows enough rope
and it will hang itself.

Take away the rope.

> I'm assuming that is what I have now, but I didn't do write tests so I can't be sure the switch will properly balance the traffic back to the server

There is no "balancing" unless the load of two or more TCP sessions is
sufficiently high.  I tried to explain this previously.  When LACP
bonding is working properly, the only time you will see packet traffic
roughly evenly distributed across the DC host's bonded ports is when two
or more TS physical boxes have sustained file transfers going.  If that
switch can monitor port traffic in real time, you'll see the balancing
across the two ports.  You'll also see this on two ports in the IO
server's bond group.  If you simply look at the total metrics, those you
pasted here, 80-90% or more of the traffic to/from the DC box will be on
only one port.  Same with the IO server.  This is by design.  It is how
it is supposed to work.

>> Ah, here you go.  It does have port based ingress/egress rate limiting.
>> So you should be able to slow down the terminal server hosts so no
>> single one can flood the DC.  Very nice.  I wouldn't have expected this
>> in this class of switch.
> 
> I don't know if I want to do this, as it will also limit SMB, RDP. etc traffic just as much.... I'll leave it for now, and perhaps come back to it if it is still an issue.

Once you have at least two bonded ports in the DC box this shouldn't be
necessary.  If you put 4 bonded ports in, the issue is moot as then no
single box can flood any other single box, no matter which box we're
talking about --TS servers, DC, IO server-- no matter how many users are
doing what.  You could slap a DVD in every TS box on the network and
start a CIFS copy to any/all shares on the DC server.  Won't skip a
beat.  And if you configure a VLAN on that switch and enable QOS traffic
shaping, TS sessions wouldn't slow down, as you'd reserve priority for
RDP.  That's another thing that surprised me about this switch.  It's
got a ton of advanced features for its class.

>> So, you can fix the network performance problem without expending any
>> money.  You'll just have on TS host and its users bogged down when
>> someone does a big file copy.  And if you can find a Windows policy to
>> limit IO per user, you can solve it completely.
> 
> I'll look into this later, but this is pretty much acceptable, the main issue is where one machine can impact other machines.

Now that you know how to configure LACP properly on the bonded ports,
once you have a quad port NIC in the DC box this particular issue is
solved.  As I mentioned, with a dual port NIC this problem could still
occur if two users on two physical TS boxes both do a big file copy.  If
this was my project, I wouldn't do anything at this point but the quad
port card as it eliminates all doubt.  The extra $120 USD would
guarantee I didn't have this issue occur again.  But that's me.

>> That said, I'd still get two or 4 bonded ports into that DC share
>> server to speed things up for everyone.
> 
> OK, I'll need to think about this one carefully. I wanted all the 8 machines to be identical so that we can do live migration of the virtual machines, and also if physical hardware fails, then it is easy to reboot a VM on another physical host. If I add specialised hardware, then it requires the VM to run on that host, (well, would still work on another host with reduced performance, which is somewhat acceptable, but not preferable since might end up trying to fix a hardware failure and a performance issue at the same time, or other random issues related to the reduced performance.

I've been wondering since the beginning of this thread why you didn't
simply stick Samba on the IO server, format the LVM slice with XFS, and
serve CIFS shares directly.  You'd have had none of these problems, but
for the rr bonding mode.  File serving would simply scream.  The DC
could be a DC with a single NIC, same as the other boxen.  That's the
only way I'd have done this setup.  And the load of the DC VM is low
enough I'd have put it on one of the TS boxen and saved the cost of one box.

> OK, so apparently the motherboard on the physical machines will work fine with the dual or quad ethernet cards.

Great.  This keeps your options open.

> I'm not sure how this solves the problem though.
> 
> 1) TS user asks the DC to copy file1 from the shareA to shareA in a different folder
> 2) TS user asks the DC to copy file1 from the shareA to shareB
> 3) TS user asks the DC to copy file1 from the shareA to local drive C:
> 
> In cases 1 and 2, I assume the DC will not actually send the file content over SMB, it will just do the copy locally, but the DC will read from the SAN at single ethernet speed and write to the san  at single ethernet speed,  since even if the DC uses RR to send the data at 2x1Gbps, the switch is LACP so will forward to the iSCSI server at 1Gbps. Hence, iSCSI is maxed out at 1Gbps... The iSCSI potentially can satisfy other servers if LACP is not making them share the same ethernet. The DC can possibly, if LACP happens to choose the second port, be able to maintain SMB/RDP traffic. but if LACP shares the same port, then the second ethernet is wasted.

And now you you finally understand, I think, the limitations of bonding.
 To clearly spell them out, again:

1.  Ethernet bonding increases throughput for multi stream workloads
2.  Ethernet bonding does not increase the throughput of single stream
    workloads
3.  To increase throughput of single stream workloads a single faster
    link is required, in this case 10GbE.

Thankfully you have a multi-user workload, the perfect fit for bonding.
 You don't need 10Gb/s for a single user.  You need multiple 1Gb/s links
for the occasion that multiple users each need one GbE link worth of
throughput without starving others.

Have you ever owned or driven a turbocharged vehicle?  Cruising down the
highway the turbo is spinning at a low idle RPM.  When you need to pass
someone, you drop a gear and hammer the throttle.   The turbo spins up
from 20K RPM to 160K RPM in about 1/5th of a second, adding 50-100HP to
the engine's output.

This is in essence what bonding does for you.  It kicks in the turbo
when you need it, but leaves it at idle when you don't.  In this case
the turbo being extra physical links in the bond.

> Regardless of what number of network ports are on the physical machines, the SAN will only send/receive at a max of 1G per machine 

The IO server has 4 ports, so if you get the SSD array working as it
should, the IO server could move up to 8Gb/s, 1Gb/s each way.

> so the DC is still limited to 1G total iSCSI bandwidth. 

No.  With a bonded dual port NIC, it's 2Gb/s aggregate each way.  To
reach that requires at least two TCP session streams (or UDP).  This
could be two users on two TS servers each doing one file copy.  Or it
could be a combination of 100 streams from 100 users all doing large or
small CIFS transfers concurrently.  The more streams the better, if you
want to get both links into play.

You can test this easily yourself once you get a multiport NIC in the DC
box.  SSH into a Xen console on the DC box and launch iftop.  Then log
into two TS servers and start two large file copies from one DC share to
another.  This will saturate both Tx/Rx on both NIC ports.  Watch iftop.
 You should see pretty close to 4Gb/s throughput, 2Gb/s out and 2Gb/s in.

> If I use RR on the DC, then it has 2G write and only 1G read performance, which seems strange.

Don't use RR.  Recall the problem RR on the IO server's 4 ports caused?
 Those 1.2 million pause frames being kicked back by the switch?  This
was due to the 4:1 b/w gap between the IO server NICs and the DC server
NIC.  If you configure balance-rr on the DC Xen host you'll get the same
problem talking to the TS boxen with single NICs.

> The more I think about this, the worse it seems to get... It almost seems I should do this:

Once you understand ethernet bonding a little better, how the different
modes work, the capabilities and limitations of each, you'll realize
things are getting better, not worse.

> 1) iSCSI uses RR and switch uses LAG (LACP)
> 2) All physical machines have a dual ethernet and use RR, and the switch uses LAG (LACP)
> 3) On the iSCSI server, I configure some sort of bandwidth shaping, so that the DC gets 2Gbps, and all other machines get 1Gbps
> 4) On the physical machines, I configure some sort of bandwidth shaping so that all VM's other than the DC get limited to 1Gbps
> 
> This seems like a horrible, disgusting hack, and I would really hate myself for trying to implement it, and I don't know that Linux will be good at limiting speeds this fast including CPU overhead concerns, etc
> 
> I'm in a mess here, and not sure any of this makes sense...

You're moving in the wrong direction, fast.  Must be lack of sleep or
something. ;)

> How about:
> 1) Add dual port ethernet to each physical box
> 2) Use the dual port ethernet in RR to connect to the iSCSI
> 3) Use the onboard ethernet for the user network
> 4) Configure the iSCSI server in RR again

/rolls eyes

You don't seem to be getting this...

> This means the TS and random desktop's get a full 1Gbps for SMB access, the same as they had when it was a physical machine
> The DC gets a full 2Gbps access to the iSCSI server, the iSCSI server might send/flood the link, but I assume since there is only iSCSI traffic, we don't care.
> The TS can also do 2Gbps to the iSCSI server, but again this is OK because the iSCSI has 4Gbps available
> If a user copies a large file from the DC to local drive, it floods the 1G user LAN with SMB, which uses only 1Gbps on the iSCSI LAN for the DC, and 1Gbps for the TS on the iSCSI LAN (total 2Gbps on the iSCSI SAN).
> 
> To make this work, I need 8 x dual port cards, or in reality, 2 x 4port cards plus 4 x 2port cards (putting 4port cards into the san, and moving existing 2port cards), then I need a 48 port switch to connect everything up, and then I'm finished.
> 
> Add SATA card to the SAN, and I'm laughing.... sure, it's a chunk of new hardware, but it just doesn't seem to work right any other way I think about it.

No, no, no, no, no.  No....

> So, purchase list becomes:
> 2 x 4port ethernet card $450 each
> 4 x 2port ethernet card $161 each
> 1 x 48 port switch (any suggestions?) $600
> 2 x LSI HBA  $780
> Total Cost: $2924
> 
>> Again, you have all the network hardware you need, so this is
>> completely unnecessary.  You just need to get what you have
>> configured correctly.
> 
>> Everything above should be even more helpful.  My apologies for not
>> having precise LACP insight in my previous post.  It's been quite a
>> while and I was rusty, and didn't have time to refresh my knowledge
>> base before the previous post.
> 
> I don't see how LACP will make it better, well, it will stop sending pause commands, but other than that, it seems to limit the bandwidth to even less than 1Gbps. The question was asked if it would be worthwhile to just upgrade to 10Gbps network for all machines.... I haven't looked at costing on that option, but I assume it is really just the same problem anyway, either speeds are unbalanced if server has more bandwidth, or speeds are balanced if server has equal bandwidth/limited balancing with LACP asiide)

Please re-read my previous long explanation email, and what I wrote
above.  This is so so simple...

Assuming you don't put Samba on the IO server which will fix all of this
with one silver bullet, the other silver bullet is to stick a quad port
NIC in the DC server, then configure it, the IO server, and the bonded
switch ports for LACP Dynamic mode, AND YOU'RE DONE with the networking
issues.

Then all you have left straightening out the disk IO performance on the
IO server.

> BTW, reading at www.kernel.org/doc/Documentation/networking/bonding.txt in chapter 12.1.1 I think maybe balance-alb might be a better solution? It sounds like it would at least do a better job at avoiding 5 machines being on the same link .... 

"It sounds like it would at least do a better job at avoiding 5 machines
being on the same link .... "

The "5 machines" on one link are 5 VMs on a host with one NIC.  Bonding
doesn't exist on single NIC ports.  You've totally lost me here...

> I will suggest the HBA anyway, might as well improve that now anyway, and it also adds options for future expansion (up to 8 x SSD's). 

I usually suggest a real SAS/SATA HBA right away, but given what you
said about the client's state of mind, troubleshooting the current stuff
made more sense.

> I can't find that exact one, my supplier has suggested the LSI SAS 9211-8i pack for $390 or the LSI MegaRAID SAS 9240-8i pack for $429, is one of these equivalent/comparable?

9211-8i pack for $390  -- this should be the one with cables.  Confirm
first as you'll need to order 2 breakout cables if it doesn't come with
them.  LSI calls it "kit" instead of "pack".  This is one of the two
models I mentioned, good HBA.  The other was the 9207-8i which has
double the IOPS.  Your vendor doesn't offer it?  Wow...

9240-8i --  NO.  You don't want this.  Same chip as the 9211-8i but the
ports aim up, not forward, which always sucks.  The main difference is
the 9211-8i does hardware 0,1,1E,10, whereas the 9240 add hardware
RAID5/50.  As hardware RAID cards the performance of both sucks, only
suitable for a few spinning drives in a SOHO server.  In HBA mode
they're great for md/RAID and have good performance.  So why pay $40
more for shitty hardware RAID5/50 you won't use?

Neither is a great candidate for SSDs, but better than all competing
brands in this class.  The 9207-8i is the HBA you really want for SSDs.
 The chip on it is 3 generations newer than these two, and it has double
the IOPS.  It's a PCIe 3.0 card, LSI's newest HBA.  As per PCIe spec it
works in 2.0 and 1.0 slots as well.  I think your Intel server board is
2.0.  It's only $40 USD more over here.  If you get up to 8 of those
SSDs you'll really want to have this in the box instead of the 9211-8i
which won't be able to keep up.

> When doing the above dd tests, I noticed one machine would show 2.6GB/s for the second or subsequent reads (ie, cached) while all the other machines would show consistent read speeds equivalent to uncached speeds. If this one machine had to read large enough data (more than RAM) then it dropped back to normal expected uncached speeds. I worked out this machine I had experimented with installing multipath-tools, so I installed this on all other machines, and hopefully it will allow improved performance through caching of the iSCSI devices.

The boxes have a single NIC.  If MS multipath increases performance it's
because of another undocumented feature(bug).  You can't multipath down
a single ethernet link.

> I haven't done anything with the partitions as yet, but are you basically suggesting the following:
> 1) Make sure the primary and secondary storage servers are in sync and running
> 2) Remove one SSD from the RAID5, delete the partition, clear the superblock/etc
> 3) Add the same SSD back as /dev/sdx instead of /dev/sdx1
> 4) Wait for sync
> 5) Go to 2 with the next SSD etc

No.  Simply execute 'fdisk -lu /dev/sdX' for each SSD and post the
output.  The critical part is to make sure the partitions start at the
first sector, and if they don't they should start at a sector number
divisible by either the physical sector size or the erase block size.
I'm not sure what the erase block size is for these Intel SSDs.

> This would move everything to the beginning of the disk by a small amount, but not change anything relatively regarding DRBD/LVM/etc .... 

Oh, ok.  So you already know you created the partitions starting some
number of sectors after the start of the driver.  If they don't start at
a sector number described above, that would explain at least some of the
apparently low block IO performance.

> Would I then need to do further tests to see if I need to do something more to move DRBD/LVM to the correct offset to ensure alignment? How would I test if that is needed?

Might need to get Neil or Phil, somebody else, involved here.  I'm not
sure if you'd want to do this on the fly with multiple md rebuilds, or
if you'd need to blow away the array and start over.  They sit atop md
and its stripe parameters won't change, so there's probably nothing
needed to be done with them.

>>>> Keep us posted.
>>>
>>> Will do, I'll have to price up the above options, and get approval
>> for
>>> purchase, and then will take a few days to get it all in place/etc...
>>
>> Given the temperature under the collar of the client, I'd simply spend
>> on adding the 2 bonded ports to the DC box, make all of the LACP
>> changes, and straighten out alignment/etc issues on the SSDs, md stripe
>> cache, etc.  This will make substantial gains.  Once the client sees
>> the
>> positive results, then recommend the HBA for even better performance.
>> Remember, Intel's 520 SSD data shows nearly double the performance
>> using
>> SATA3 vs SATA2.  Once you have alignment and md tuning squared away,
>> moving to the LSI should nearly double your block throughput.
> 
> I;d prefer to do everything at once, then they will only pay once, and they should see a massive improvement in one jump. Smaller incremental improvement is harder for them to see..... Also, the HBA is not so expensive, I always assumed they were at least double or more in price....

Agreed.  I must have misunderstood the level of, ahem, discontent of the
client.  WRT to the HBAs, you were probably thinking of the full up LSI
RAID cards, which run ~$350-1400 USD.

> Apologies if the above is 'confused', but I am :)

Hopefully I helped clear things up a bit here.

> PS, was going to move one of the dual port cards from the secondary san to the DC machine, but haven't yet since I don't have enough switch ports, and now I'm really unsure whether what I have done will be an improvement anyway. Will find out tomorrow....

I wasn't aware you were low on Cu ports.

> Summary of changes (more for my own reference in case I need to undo it tomorrow):
> 1) disable disk cache on all windows machines
> 2) san1/2 convert from balance-rr to 802.3ad and add xmit_hash_policy=1
> 3) change switch LAG from Static to LACP
> 4) install multipath-tools on all physical machines (no config, just a reboot)

Hmm... #4  On machines with single NIC ports multipath will do nothing
good.  On machines with multiple physical interfaces that have been
bonded, you only have one path, so again, nothing good will arise.
Maybe you know something here I don't.

Hope things start falling into place for ya.

-- 
Stan

