From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Mon, 28 Jul 2008 15:56:27 -0500
Message-ID: <cccedfc60807281356v6836bff3y51139b33e8b8a844@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
	 <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com>
	 <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
	 <alpine.DEB.1.10.0807281543000.3288@p34.internal.lan>
	 <A20315AE59B5C34585629E258D76A97C0143F8D5@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C0143F8D5@34093-C3-EVS3.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 28, 2008 at 2:59 PM, David Lethe <david@santools.com> wrote:
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Justin Piszcz
>>Sent: Monday, July 28, 2008 2:44 PM
>>To: Jon Nelson
>>Cc: LinuxRaid
>>Subject: Re: AWFUL reshape speed with raid5.
>>
>>There once was a bug in an earlier kernel, in which the min_speed is
> what
>>the rebuild ran at if you had a specific chunk size, have you tried to
>>echo 30000 > to min_speed?  Does it increase it to 30mb/s for the
> rebuild?

As I said in my original post, I'm running 2.6.25.11

> You are incorrectly working from the premise that vmstat is measures
> disk activity.  It does not.  Vmstat has no idea how many actual bytes
> get sent to, or received from disk drives.

Fair enough.

> Why not do a real test and hook up a pair of SAS, SCSI, or FC disks,
...

Cost.

-- 
Jon
