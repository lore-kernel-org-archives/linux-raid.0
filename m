From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sun, 10 Feb 2013 15:40:23 +1100
Message-ID: <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5115CC02.2010400@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:
>On 2/8/2013 12:44 PM, Adam Goryachev wrote:
>> On 09/02/13 04:10, Stan Hoeppner wrote:
>>>> From the switch stats, ports 5 to 8 are the bonded ports on the
>storage
>>>> server (iSCSI traffic):
>>>>
>>>> Int  PacketsRX  ErrorsRX  BroadcastRX PacketsTX  ErrorsTX 
>BroadcastTX
>>>> 5    734007958  0         110         120729310  0         0
>>>> 6    733085348  0         114         54059704   0         0
>>>> 7    734264296  0         113         45917956   0         0
>>>> 8    732964685  0         102         95655835   0         0
>>>
>>> I'm glad I asked you for this information.  This clearly shows that
>the
>>> server is performing LACP round robin fanning nearly perfectly.  It
>also
>>> shows that the bulk of the traffic coming from the W2K DC, which
>>> apparently hosts the Windows shares for TS users, is being pumped to
>the
>>> storage server over port 5, the first port in the switch's bonding
>>> group.  The switch is doing adaptive load balancing with
>transmission
>>> instead of round robin.  This is the default behavior of many
>switches
>>> and is fine.
>> 
>> Is there some method to fix this on the switch? I have configured the
>> switch that those 4 ports are a single LAG, which I assumed meant the
>> switch would be smart enough to load balance properly... Guess I
>never
>> checked that side of it though...
>
>After thinking this through more thoroughly, I realize your IO server
>may be doing broadcast aggregation and not round robin.  However, in
>either case this is bad, as it will cause out of order packets or
>duplicate packets.  Both of these are wrong for your network
>architecture and will cause problems.  RR will cause TCP packets to be
>reassembled out of sequence, causing extra overhead at the receiver,
>and
>possibly errors if not reassembled in correct order.  Broadcast will
>cause duplicate packets to arrive, at the receiver, which must discard
>them.  Both flood the receiver's switch port.

They were definitely RR before.

>The NIC ports on the IO server need to be configured as 802.3ad Dynamic
>if using the Linux bonding driver.  If you're using the Intel driver
>LACP it should be set to this as well, though the name may be
>different.
>
>Once you do you realize (for me again, as it's been a while) that any
>single session will be limited by default to a single physical link of
>the group.  LACP only gives increased bandwidth across links when
>multiple sessions are present.  This is done to preserve proper packet
>ordering per session, which is corrupted when fanning packets of a
>single session across all links. In the default Dynamic mode, you don't
>have the IO server flooding the DC with more packets than it can
>handle, because the two hosts will be communicating over the same
> link(s), no more, so bandwidth and packet volume is equal between them.
>
>So, you need to disable RR or broadcast, whichever it is currently, on
>the IO server, and switch it to Dynamic mode.  This will instantly kill
>the flooding problem, stop the switch from sending PAUSE frames to the
>IO server, and might eliminate the file/IO errors.  I'm not sure on
>this
>last one, as I've not seen enough information about the errors (or the
>actual errors themselves).

