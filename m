From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Sleeping hard drives in an array?
Date: Sat, 03 May 2008 12:19:26 +0400
Message-ID: <481C200E.60907@msgid.tls.msk.ru>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com> <481B836E.6040208@tmr.com> <481B918E.4@panix.com> <A20315AE59B5C34585629E258D76A97C335968@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C335968@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: berk walker <berk@panix.com>, Bill Davidsen <davidsen@tmr.com>, Greg Cormier <gcormier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
[]
> USB for root??
> Bad bad bad bad idea .. unless you get the industrial flash memory.  The
> typical max number of writes for consumer-grade USB flashdrives is
> around 25,000 ... but the low end of the range is 10,000 writes.  

Why do you think root filesystem will be written that often?
Here, / is mounted read-only..  And it changes only when you
change some configs...

So, root (and /usr) are ok for flash.  Just don't put /dev on it
(udev/whatever works), and don't put volatile filesystems like
/var there too.

/mjt
