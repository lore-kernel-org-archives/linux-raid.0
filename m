From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: which disk the the one that data is on?
Date: Tue, 18 Jul 2006 09:16:37 -0400
Message-ID: <44BCDF35.9060906@tmr.com>
References: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shai wrote:

> Hi,
>
> I rebooted my server today to find out that one of the arrays is being
> re-synced (see output below)
> .
> 1. What does the (S) to the right of hdh1[5](S) mean?
> 2. How do I know, from this output, which disk is the one holding the
> most current data and from which all the other drives are syncing
> from? Or are they all containing the data and this sync process is
> something else? Maybe I'm just not understanding what is being done
> exactly? 

In addition to what you have already been told, if you "find out" that 
the array is in rebuild I would be a lot more worried to find out why. 
If it was from unclean shutdown you really should look into a bitmap if 
you don't have one.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

