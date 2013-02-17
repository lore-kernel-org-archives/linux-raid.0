From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Sun, 17 Feb 2013 07:58:14 -0600
Message-ID: <5120E1F6.2050906@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@e
 mail.android.com> <5120356E.8000702@hardwarefreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B.1080804@hardwarefreak.com> <5120979C.9030703@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5120979C.9030703@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/17/2013 2:41 AM, Adam Goryachev wrote:
> On 17/02/13 17:28, Stan Hoeppner wrote:

> OK, in that case, you are correct, I've misunderstood you.

This is my fault.  I should have explained explained that better.  I
left it ambiguous.

> I'm unsure how to configure things to work that way...
> 
> I've run the following commands from the URL you posted previously:
> http://linfrastructure.blogspot.com.au/2008/02/multipath-and-equallogic-iscsi.html
> 
> iscsiadm -m iface -I iface0 --op=new
> iscsiadm -m iface -I iface1 --op=new
> iscsiadm -m iface -I iface0 --op=update -n iface.hwaddress -v
> 00:16:3E:XX:XX:XX
> iscsiadm -m iface -I iface1 --op=update -n iface.hwaddress -v
> 00:16:3E:XX:XX:XX
> 
> iscsiadm -m discovery -t st -p 10.X.X.X
> 
> The above command (discovery) finds 4 paths for each LUN, since it
> automatically uses each interface to talk to each LUN. Do you know how
> to stop that from happening? If I only allow a connection to a single IP
> on the SAN, then it will only use one session from each interface.

This is what LUN masking is for.  I haven't seen your your target
configuration, whether you're just using ietd.conf for access control,
or if you're using column 4 in target defs in /etc/iscsi/targets.  So I
can't help you setup your masking at this point.  It'll be complicated
no matter what, as you are apparently currently allowing the world to
see the LUNs.

Since you're not yet familiar with masking, simply use --interface and
--portal with iscsiadm to discover and log into LUNs manually on a 1:1
port basis.  This can be easily scripted.  See the man page for details.

> No, not quite. See below.
...
> The iSCSI bug is limiting the number of sessions that can be setup
> within a very short time interval. It isn't a maximum number of
> sessions. (I could verify this by disabling the automatic login, and
> manually login to each LUN one by one (4 sessions at a time)). This is
> why I can have 11 sessions from 8 machines at one time previously,
> because only one machine would login at a time (unless they all booted
> at exactly the same instant), and each one would only create 11
> sessions. Same with the current work-around/setup, only 22 sessions per
> machine, so only 22 being logged into at a time.
> See this for a perhaps better explanation of the bug (that sort of isn't
> a bug, just a default limitation):
> http://blog.wpkg.org/2007/09/09/solving-reliability-and-scalability-problems-with-iscsi/

Got it.  Getting the issue above fixed also solves this problem, at
least to a degree.

> After more reading, it seems there is still no package with this fix
> included, 1.4.20.2-10.1 doesn't include it, and that is the most recent
> version. The only solution to this would be to re-build the deb src
> package with the additional one line patch, but if I get the above
> solution (only one login from each interface) then I don't need it anyway.

Yes, you're right.  Apparently I didn't read the report thoroughly.
It's a logins per unit time issue.  Fixing the excess logins should
mitigate this pretty well.

>>> So, will see how this goes this week, then will try to upgrade the kernel, and also upgrade the iscsi target to fix both bugs and can then change back to MPIO with 4 paths (2:2).
>>>
>>> In fact, I suspect a significant part of this entire project performance issue could be attributed to the kernel bug. The user who reported the issue was getting slower performance from the SSD compared to an old HDD, and I'm losing a significant amount of performance from it (as you said, even 1Gbps should probably be sufficient).

Yep.  Separating iSCSI traffic on the DC to another link seems to have
helped quite a bit.  But my, oh my, that 3x plus increase in SSD
throughput surely will help.  I'm still curious as to how much of that
was the LSI and how much was the kernel bug fix.

On that note I'm going to start a clean thread regarding your 3x
read/write throughput ratio deficit.

>> It seems pretty clear the SSD bug is affecting you.  However it seems
>> your iSCSI issues are unrelated to the iSCSI "bug".
> 
> Nope, pretty sure the iSCSI bug is the issue... In addition, my
> inability to work out how to tell iscsiadm to only create one session
> from each interface. Solving this usage issue would get me back on track
> and side-step the whole iSCSI bug anyway.

Again, I think you're on money with the iscsi-target 32 limit bug, and
you should be able to whip the sessions into shape with those cli
options.  If not you can dig into masking, which will take a while
longer, but is the standard method for this.

> I was considering a complete upgrade to debian testing on the mistaken
> assumption that it would include:
> 1) newer kernel (it does of course)
> 2) newer iscsitarget (it does, but not new enough)
> 3) newer drbd (it doesn't, but I'm already using a self compiled version
> anyway from the upstream stable release).
> 
> So, of course, you are right. I will try a remote upgrade now to the
> backport kernel, probably need to rebuild the dkms for iscsi, and
> rebuild DRBD. None of which should impact on a remote reboot. Worst
> case, it's only a 20 minute drive. This should resolve the SSD
> performance, and leaves me with just resolving the usage of iscsiadm.
> 
> Thanks for your assistance, and patience with me, I appreciate it :)

I feel privileged to have been of continued assistance Adam. :)

You have a bit of a unique setup there, and the hardware necessary for
some extreme performance.  My heart sank when I saw the IO numbers you
posted and I felt compelled to try to help.  Very few folks have a
storage server, commercial or otherwise, with 2GB/s of read and 650MB/s
of write throughput with 1.8TB of capacity.  Allow me to continue
assisting and we'll get that write number up there with the read.

I've been designing and building servers around channel parts for over
15 years, and I prefer it any day to Dell/HP/IBM etc.  It's nice to see
other folks getting out there on the bleeding edge building ultra high
performance systems with channel gear.  We don't see systems like this
on linux-raid very often.

-- 
Stan

