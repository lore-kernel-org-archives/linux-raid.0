From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: possible bus loading problem during resync
Date: Tue, 9 Mar 2010 10:30:24 +0000
Message-ID: <73e903671003090230y135d104cte15e07604b85b8aa@mail.gmail.com>
References: <4B95EB5E.5090702@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B95EB5E.5090702@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 9, 2010 at 6:31 AM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> I'm working on 2 systems that are mainly for running vdr. I've had these
> running somewhat for awhile with raid. But a couple nights ago as I was
> quitting for the night, I noticed one of the computers drive light staying
> on. I had just made some changes to xine and didn't know if something had
> crashed. Turned on the TV and found the video was freezing for 10-20secs
> every 10-20secs. Logging in using putty and winscp I found it very sluggish
> to respond.Starting top I found it was doing the regular array check/resync.
> The process was using about 64% cpu and cpu was staying at idle speed
> (1000Mhz). These computers use Athlon64 x2 cpu's. A problem with the AN2
> socket systems is that when the cpu is throttled back, it also slows the
> bus. This has been found to be a problem on boards with integrated graphics
> when using nvidia's vdpau for hardware video decoding because they use
> system ram. The fix is to set the lower speed limit to 1800Mhz and/or change
> the up_threshold to ~50% . However, I am using PCIe video cards and so up
> till now have not had a problem.
>
> I stopped vdr, but putty and winscp where still sluggish. This tells me that
> it is loading the bus so much that both the video card and the network is
> effected. it would also effect any tuner cards interfering with any
> recording that may be going on at the time. I change the up_threshold from
> the default 95% to 50% which should kick the speed up when it's syncing. But
> I'm not sure that will be enough. Could there be some other setting that is
> wrong raising the priority of the process? Seems like this would be a
> problem for any system having raid maintenance bring the system to its
> knees. The eta to finish was 75 minutes.
> --


Sorry about the incredibly brief answer: Not to dismiss other issues,
but that behavior seems like exactly what I've seen when a disk has
been failing.

-- Kristleifur
