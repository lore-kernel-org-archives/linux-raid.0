From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Performance question
Date: Sat, 17 Jan 2009 13:37:57 -0500
Message-ID: <49722585.4020400@tmr.com>
References: <20090117171806.GA9432@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090117171806.GA9432@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piergiorgio Sartor wrote:
> Hi all,
>
> I'll have to setup some machines with two HDs (each)
> in order to get some redundancy.
>
> Reading the MD features I noticed there are several
> possibilities to create a mirror.
> I was wondering which one offer the best perfomances
> and/or what are the compromises to accept between
> the different solutions.
>
> One possibility is a classic RAID-1 mirror.
> Another is a RAID-10 far.
> There would also be the RAID-10 near, but I guess
> this is equivalent to RAID-1.
>
> Any suggestion on which method offers higher "speed"?
> Or there are other possibilities with 2 HDs (keeping
> the redundancy, of course)?
>   

Mirrored array will offer slower write speed no matter how you do it, 
usually about the speed of a single drive. With raid10 far you should 
get about N times faster read than a single drive, where N is drives in 
the array. Clearly using three or more drives will help a LOT in typical 
performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


