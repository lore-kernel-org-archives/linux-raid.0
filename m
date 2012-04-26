From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID6 fails to assemble after unclean shutdown
Date: Wed, 25 Apr 2012 22:58:55 -0400
Message-ID: <4F98B9EF.40207@tmr.com>
References: <20120425103536.GA9978@nsrc.org> <20120425210145.73b1e51b@notabene.brown> <20120425111606.GA10101@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120425111606.GA10101@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brian Candler wrote:
> On Wed, Apr 25, 2012 at 09:01:45PM +1000, NeilBrown wrote:
>> Presumably something when wrong during shutdown.  However without more
>> details (--examine) I cannot guess.
>
> OK, thank you.
>
> I've also found
> https://raid.wiki.kernel.org/articles/r/a/i/RAID_Recovery_d376.html
> which shows the --examine option too.
>
> When building the array, would you suggest I also specify --bitmap=internal,
> so that there is less data to resync after an error?

You are being very understated here ;-)
Without a bitmap you can spend days getting back up instead of minutes. Brian 
has the true truth here, unless there is a reason to avoid it, a bitmap is a 
ticket to a sane rebuild.

And if you have a big array, consider putting the bitmap on SSD, faster is better.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
