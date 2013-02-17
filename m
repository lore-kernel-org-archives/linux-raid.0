From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Sun, 17 Feb 2013 16:02:30 +1100
Message-ID: <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com> <5114A53B.9060103@websitemanagers.com.au> <5115316F.1090502@hardwarefreak.com> <5115478A.8010004@websitemanagers.com.au> <5115CC02.2010400@hardwarefreak.com> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e7
 47c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5120356E.8000702@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.comStan Hoeppner <stan@hardwarefreak.com>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan@hardwarefreak.com> wrote:

>On 2/16/2013 11:19 AM, Adam Goryachev wrote:
>
>> OK, I don't think any of this is going to work properly... I have 11
>targets at the moment, so with two interfaces on the xen box, and 2
>ip's on the san, it is going to have 4 paths per target. So I need 44
>paths, but after 32 it times out all the rest of them when doing a
>session login. I don't see how to reduce this any further without going
>back to the old 1Gbps maximum performance level (and still use MPIO).
>I'd have to limit which targets can be seen so only a max of 8 can be
>seen by any host. This will only get worse if I manage to get it all
>working and then add more VM's to the system, I could easily end up
>with 20 targets.
>...
>> Well, I didn't even get to this... actually, exposing all 8 IP's on
>san1 produced 16 paths per Target, and I did see problems trying to get
>that working, which is why I dropped down to the 4 paths above.
>...
>> So it seems even this won't work, because I will still have 4 paths
>per target... Which brings me back, to square one....
>> 
>> I need both xen ports in a single bond, each group of 4 ports on san1
>in a bond, this provides 2 paths per target (or san could be 8 ports in
>one bond, and xen could use two interfaces individually), and then I
>can get up to 16 targets which at least lets me get things working now,
>and potentially scales a little bit further.
>> 
>> Maybe it is unusual for people to use so many targets, or
>something... I can't seem to find anything on google about this limit,
>which seems to be pretty low :(
>
>I regret suggesting this.  This can work in some scenarios, but it is
>simply not needed in this one, whether you could get it to work or not.
>
>> I don't understand this.... MPIO to all 8 ports would have scaled the
>best
>
>*Theoretically* yes.  But your workload isn't theoretical.  You don't
>design a network, user or SAN, based on balancing theoretical maximums
>of each channel.  You design it based on actual user workload data
>flows.  In reality, 2 ports of b/w in your SAN server is far more than
>sufficient for your current workload, and is even sufficient for double
>your current workload.  And nobody outside HPC designs for peak user
>throughput, but average throughput, unless the budget is unlimited, and
>most are not.
>
>> However, using the 4 path per target method will limit performance
>depending on who those paths are shared with.
>
>See above regarding actual workload data flows.  You're still in
>theoretical land.
>
>> Using balance-alb...
>
>Forget using Linux bonding for SAN traffic.  It's a non starter.
>
>> What am I missing or not seeing? I'm sure I'm blinded by having tried
>so many different things now...
>
>You're allowing theory to blind you from reality.  You're looking for
>something that's perfect instead of more than sufficient.
>
>> I just don't see why this didn't work for me.... I didn't even find
>an option to adjust this maximum limit. I only assume it is a limit at
>this stage...
>
>Forget it.  Configure the 2:2 and be done with it.
>
>>>> I really need to get this done by Monday after today
>
>One more reason to go with the standard 2:2 setup.

That's the problem, even the 2:2 setup doesn't work.

Two ethernet interfaces on the xen client x 2 IP's on the san server equals 4 paths, times 11 targets equals 44 paths total, and the linux iscsi-target (ietd) only supports a maximum of 32 on the version I'm using. I did actually find the details of this limit:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=687619

As much as i like debian stable, it is really annoying to keep finding that you are affected so severely by known bugs, that have been known for over a year (snip whinging).

So I've currently left it with 8 x ports in bond0 using balance-alb, and each client using MPIO with 2 interfaces to each target (total 22 paths). I ran a quick dd read test from each client simultaneously, and the minimum read speed was 98MB/s, with a single client max speed was around 180MB/s.

So, will see how this goes this week, then will try to upgrade the kernel, and also upgrade the iscsi target to fix both bugs and can then change back to MPIO with 4 paths (2:2).

In fact, I suspect a significant part of this entire project performance issue could be attributed to the kernel bug. The user who reported the issue was getting slower performance from the SSD compared to an old HDD, and I'm losing a significant amount of performance from it (as you said, even 1Gbps should probably be sufficient).

I'll probably test the upgrade to debian testing on the secondary san during the week, then if that is successful, I can repeat the process on the primary.

Regards,
Adam


--
Adam Goryachev
Website Managers
www.websitemanagers.com.au
