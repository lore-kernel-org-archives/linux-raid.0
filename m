From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 28 Jan 2014 01:46:28 -0600
Message-ID: <52E76054.5090900@hardwarefreak.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140125083630.GA7555@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/25/2014 2:36 AM, Marc MERLIN wrote:
> On Thu, Jan 23, 2014 at 11:13:41PM -0600, Stan Hoeppner wrote:
>> Well, no, not really.  I know there are some real quality issues with a
>> lot of cheap PMP JBODs out there.  I was just surprised to see an
>> experienced Linux sysadmin have bad luck with 3/3 of em.  Most folks
>> using Silicon Image HBAs with SiI PMPs seem to get good performance.
>  
> I've worked with the raw chips on silicon, have the firmware flashing tool
> for the PMP, and never saw better than that.
> So I'm not sure who those most folks are, or what chips they have, but
> obviously the experience you describe is very different from the one I've
> seen, or even from what the 2 kernel folks I know who used to maintain them
> have, since they've abandonned using them due to them being more trouble
> than they're worth and the performance poor.

The first that comes to mind is Backblaze, a cloud storage provider for
consumer file backup.  They're on their 3rd generation of storage pod,
and they're still using the original Syba SiI 3132 PCIe, Addonics SiI
3124 PCI cards, and SiI 3726 PMP backplane boards, since 2009.  All
Silicon Image ASICs both HBA and PMP.  Each pod has 4 SATA cards and 9
PMPs boards with 45 drive slots.  The version 3.0 pod offers 180TB of
storage.  They have a few hundred of these storage pods in service
backing up user files over the net.  Here's the original design.  The
post has links to version 2 and 3.

http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-cheap-cloud-storage/

The key to their success is obviously working closely with all their
vendors to make sure the SATA cards and PMPs have the correct firmware
versions to work reliably with each other.  Consumers buying cheap big
box store HBAs and enclosures don't have this advantage.

> To be fair, at the time I cared about performance on PMP, I was also using
> snapshots on LVM and those were so bad that they actually were the
> performance issue sometimes I got as slow as 5MB/s. Yes, LVM snapshots were
> horrible for performance, which is why I switched to brtfs now.
> 
>> Personally, I've never used PMPs.  Given the cost ratio between drives
>> and HBA ports, a quality 4/8 port SAS HBA such as one of the LSIs is a
>> better solution all around.  4TB drives average $200 each.  A five drive
>> array is $1000.  An LSI 8 port 12G SAS HBA with guaranteed
>> compatibility, quality, support, and performance is $300.  A cheap 2
> 
> You are correct. When I started with PMPs there was not a single good SATA
> card that had 10 ports or more and didn't cost $900. That was 4-5 years ago
> though.
> Today, I don't use PMPs anymore, except for some enclosures where it's easy
> to just have one cable and where what you describe would need 5 sata cables
> to the enclosure, would it not?

No.  For external JBOD storage you go with an SAS expander unit instead
of a PMP.  You have a single SFF 8088 cable to the host which carries 4
SAS/SATA channels, up to 2.4 GB/s with 6G interfaces.

> (unless you use something like USB3, but that's another interface I've had
> my share of driver bug problems with, so it's not a net win either).

Yes, USB is a horrible interface for RAID storage.

>> port SATA HBA and 5 port PMP card gives sub optimal performance, iffy
>> compatibility, and low quality, and is ~$130.  $1300 vs $1130.  Going
>> with a cheap SATA HBA and PMP makes no sense.
> 
> I generally agree. Here I was using it to transfer data off some drives, but
> indeed I wouldn't use this for a main array.

Your original posts left me with the impression that you were using this
as a production array.  Apologies for not digesting those correctly.

...
> Since I get the same speed writing through all the layers as raid5 gets
> doing a resync without writes and the other layers, I'm not sure how you're
> suggesting that I can get extra performance.

You don't get extra performance.  You expose the performance you already
have.  Serial submission typically doesn't reach peak throughput.  Both
the resync operation and dd copy are serial submitters.  You usually
must submit asynchronously or in parallel to reach maximum throughput.
Being limited by a PMP it may not matter.  But with your direct
connected drives of your production array you should see a substantial
increase in throughput with parallel submission.

> Well, unless you mean just raw swraid5 can be made faster with my drives
> still.
> That is likely possible if I get a better sata card to put in my machine
> or find another way to increase cpu to drive throughput.

To significantly increase single streaming throughput you need AIO.  A
faster CPU won't make any difference.  Neither will a better SATA card,
unless your current one is defective, or limits port throughput will
more than one port active--I've heard of couple that do so.

>> You said you had pulled the PMP and connected direct to an HBA, bumping
>> from 19MB/s to 99MB/s.  Did you switch back to the PMP and are now
>> getting 100MB/s through the PMP?  We should be able to get much higher
>> if it's 3/6G SATA, a little higher if it's 1/5G.
>  
> No, I did not. I'm not planning on having my destination array (the one I'm
> writing to) behind a PMP for the reasons we discussed above.
> The ports are 3MB/s. Obviously I'm not getting the right speed, but I think
> there is something wrong with the motherboard of the system this is in,
> causing some bus conflicts and slowdowns.
> This is something I'll need to investigate outside of this list since it's
> not related to raid anymore.

