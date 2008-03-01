From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sat, 01 Mar 2008 15:07:59 -0500
Message-ID: <47C9B79F.1050906@tmr.com>
References: <1204195554.16924.16.camel@franck-gusty>	<20080228192500.4d9110d9@absurd> <20080228215339.6674f29d@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080228215339.6674f29d@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Janek Kozicki said:     (by the date of Thu, 28 Feb 2008 19:25:00 +0100)
>
> sorry about replying to myself.
>
> * two 6 disks raid10 arrays : theoretical max speed 6 times single disc
> * three 4 disks raid10 arrays : theoretical max speed 4 times single disc
> * single raid10 far=2  : theoretical max speed 12 times single disc (!)
>
> isn't that true?
>
>   
True for throughput, not for seek. Also, what I have seen and read 
indicates that smaller chunks help a lot for database with lots of seeks.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