OK, so I changed the linux iSCSI server to 802.3ad mode, and that killed all networking, so I changed the switch config to use LACP, and then that was working again.
I then tested single physical machine network performance (just a simple dd if=iscsi device of=/dev/null to read a few gig of data. I had some interesting results. Initially, each server individually could read around 120MB/s, so I tried 2 at the same time, and each got 120MB/s, so I tried three at a time, same result. Finally, testing 4 in parallel, two got 120MB/s and the other two got around 60MB/s. Eventually I worked out this:

Server    Switch port
1               6
2               5
3               7
4               7
5               7
6               7
7               7
8               6

So, for some reason, port 8 was never used, (unless I physically disconnected ports 5, 6 and 7). Also, a single port was shared for 5 machines, resulting in around 20MB/s for each (when testing all in parallel).

I eventually changed the iSCSI server to use xmit_hash_policy to 1 (layer3+4) instead of layer2 hashing. This resulted in a minor improvement as follows:
Server    Switch port
1               6
2               5
3               8
4               6
5               6
6               6
7               6
8               7

So now, I still have 5 machines sharing a single port, but the other three get a full port each. I'm not sure why the balancing is so poor... The port number should be the same for all machines (iscsi), but the IP's are consecutive (x.x.x.31 - x.x.x.38).

Anyway, so I've configured the DC on machine 2, the three testing servers and two of the TS on the "shared port" machines, and the third TS and DB server onto the remaining machines.

Any suggestions on how to better balance the traffic would be appreciated!!!

>That said, disabling the Windows write
>caching on the local drives backed by the iSCSI LUNs might fix this as
>well.  It should never be left enabled in a configuration such as
>yours.

Have now done this across all the windows servers for all iSCSI drives, left it enabled for the RAM drive with the pagefile

>>>> So, traffic seems reasonably well balanced across all four links
>>> The storage server's transmit traffic is well balanced out of the
>>>NICs, but the receive traffic from the switch is imbalanced, almost
>>>3:1 between ports 5 and 7.  This is due to the switch doing ALB, and
>>>helps us diagnose the problem.
>> 
>> The switch doesn't seem to have any setting to configure ALB or RR,
>>or at least I don't know what I'm looking for.... In any case, I suppose
>>if both sides of the network have equivalent bandwidth, then it should
>>be OK....
>
>Let's see, I think you listed the switch model...  yes, GS716T-200
>
>It does stock 802.3ad static and dynamic link aggregation, dynamic by
>default it appears, so standard session based streams.  This is what
>you want.

I'm assuming that is what I have now, but I didn't do write tests so I can't be sure the switch will properly balance the traffic back to the server

>Ah, here you go.  It does have port based ingress/egress rate limiting.
> So you should be able to slow down the terminal server hosts so no
>single one can flood the DC.  Very nice.  I wouldn't have expected this
>in this class of switch.

I don't know if I want to do this, as it will also limit SMB, RDP. etc traffic just as much.... I'll leave it for now, and perhaps come back to it if it is still an issue.

>So, you can fix the network performance problem without expending any
>money.  You'll just have on TS host and its users bogged down when
>someone does a big file copy.  And if you can find a Windows policy to
>limit IO per user, you can solve it completely.

I'll look into this later, but this is pretty much acceptable, the main issue is where one machine can impact other machines.

>That said, I'd still get two or 4 bonded ports into that DC share
>server to speed things up for everyone.

OK, I'll need to think about this one carefully. I wanted all the 8 machines to be identical so that we can do live migration of the virtual machines, and also if physical hardware fails, then it is easy to reboot a VM on another physical host. If I add specialised hardware, then it requires the VM to run on that host, (well, would still work on another host with reduced performance, which is somewhat acceptable, but not preferable since might end up trying to fix a hardware failure and a performance issue at the same time, or other random issues related to the reduced performance.

>Add the 4 port to the DC if it'll work in the x16 slot, if not use two
>of the single port PCIe x1 NICs I mentioned and bond them in 802.3ad
>Dyaminc mode, same as with the IO server.  Look into Windows TS per
>user IO rate limits.  If this capability exists, limit each user to 50MB/s.
>
>And with that, you should have fixed all the network issues.  Combined
>with the changes to the IO server, you should be all squared away.

OK, so apparently the motherboard on the physical machines will work fine with the dual or quad ethernet cards.

I'm not sure how this solves the problem though.

1) TS user asks the DC to copy file1 from the shareA to shareA in a different folder
2) TS user asks the DC to copy file1 from the shareA to shareB
3) TS user asks the DC to copy file1 from the shareA to local drive C:

In cases 1 and 2, I assume the DC will not actually send the file content over SMB, it will just do the copy locally, but the DC will read from the SAN at single ethernet speed and write to the san  at single ethernet speed,  since even if the DC uses RR to send the data at 2x1Gbps, the switch is LACP so will forward to the iSCSI server at 1Gbps. Hence, iSCSI is maxed out at 1Gbps... The iSCSI potentially can satisfy other servers if LACP is not making them share the same ethernet. The DC can possibly, if LACP happens to choose the second port, be able to maintain SMB/RDP traffic. but if LACP shares the same port, then the second ethernet is wasted.