Interesting.

>>> For now, I put dmcrypt on top of md5, I get 100MB/s raw block write speed (actually
>>> just writing a big file in btrfs and going through all the layers) even
>>> though it's only using one CPU thread for encryption instead of 2 or more if
>>> each disk were encrypted under the md5 layer.
>>
>> 100MB/s sequential read throughput is very poor for a 5 drive RAID5,
>> especially with new 4TB drives which can stream well over 130MB/s each.
>  
> Yes, I totally agree.
> 
>>> As another test
>>> gargamel:/mnt/btrfs_pool1# dd if=/dev/md5 of=/dev/null bs=1M count=1024
>>> 1073741824 bytes (1.1 GB) copied, 9.78191 s, 110 MB/s
>>
>> dd single stream copies are not a valid test of array throughput.  This
>> tells you only the -minimum- throughput of the array.
>  
> If the array is idle, how is that not a valid block read test?

See above WRT asynchronous and parallel submission.

>>> So it looks like 100-110MB/s is the read and write speed limit of that array.
>> To test real maximum throughput install fio, save and run this job file,
>> and post your results.  Monitor CPU burn of dmcrypt, using top is fine,
>> while running the job to see if it eats all of one core.  The job runs
>> in multiple steps, first creating the eight 1GB test files, then running
>> the read/write tests against those files.
>>
>> [global]
>> directory=/some/directory
>> zero_buffers
>> numjobs=4
>> group_reporting
>> blocksize=1024k
>> ioengine=libaio
>> iodepth=16
>> direct=1
>> size=1g
>>
>> [read]
>> rw=read
>> stonewall
>>
>> [write]
>> rw=write
>> stonewall
> 
> Yeah, I have fio, didn't seem needed here, but I'll it a shot when I get a
> chance.

With your setup and its apparent hardware limitations, parallel
submission may not reveal any more performance.  On the vast majority of
systems it does.

>>> Thanks for you answers again,
>>
>> You're welcome.  If you wish to wring maximum possible performance from
>> this rig I'll stick with ya until we get there.  You're not far.  Just
>> takes some testing and tweaking unless you have a real hardware
>> limitation, not a driver setting or firmware issue.
> 
> Thanks for your offer, although to be honest, I think I'm hitting a hardware
> problem which I need to look into when I get a chance.

Got it.

>> BTW, I don't recall you mentioning which HBA and PMP you're using at the
>> moment, and whether the PMP is an Addonics card or integrated in a JBOD.
>>  Nor if you're 1.5/3/6G from HBA through PMP to each drive.
> 
> That PMP is integrated in the jbod, I haven't torn it apart to check which
> one it was, but I've pretty much gotten slow speeds from those things and
> more importantly PMPs have bugs during drive hangs and retries which can
> cause recovery problems and killing swraid5 arrays, so that's why I stopped
> using them for serious use.

Probably a good call WRT consumer PMP JBODs.

> The driver authors know about the issues, and some are in the PMP firmware
> and not something they can work around.
> 
>> Post your dmesg output showing the drive link speeds if you would, i.e.
>> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> 
> Yep, very familiar with that unfortunately from my PMP debugging days
> [    6.188660] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 330)
> [    6.211533] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 330)
> [    6.444897] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 330)
> [    6.444918] ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 330)
> [    6.445087] ata2.00: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
> [    6.445109] ata2.01: SATA link up 3.0 Gbps (SStatus 123 SControl 330)
> [   14.179297] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   14.675693] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   15.516390] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   16.008800] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.339559] ata14: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   19.692273] ata14.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   20.705263] ata14.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   21.785956] ata14.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   22.899091] ata14.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   23.935813] ata14.04: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> 
> Of course, I'm not getting that speed, but again, I'll look into it.

Yeah, something's definitely up with that.  All drives are 3G sync, so
you 'should' have 300 MB/s data rate through the PMP.

> Thanks for your suggestions for tweaks.

No problem Marc.  Have you noticed the right hand side of my email
address? :)  I'm kinda like a dog with a bone when it comes to hardware
issues.  Apologies if I've been a bit too tenacious with this.

-- 
Stan
