From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: confusion about partitionable md arrays
Date: Thu, 28 Dec 2006 22:20:26 -0500
Message-ID: <4594897A.4080903@tmr.com>
References: <1167161228.3918.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1167161228.3918.41.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Schmitt <mschmitt@unixkiste.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Schmitt wrote:
> Hi list,
>
> since recent releases obviously it is possible to build an array and
> partition that instead of building an array out of partitions. This was
> somehow confusing but it worked in the first place. Now I moved the
> array from one machine to another and... now it gets somehow strange. I
> have nothing in /dev/md/ but /dev/md0. If I do fdisk -l it lists the
> partitions /dev/md0p1 to /dev/md0p4, set to type 83 but there are no
> devices under /dev/ or in /proc/partitions for them. I've read the
> archives and googled around but there was no real solution just
> different meanings on how it should be and how such things come. I'd
> really appreciate a definite answer how that should work with
> partitionable arrays and in best cases, what my problem may be here :)
>
> At the end of this mail are the mdstat and mdadm outputs for reference
>
>   
I'm not sure you have a problem, if this whole thing works correctly. 
However, there has been discussion about the implications of using whole 
drives instead of partitions to build your array. Having avoided that 
particular path I'm not going to rehash something I marginally 
understand, but some reading of post in the last few months may shed 
understanding.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

