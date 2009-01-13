From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: upgrade advice
Date: Mon, 12 Jan 2009 22:00:16 -0500
Message-ID: <496C03C0.8050407@tmr.com>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com>	<alpine.DEB.1.10.0812160641130.725@p34.internal.lan>	<1229428184.22331.43.camel@localhost>	<alpine.DEB.1.10.0812160807200.725@p34.internal.lan>	<1229436950.22331.45.camel@localhost>	<cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com>	<alpine.DEB.1.10.0812161829490.31132@p34.internal.lan>	<cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com>	<1229497160.22331.73.camel@localhost>	<cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com>	<A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com>	<1229525166.22331.79.camel@localhost> <yq17i5yhkvl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq17i5yhkvl.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Redeeman <redeeman@metanurb.dk>, David Lethe <david@santools.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin K. Petersen wrote:
> People always seem to assume that hardware is what's making the
> difference between consumer and enterprise.  It's not.  The physical
> hardware differs mostly due to capacity vs. RPM trade-offs.  Most
> vendors these days have big platters for high-capacity drives and
> smaller platters for high RPM/higher IOPS class drives.  On top of
> that, head/platter count may vary in capacity classes within a series.
>
> But the important difference between consumer and enterprise drives is
> not mechanical.  It's the firmware.  Consumer drive firmware is about
> squeezing out the most capacity/$ and nothing else.
>
>   
That's simply not the case. Cost is one of the issues, but the typical 
use of the drive is one of the most important things about the firmware. 
With consumer drives, it's likely that this is the one and only drive 
holding the data, so clever retries in case of error are important. With 
server grade drives, it's likely they are in a RAID, so returning the 
error quickly so the controller or OS can compensate is the important 
issue. That's been discussed here before, some drives even give you a 
choice of "don't hang up" vs. "try like hell" on errors, through jumpers 
or firmware.

> Enterprise drives trade capacity for reliability by way of the
> firmware.  That includes many things like using more space for track
> info (gap/sync), much better ECC, better tolerance for rotational
> vibration, etc.
>
> Most of the errors you see on drives are a result of media errors that
> are big enough that the drive ECC can't correct them.  Errors are
> often caused by head misses due to bad tracking, vibration from other
> drives in the enclosure, the user kicking the cabinet at an
> inopportune moment, etc.  I.e. external interference.  Other errors
> are due to real imperfections of the media itself.
>
>   
I would be surprised if a consumer grade drive doing more retries over 
several seconds rather than several rotations wasn't better able to 
correct for most of the transient problems you mention. So your comments 
about transient mechanical issues aren't telling me much, other than 
server drives being more likely to get vibration from other drives.

> Enterprise drive firmware is about being more resistant to outside
> factors as well as real media defects.  That firmware cost more to
> develop than the consumer ditto.  And the vendors charge a premium for
> it.
>
>   
Other than possibly having more ECC bits there isn't much difference, as 
several people here have noted you don't want the drive to hang for 
several seconds trying this and that in a server environment. And given 
that there are a very small number of things to be done on error, like 
reread, seek away and back, recalibrate, etc, I would be amazed if 
vendors didn't just put all the code in the firmware and use a little 
table to determine which actions to take in what order, and how many 
times. The idea of some vast and complex code just doesn't fly, there 
aren't that many things to try.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