Regardless of what number of network ports are on the physical machines, the SAN will only send/receive at a max of 1G per machine, so the DC is still limited to 1G total iSCSI bandwidth. If I use RR on the DC, then it has 2G write and only 1G read performance, which seems strange.

The more I think about this, the worse it seems to get... It almost seems I should do this:
1) iSCSI uses RR and switch uses LAG (LACP)
2) All physical machines have a dual ethernet and use RR, and the switch uses LAG (LACP)
3) On the iSCSI server, I configure some sort of bandwidth shaping, so that the DC gets 2Gbps, and all other machines get 1Gbps
4) On the physical machines, I configure some sort of bandwidth shaping so that all VM's other than the DC get limited to 1Gbps

This seems like a horrible, disgusting hack, and I would really hate myself for trying to implement it, and I don't know that Linux will be good at limiting speeds this fast including CPU overhead concerns, etc

I'm in a mess here, and not sure any of this makes sense...

How about:
1) Add dual port ethernet to each physical box
2) Use the dual port ethernet in RR to connect to the iSCSI
3) Use the onboard ethernet for the user network
4) Configure the iSCSI server in RR again

This means the TS and random desktop's get a full 1Gbps for SMB access, the same as they had when it was a physical machine
The DC gets a full 2Gbps access to the iSCSI server, the iSCSI server might send/flood the link, but I assume since there is only iSCSI traffic, we don't care.
The TS can also do 2Gbps to the iSCSI server, but again this is OK because the iSCSI has 4Gbps available
If a user copies a large file from the DC to local drive, it floods the 1G user LAN with SMB, which uses only 1Gbps on the iSCSI LAN for the DC, and 1Gbps for the TS on the iSCSI LAN (total 2Gbps on the iSCSI SAN).

To make this work, I need 8 x dual port cards, or in reality, 2 x 4port cards plus 4 x 2port cards (putting 4port cards into the san, and moving existing 2port cards), then I need a 48 port switch to connect everything up, and then I'm finished.

Add SATA card to the SAN, and I'm laughing.... sure, it's a chunk of new hardware, but it just doesn't seem to work right any other way I think about it.

So, purchase list becomes:
2 x 4port ethernet card $450 each
4 x 2port ethernet card $161 each
1 x 48 port switch (any suggestions?) $600
2 x LSI HBA  $780
Total Cost: $2924

>Again, you have all the network hardware you need, so this is
>completely unnecessary.  You just need to get what you have
>configured correctly.

>Everything above should be even more helpful.  My apologies for not
>having precise LACP insight in my previous post.  It's been quite a
>while and I was rusty, and didn't have time to refresh my knowledge
>base before the previous post.

I don't see how LACP will make it better, well, it will stop sending pause commands, but other than that, it seems to limit the bandwidth to even less than 1Gbps. The question was asked if it would be worthwhile to just upgrade to 10Gbps network for all machines.... I haven't looked at costing on that option, but I assume it is really just the same problem anyway, either speeds are unbalanced if server has more bandwidth, or speeds are balanced if server has equal bandwidth/limited balancing with LACP asiide)

BTW, reading at www.kernel.org/doc/Documentation/networking/bonding.txt in chapter 12.1.1 I think maybe balance-alb might be a better solution? It sounds like it would at least do a better job at avoiding 5 machines being on the same link .... 

>> Just in case the budget dollars doesn't stretch that far, would it be
>> a reasonable budget option to do this:
>> Add 1 x 2port ethernet card to the DC machine
>> Add 7 x 1port ethernet card to the rest of the machines $32 (Intel
>> Pro 1000GT DT Adapter I 82541PI Low-Profile PCI)
>> Add 1 x 24port switch $300
>> 
>> Total Cost: $685
>
>If the DC can take a PCIe x4 dual port card, that should work fine with
>the reconfiguration I described above.  The rest of the gear in that
>$685 is wasted--no gain.  Use part of the remaining balance for the LSI
>9207-8i HBA.  That will make a big difference in throughput once you
>get alignment and other issues identified and corrected, more than double
>your current bandwidth and IOPS, making full time DRBD possible.

