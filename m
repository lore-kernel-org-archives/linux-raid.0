From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 21 Feb 2013 03:45:38 +1100
Message-ID: <5124FDB2.10007@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwarefreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B
 .1080804@hardwarefreak.com> <5120979C.9030703@websitemanagers.com.au> <5120E1F6.2050906@hardwarefreak.com> <5120ED3F.7080904@websitemanagers.com.au> <5123351F.5030903@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5123351F.5030903@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:

>On 2/17/2013 8:46 AM, Adam Goryachev wrote:
>
>> I'll start with this method... Haven't looked at the iscsiadm man
>page
>> again yet, but I suspect it shouldn't be too hard to work out. I'm
>also
>> thinking I could just run the discover and manually delete the
>> extraneous files the same as I was doing previously. I'll sort this
>out
>> next week.
>
>I strongly suggest you read/research and plan beforehand.  If you have
>not setup your SAN subnetting and Xen IP SAN ethernet port assignments
>correctly, you will not be able to use LUN masking, as it is based on
>subnet masks, to show/hide LUNs to initiators.  Which means you'll have
>to rip out and redo your IP assignments on the fly.
>
>Building a SAN such as this isn't something that can be done properly
>while flying by the seat of your pants.  It takes planning.

I'll work this one out, I don't think it is really relevant to the
issues anymore anyway. I can get better than 1Gbps, and don't expect
that to change much with this change.

>> Well, hard to say, but here is the fio test result from the OS drive
>> before the kernel change:
>>    READ: io=4096MB, aggrb=518840KB/s, minb=531292KB/s,
>maxb=531292KB/s,
>> mint=8084msec, maxt=8084msec
>>   WRITE: io=4096MB, aggrb=136404KB/s, minb=139678KB/s,
>maxb=139678KB/s,
>> mint=30749msec, maxt=30749msec
>
>> Disk stats (read/write):
>>   sda: ios=66570/66363, merge=10297/10453, ticks=259152/993304,
>> in_queue=1252592, util=99.34%
>
>This says /dev/sda
>
>> Here is the same test with the new kernel (note, this SSD is still
>> connected to the motherboard, I wasn't confident if the HBA drivers
>were
>> included in my kernel, when I installed it, etc.
>> 
>>    READ: io=4096MB, aggrb=516349KB/s, minb=528741KB/s,
>maxb=528741KB/s,
>> mint=8123msec, maxt=8123msec
>>   WRITE: io=4096MB, aggrb=143812KB/s, minb=147264KB/s,
>maxb=147264KB/s,
>> mint=29165msec, maxt=29165msec
>> 
>> Disk stats (read/write):
>>   sdf: ios=66509/66102, merge=10342/10537, ticks=260504/937872,
>> in_queue=1198440, util=99.14%
>
>this says /dev/sdf

Remember sdb-sdf (the RAID5) were connected to onboard, and are now
connected to the LSI. Linux is seeing the LSI card before the onboard
drive (I assume) so it has now put them as sda-sde, and the onboard
bootup SSD is now sdf... Messed with me when I was looking at some of
the stats/graphs until I realised that too....

>> Interesting that there is very little difference.... I'm not sure
>why...
>
>Is this the same SSD?  Could be test parameters, controller, etc.  SSDs
>seem to be a little finicky WRT write queue depth.  Most seem to give
>lower seq write performance with a QD of 1 and level off at peak
>performance around QD of 3 to 4.  The IO request size plays a role as
>well.  Paste your FIO command line as well as the model of this OS SSD.

Same ssd in both tests. fio command line was just fio test.fio
The fio file was the one posted in this thread by another user as follows:
[global]
bs=64k
ioengine=libaio
iodepth=32
size=4g
direct=1
runtime=60
#directory=/dev/vg0/testlv
filename=/tmp/testing/test

[seq-read]
rw=read
stonewall

[seq-write]
rw=write
stonewall

Note, the "root ssd" is the /tmp/testing/test file, when testing MD
performance on the RAID5 I'm using the /dev/vg0/testlv which is an LV on
the DRBD on the RAID5 (md2), and I do the test with the DRBD disconnected.

>> It would be interesting to re-test the onboard SATA performance, but
>I
>> assure you I really don't want to pull that machine apart again.
>(Some
>> insane person mounted it on the rack mount rails upside down!!! So
>it's
>> a real pita for something that is supposed to make life easier!
>
>WTF? How did you accomplish the upgrades?  Why didn't you flip it over
>at that time?  Wow....

A VERY good question, both of them.... I worked like a mechanic, from
underneath... a real pain I would say. I didn't like the idea of trying
to flip it by myself though, much better with someone else to help in
the process.... I think my supplier gives me crappy rails/solutions,
because they are always a pain to get them installed....

>> So, it has been through some hoops, and has taken some effort, but at
>
>Put it through another hoop and get it mounted upright.  I still can't
>believe this...  you must be pulling our collective leg.

Nope... I'll try and get to it, but it will be a while before I can take
it offline and have someone who can help fix it up... Maybe I'll call a
friend on the weekend ...

>> the end of the day, I think we have a much better solution than
>buying
>> any off the shelf SAN device, and most definitely get a lot more
>> flexibility. 
>
>Definitely cheaper, and more flexible should you need to run a filer
>(Samba) directly on the box.  Not NEARLY as easy to setup.  Nexsan has
>some nice gear that's a breeze to configure, nice intuitive web GUI.

The breeze to configure part would be nice :)

>> Eventually the plan is to add a 3rd DRBD node at a remote
>> office for DR purposes.
>
>IIRC, DRBD isn't recommended for remote site use with public networks
>due to reliability.  Will you have a GbE metro ethernet connection, or
>two?

We have 10Mbps private connection. I think we can license the DRBD proxy
which should handle the sync over a slower network. The main issue with
DRBD is when you are not using the DRBD proxy.... The connection itself
is very reliable though, just a matter of the bandwidth and whether it
will be sufficient. I'll test beforehand by using either the switch or
linux to configure a slower connection (maybe 7M or something), and see
if it will work reasonably.

>>> I've been designing and building servers around channel parts for
>over
>>> 15 years, and I prefer it any day to Dell/HP/IBM etc.  It's nice to
>see
>>> other folks getting out there on the bleeding edge building ultra
>high
>>> performance systems with channel gear.  We don't see systems like
>this
>>> on linux-raid very often.
>> 
>> I prefer the "channel parts systems" as well, though I was always a
>bit
>> afraid to build them for customers just in case it went wrong... I
>
>'Whitebox' or 'custom' if you prefer.  Selecting good quality
>components
>with solid manufacturer warranty and technical support, and performing
>extensive burn, in is the key to success.  I've had good luck with
>SuperMicro mainboards and chassis/backplanes.  Intel server boards are
>quality as well, but for many years I've been exclusively AMD for CPUs,
>for many reasons.  I do prefer Intel's NICs.

I've preferred AMD for years, but my supplier always prefers Intel, and
for systems like this they get much better warranty support for Intel
compared to almost any other brand, so I generally end up with Intel
boards and CPU's for "important" servers... Always heard good things
about Intel NIC's ...

>> always build up my own stuff though. Of course, next time I need to
>do
>> something like this, I'll have a heck of a lot more knowledge and
>> confidence to do it.
>
>Unless you're always learning/doing new stuff IT gets boring.

Very true.

Regards,
Adam
