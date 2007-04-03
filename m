From: Just Marc <marc@corky.net>
Subject: md126-7
Date: Tue, 03 Apr 2007 16:56:00 +0100
Message-ID: <46127910.9070006@corky.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I've been using the RAID subsystem quite a bit over the years.  This 
week, for the first time, I created a RAID6 array over loop devices that 
point to files.

To my surprise the device showing in /proc/mdstat for this new array is 
/dev/md127.   This is a fresh system and RAID has never been configured 
on it.  I tried re-doing everything from scratch again and was sometimes 
even given /dev/md126 (though I wasn't able to reproduce this one, it 
happened once). 

My kernel is 2.6.20.4.    Can anyone give me a hint about what's going on?

Thanks,
Marc