I will suggest the HBA anyway, might as well improve that now anyway, and it also adds options for future expansion (up to 8 x SSD's). 

I can't find that exact one, my supplier has suggested the LSI SAS 9211-8i pack for $390 or the LSI MegaRAID SAS 9240-8i pack for $429, is one of these equivalent/comparable?

>> I'm assuming this would stop sharing SMB/iSCSI on the same ports, and
>> improve the ability for the TS machines to at least talk to the DC
>and
>> know the IO is "in progress" and hence reduce the data loss/failures?
>
>Again this is all unnecessary once you implement the aforementioned
>changes.  If the IO errors on the TS machines still occur the cause
>isn't in the network setup.  Running CIFS(SMB)/iSCSI on the same port
>is
>done 24x7 by thousands of sites.  This isn't the cause of the TS IO
>errors.  Congestion alone shouldn't cause them either, unless a Windows
>kernel iSCSI packet timeout is being exceeded or something like that,
>which actually seems pretty plausible given the information you've
>provided.  I admit I'm no a Windows iSCSI expert.  If that is the case
>then it should be solved by the mentioned LACP configuration and two
>bonded ports on the DC box.

I suspect a part of all this was caused by the write caching on the windows drives, so hopefully that situation will improve now.

When doing the above dd tests, I noticed one machine would show 2.6GB/s for the second or subsequent reads (ie, cached) while all the other machines would show consistent read speeds equivalent to uncached speeds. If this one machine had to read large enough data (more than RAM) then it dropped back to normal expected uncached speeds. I worked out this machine I had experimented with installing multipath-tools, so I installed this on all other machines, and hopefully it will allow improved performance through caching of the iSCSI devices.

I haven't done anything with the partitions as yet, but are you basically suggesting the following:
1) Make sure the primary and secondary storage servers are in sync and running
2) Remove one SSD from the RAID5, delete the partition, clear the superblock/etc
3) Add the same SSD back as /dev/sdx instead of /dev/sdx1
4) Wait for sync
5) Go to 2 with the next SSD etc

This would move everything to the beginning of the disk by a small amount, but not change anything relatively regarding DRBD/LVM/etc .... 

Would I then need to do further tests to see if I need to do something more to move DRBD/LVM to the correct offset to ensure alignment? How would I test if that is needed?

>>> Keep us posted.
>> 
>> Will do, I'll have to price up the above options, and get approval
>for
>> purchase, and then will take a few days to get it all in place/etc...
>
>Given the temperature under the collar of the client, I'd simply spend
>on adding the 2 bonded ports to the DC box, make all of the LACP
>changes, and straighten out alignment/etc issues on the SSDs, md stripe
>cache, etc.  This will make substantial gains.  Once the client sees
>the
>positive results, then recommend the HBA for even better performance.
>Remember, Intel's 520 SSD data shows nearly double the performance
>using
>SATA3 vs SATA2.  Once you have alignment and md tuning squared away,
>moving to the LSI should nearly double your block throughput.

I;d prefer to do everything at once, then they will only pay once, and they should see a massive improvement in one jump. Smaller incremental improvement is harder for them to see..... Also, the HBA is not so expensive, I always assumed they were at least double or more in price....

Apologies if the above is 'confused', but I am :)

PS, was going to move one of the dual port cards from the secondary san to the DC machine, but haven't yet since I don't have enough switch ports, and now I'm really unsure whether what I have done will be an improvement anyway. Will find out tomorrow....

Summary of changes (more for my own reference in case I need to undo it tomorrow):
1) disable disk cache on all windows machines
2) san1/2 convert from balance-rr to 802.3ad and add xmit_hash_policy=1
3) change switch LAG from Static to LACP
4) install multipath-tools on all physical machines (no config, just a reboot)

Thanks,
Adam


Regards,
Adam

--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
