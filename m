From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: nested raid possible?
Date: Sat, 07 Jul 2007 10:12:32 -0400
Message-ID: <468F9F50.5040206@tmr.com>
References: <8585506.1183693119573.JavaMail.root@wombat.diezmil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8585506.1183693119573.JavaMail.root@wombat.diezmil.com>
Sender: linux-raid-owner@vger.kernel.org
To: turbo@weasel.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

turbo@weasel.com wrote:
> I have a raid-5 array of six 250gb hard drives.
> I just bought four 500gb hard drives.
>
> I know I can take the six drives and make three raid-1 arrays of 500gb.
> After doing that, can I make a raid-5 array consisting of the three 
> raid-0 arrays, and the four 500gb hard drives?
>   

If you want performance and reliability, I would suggest migrating 
everything to RAID-10, which will handle unequal size drives reasonably 
well. In the medium term you may want to upgrade the 250=>500 just so 
you can reduce your spare drive needs. And if your storage needs are 
going to grow, you might consider winding up with RAID-6 and a hot spare.

LVM offers another solution, which also adds complexity, and in my 
measurements hurts performance.

The short answer is that you can do what you asked, but it's more 
complex and less reliable than is really desirable.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

