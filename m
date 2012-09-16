From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Sun, 16 Sep 2012 12:42:18 +0200
Message-ID: <5055AD0A.60704@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120915194102.GA10403@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 15/09/2012 21:41, Robin Hill ha scritto:
> Writing zeros is certainly what I'd do in this situation - I've done it
> for several drives in the past where they've had offline uncorrectable
> sectors flagged.

I just tried to write zeros, it didn't help: the disk doesn't reallocate 
the bad sector :(
-- 
http://www.linuxsystems.it
