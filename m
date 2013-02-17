From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Mon, 18 Feb 2013 01:46:23 +1100
Message-ID: <5120ED3F.7080904@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwa
 refreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B.1080804@hardwarefreak.com> <5120979C.9030703@websitemanagers.com.au> <5120E1F6.2050906@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5120E1F6.2050906@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/02/13 00:58, Stan Hoeppner wrote:
> On 2/17/2013 2:41 AM, Adam Goryachev wrote:
>> On 17/02/13 17:28, Stan Hoeppner wrote:
> 
>> OK, in that case, you are correct, I've misunderstood you.
> 
> This is my fault.  I should have explained explained that better.  I
> left it ambiguous.
> 
>> I'm unsure how to configure things to work that way...
>>
>> I've run the following commands from the URL you posted previously:
>> http://linfrastructure.blogspot.com.au/2008/02/multipath-and-equallogic-iscsi.html
>>
>> iscsiadm -m iface -I iface0 --op=new
>> iscsiadm -m iface -I iface1 --op=new
>> iscsiadm -m iface -I iface0 --op=update -n iface.hwaddress -v
>> 00:16:3E:XX:XX:XX
>> iscsiadm -m iface -I iface1 --op=update -n iface.hwaddress -v
>> 00:16:3E:XX:XX:XX
>>
>> iscsiadm -m discovery -t st -p 10.X.X.X
>>
>> The above command (discovery) finds 4 paths for each LUN, since it
>> automatically uses each interface to talk to each LUN. Do you know how
>> to stop that from happening? If I only allow a connection to a single IP
>> on the SAN, then it will only use one session from each interface.
> 
> This is what LUN masking is for.  I haven't seen your your target
> configuration, whether you're just using ietd.conf for access control,
> or if you're using column 4 in target defs in /etc/iscsi/targets.  So I
> can't help you setup your masking at this point.  It'll be complicated
> no matter what, as you are apparently currently allowing the world to
> see the LUNs.

I must say, I'm only getting to learn about this... Previously, it was
wide open... the entire user lan had direct access to the iSCSI without
any username/password. As a part of the separation of the user lan from
iSCSI SAN, I also added a iptables rule to block iSCSI connections.
After a bit more investigating, I found /etc/iet/targets.allow where I
could put only the IP of the SAN interface which helped.

Previously, a discover actually was finding a bunch of IP's from the
SAN, including private IP addresses that were on the directly connected
interface for DRBD. I was running a discovery and then some rm commands
to delete the extra files from /etc/iscsi before running the login commands.

After reading the man page for ietd (just command line options) and
ietd.conf (only refers to username/password restrictions), and looking
at the file targets.allow, it doesn't seem to be too easily configured
to block access in that way.

> Since you're not yet familiar with masking, simply use --interface and
> --portal with iscsiadm to discover and log into LUNs manually on a 1:1
> port basis.  This can be easily scripted.  See the man page for details.

I'll start with this method... Haven't looked at the iscsiadm man page
again yet, but I suspect it shouldn't be too hard to work out. I'm also
thinking I could just run the discover and manually delete the
extraneous files the same as I was doing previously. I'll sort this out
next week.

> Yep.  Separating iSCSI traffic on the DC to another link seems to have
> helped quite a bit.  But my, oh my, that 3x plus increase in SSD
> throughput surely will help.  I'm still curious as to how much of that
> was the LSI and how much was the kernel bug fix.

Well, hard to say, but here is the fio test result from the OS drive
before the kernel change:
   READ: io=4096MB, aggrb=518840KB/s, minb=531292KB/s, maxb=531292KB/s,
mint=8084msec, maxt=8084msec
  WRITE: io=4096MB, aggrb=136404KB/s, minb=139678KB/s, maxb=139678KB/s,
mint=30749msec, maxt=30749msec

Disk stats (read/write):
  sda: ios=66570/66363, merge=10297/10453, ticks=259152/993304,
in_queue=1252592, util=99.34%

Here is the same test with the new kernel (note, this SSD is still
connected to the motherboard, I wasn't confident if the HBA drivers were
included in my kernel, when I installed it, etc.

   READ: io=4096MB, aggrb=516349KB/s, minb=528741KB/s, maxb=528741KB/s,
mint=8123msec, maxt=8123msec
  WRITE: io=4096MB, aggrb=143812KB/s, minb=147264KB/s, maxb=147264KB/s,
mint=29165msec, maxt=29165msec

Disk stats (read/write):
  sdf: ios=66509/66102, merge=10342/10537, ticks=260504/937872,
in_queue=1198440, util=99.14%

Interesting that there is very little difference.... I'm not sure why...

It would be interesting to re-test the onboard SATA performance, but I
assure you I really don't want to pull that machine apart again. (Some
insane person mounted it on the rack mount rails upside down!!! So it's
a real pita for something that is supposed to make life easier!

> On that note I'm going to start a clean thread regarding your 3x
> read/write throughput ratio deficit.

Good idea :)

> You have a bit of a unique setup there, and the hardware necessary for
> some extreme performance.  My heart sank when I saw the IO numbers you
> posted and I felt compelled to try to help.  Very few folks have a
> storage server, commercial or otherwise, with 2GB/s of read and 650MB/s
> of write throughput with 1.8TB of capacity.  Allow me to continue
> assisting and we'll get that write number up there with the read.

Well, it wasn't meant to be such a beast of a machine. It was originally
specced with 12 x 1TB 7200rpm drives, using an overland SAN (because I
didn't want to bet my reputation on being able to build up a linux based
home solution for them). When that fell over a number of times, and the
tech support couldn't resolve the issues, and finally it lost all of the
data from one LUN (thank goodness for backups), we sent it back for a
refund. I figured I might as well try and put something together, and
extended it to a dual server setup for just a little extra budget,
except I used 4 x 2TB 7200rpm drives.... I didn't really consider the
concurrent access to different parts of the disk issue. When I looked at
it, these SSD's were about $600 each, and the 2TB drives were about $500
each. So, the options were 8 x 2TB drives in RAID10 (8TB space) or 5 x
SSD's in RAID5 (2TB space). The 2TB capacity was ample, and I preferred
the SSD's since an SSD is designed for random access, while the RAID10
option just increased the number of spindles, and may have not been enough.

So, it has been through some hoops, and has taken some effort, but at
the end of the day, I think we have a much better solution than buying
any off the shelf SAN device, and most definitely get a lot more
flexibility. Eventually the plan is to add a 3rd DRBD node at a remote
office for DR purposes.

> I've been designing and building servers around channel parts for over
> 15 years, and I prefer it any day to Dell/HP/IBM etc.  It's nice to see
> other folks getting out there on the bleeding edge building ultra high
> performance systems with channel gear.  We don't see systems like this
> on linux-raid very often.

I prefer the "channel parts systems" as well, though I was always a bit
afraid to build them for customers just in case it went wrong... I
always build up my own stuff though. Of course, next time I need to do
something like this, I'll have a heck of a lot more knowledge and
confidence to do it.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
