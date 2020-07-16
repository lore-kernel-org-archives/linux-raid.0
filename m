From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Programmatically check "global" RAID state?
Date: Thu, 16 Jul 2020 15:54:26 +0200
Message-ID: <7b42170b-3ee6-bbea-f9bf-a0bdb49932c9@thelounge.net>
References: <repl8o$ggb$1@ciao.gmane.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <repl8o$ggb$1@ciao.gmane.io>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 16.07.20 um 15:38 schrieb Ian Pilcher:
> I want to write a quick script/program for my NAS that will initiate a
> check of one of my RAID devices every night.  However, I want it to skip
> the check if either of the following is true:
> 
> * Another check/resync is in process on any RAID device, or
> 
> * Any of the RAID devices on the system are unhealthy (degraded or
>   failed).
> 
> Is there any way to programmatically check the "global" status of the
> RAID subsystem like this, or am I stuck iterating through all of the
> devices (likely via sysfs) and checking them individually?  (I'm pretty
> sure that I am "stuck" but wanted to check just in case.)

cat /proc/mdstat | grep -P 'cond1|cond2|cond3' should do the trick, if
the output is empty: go
