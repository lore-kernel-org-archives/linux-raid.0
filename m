From: Philip Molter <philip@corp.texas.net>
Subject: raid1 disk failure problem
Date: Fri, 17 Sep 2004 15:41:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414B4C02.5050902@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a drive fall off my SCSI external array.  It was part of a raid1 
mirror, and when it failed off, the md device went into a redirection 
loop.  Here are some example syslog lines:

Sep 17 15:19:17 db1 kernel: raid1: sdf1: rescheduling sector 129550352
Sep 17 15:19:17 db1 kernel: r sdf1: redirecting sector 129550352 to 
another mirror
Sep 17 15:19:17 db1 kernel: raid1: sdf1: rescheduling sector 129550352
Sep 17 15:19:17 db1 kernel: rai sdf1: redirecting sector 129550352 to 
another mirror

The drive was sdf1's mirror (sdl1).  As far as I can tell, sdf didn't 
fail at all.  This loop lasted for 5 days before detected, so it wasn't 
a simple pause.  The thing was stuck in a hard loop, and the filesystem 
on the RAID was not accessible.  A reboot was required to fix.

Is this a known bug?  The kernel being used is Fedora Core 2's 
2.6.8-1.521 SMP kernel, which is basically 2.6.8-rc4-bk3.

Thanks in advance for any information,
Philip
