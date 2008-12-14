From: Redeeman <redeeman@metanurb.dk>
Subject: Re: Have the velociraptors in a test system now, checkout the
	errors.
Date: Sun, 14 Dec 2008 04:28:23 +0100
Message-ID: <1229225303.16555.149.camel@localhost>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
	 <49405A94.8080601@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49405A94.8080601@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

On Wed, 2008-12-10 at 19:11 -0500, Bill Davidsen wrote:
> Justin Piszcz wrote:
> > Point of thread: Two problems, mentioned in detail below, NCQ in Linux 
> > when used in a RAID configuration and two, something with how Linux 
> > interacts with the drives causes lots of problems as when I run the WD 
> > tools on the disks, they do not show any errors.
> >
> > If anyone has/would like me to run any debugging/patches/etc on this 
> > system feel free to suggest/send me things to try out.  After I put 
> > the VR's in a test system, I left NCQ enabled and I made a 10 disk 
> > raid5 to see how fast I could get it to fail, I ran bonnie++ shown 
> > below as a disk benchmark/stress test:
> >
> > For the next test I will repeat this one but with NCQ disabled, having 
> > NCQ enabled makes it fail very easily.  Then I want to re-run the test 
> > with RAID6.
> >
> > bonnie++ -d /r1/test -s 1000G -m p63 -n 16:100000:16:64
> >
> > $ df -h
> > /dev/md3              2.5T  5.5M  2.5T   1% /r1
> >
> > And the results?  Two disk "failures" according to md/Linux within a 
> > few hours as shown below:
> >
> > Note, the NCQ-related errors are what I talk about all of the time, if 
> > you use
> > NCQ and Linux in a RAID environment with WD drives, well-- good luck.
> >
> > Two-disks failed out of the RAID5 and I currentlty cannot even 'see' 
> > one of the drives with smartctl, will reboot the host and check sde 
> > again.
> >
> > After a reboot, it comes up and has no errors, really makes one wonder 
> > where/what the bugs is/are, there are two I can see:
> > 1. NCQ issue on at least WD drives in Linux in SW md/RAID
> > 2. Velociraptor/other disks reporting all kinds of sector errors etc, 
> > but when you use the WD 11.x disk tools program and run all of their 
> > tests it says the disks have no problems whatsoever!  The smart 
> > statistics do confirm this.  Currently, TLER is on for all disks, for 
> > the duration of these tests.
> 
> Just a few comments on this, I have several RAID arrays built on Seagate 
> using NCQ, and yet to have a problem. I have NCQ on with my WD drives, 
> non-RAID, and haven't had an issue with them either. The WDs run a lot 
> cooler than the SG, but they are probably getting less use, as well. If 
> the WD are still on sale after the holiday I may grab a few more and run 
> RAID, by then I will have some small sense of trusting them.
Velociraptors, or which WD?
> 

