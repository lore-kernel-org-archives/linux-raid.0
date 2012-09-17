From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Mon, 17 Sep 2012 02:03:27 +0200
Message-ID: <505668CF.1090102@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk> <5055AD0A.60704@linuxsystems.it> <44576376-12B0-4A78-B5CF-C759ED2EBA9A@colorremedies.com> <5055F0CF.6000908@linuxsystems.it> <50566243.1080907@linuxsystems.it> <EE6B2D2D-D200-4B42-B8FF-3FEF14ABD667@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EE6B2D2D-D200-4B42-B8FF-3FEF14ABD667@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 17/09/2012 02:00, Chris Murphy ha scritto:
> Obviously Secure Erasing a disk takes a while and is overkill for just one sector. But I'm still curious if anyone knows if for sure ATA Secure Erase will remove bad sectors from use.

It was next on list, (un?)fortunately the trick did work and I had no 
way to test it :)

-- 
http://www.linuxsystems.it
