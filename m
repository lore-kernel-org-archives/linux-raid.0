From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Thu, 27 Dec 2007 19:53:58 -0500
Message-ID: <47744926.6010808@tmr.com>
References: <380-220071242752242883@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <380-220071242752242883@mochamail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cody Yellan <cody@mochamail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cody Yellan wrote:
> I had a 4x500GB SATA2 array, md0.  I added one 500GB drive and
> reshaping began at ~2500K/sec.  Changing
> /proc/sys/dev/raid/speed_limit_m{in,ax} or
> /sys/block/md0/md/sync_speed_m{in,ax} had no effect.  I shut down all
> unnecessary services and the array is offline (not mounted).  I have
> read that the throttling code is "fragile" (esp. with regard to
> raid5) but does this make sense?  I will wait (in)patiently for it to
> finish, but I do wonder why the configuration parameters have no
> effect.  This is a dual quad 2GHz Xeon machine with 8GB of memory
> running RHEL5.  Is this the maximum speed?
>   

Something else going on, I do better than that adding drives on USB!

I don't have a clue what the issue is, and I don't see anything in your 
information which looks unusual.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


