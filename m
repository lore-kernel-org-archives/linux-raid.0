From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Sun, 17 Feb 2013 00:28:43 -0600
Message-ID: <5120789B.1080804@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <b
 dc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwarefreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/16/2013 11:02 PM, Adam Goryachev wrote:
> Stan Hoeppner <stan@hardwarefreak.com> wrote:

>> One more reason to go with the standard 2:2 setup.
> 
> That's the problem, even the 2:2 setup doesn't work.

You're misunderstanding what I meant by "2:2".  This simply means two
client ports linked to two server ports.  The way this is done properly
is for each initiator interface to only login to the LUNs at one remote
interface.  The result is each client interface only logs into 11 LUNs.
 That's 22 total sessions and puts you under the 32 limit of the 2.6.32
Squeeze kernel.

Correct configuration:

Client              Server
192.168.101.11 ---> 192.168.101.1 LUNs 0,1,2,3,4,5,6,7,8,9,10
192.168.101.12 ---> 192.168.101.2 LUNs 0,1,2,3,4,5,6,7,8,9,10

It sounds like what you're doing is this:

Client              Server
192.168.101.11 ---> 192.168.101.1 LUNs 0,1,2,3,4,5,6,7,8,9,10
192.168.101.11 ---> 192.168.101.2 LUNs 0,1,2,3,4,5,6,7,8,9,10

192.168.101.12 ---> 192.168.101.1 LUNs 0,1,2,3,4,5,6,7,8,9,10
192.168.101.12 ---> 192.168.101.2 LUNs 0,1,2,3,4,5,6,7,8,9,10

Note that the 2nd set of 11 LUN logins from each client interface serves
ZERO purpose.  You gain neither added redundancy nor bandwidth by doing
this.  I mentioned this in a previous email.  Again, all it does is eat
up your available sessions.

> Two ethernet interfaces on the xen client x 2 IP's on the san server equals 4 paths, times 11 targets equals 44 paths total, and the linux iscsi-target (ietd) only supports a maximum of 32 on the version I'm using. I did actually find the details of this limit:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=687619

First, this bug isn't a path issue but a session issue.  Session = LUN
login.  Thus I'd guess you have a different problem.  Posting errors
from logs would be helpful.  That may not even be necessary though,
here's why:

You've told us that in production you have 8 client machines each with
one initiator, the links being port-to-port direct to the server's 8
ports.  You're having each client interface login to 11 LUNs.  That's
*88 sessions* at the target.  This Squeeze "bug" is triggered at 32
sessions.  Thus if your problem was this bug it would have triggered in
production before you started testing w/2 interfaces on this one client box.

Thus, it would seem the problem here is actually that the iscsi-target
code simply doesn't like seeing one initiator attempting to log into the
same 11 LUNs on two different interfaces.

> As much as i like debian stable, it is really annoying to keep finding that you are affected so severely by known bugs, that have been known for over a year (snip whinging).

This is why backports exists.  The latest backport kernel has both of
these fixes, though again, it doesn't appear the iscsi "bug" is
affecting you, but something else.

> So I've currently left it with 8 x ports in bond0 using balance-alb, and each client using MPIO with 2 interfaces to each target (total 22 paths). I ran a quick dd read test from each client simultaneously, and the minimum read speed was 98MB/s, with a single client max speed was around 180MB/s.

This makes no sense at all.  First, what does "8 x ports in bond0 using
balance-alb" mean?  And, with 8 client machines that's 176 sessions, not
22.  The Debian Squeeze 2.6.32 bug is due to concurrent sessions at the
iscsi-target exceeding 32.  Here you ssem to be telling us you have 176
sessions...

> So, will see how this goes this week, then will try to upgrade the kernel, and also upgrade the iscsi target to fix both bugs and can then change back to MPIO with 4 paths (2:2).
> 
> In fact, I suspect a significant part of this entire project performance issue could be attributed to the kernel bug. The user who reported the issue was getting slower performance from the SSD compared to an old HDD, and I'm losing a significant amount of performance from it (as you said, even 1Gbps should probably be sufficient).

It seems pretty clear the SSD bug is affecting you.  However it seems
your iSCSI issues are unrelated to the iSCSI "bug".

> I'll probably test the upgrade to debian testing on the secondary san during the week, then if that is successful, I can repeat the process on the primary.

It takes a couple of minutes max to install the BPO kernel on san1.  It
takes about the same to remove the grub boot entry and reboot to the old
kernel if you have problems with it (which is very unlikely).

It seems strange that you'd do a distro upgrade on the backup server
simply to see if a new kernel fixes a problem on the primary.

-- 
Stan

