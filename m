From: Doug Herr <gmane@wombatz.com>
Subject: "SCT Error Recovery Control" disabled by suspend.
Date: Mon, 31 Oct 2016 16:16:29 +0000 (UTC)
Message-ID: <nv7qos$9t7$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mostly just a note for others like myself that are using software RAID in 
a more "desktop" setting. Short version is "Oops, I forgot that the 
drives needed to have volatile settings reset on wake up...

Some months back I learned about setting smartctl -l scterc /dev/sd[ab] 
in rc.local. This is a home desktop system with Fedora 24 using two 
single terabyte drives with raid 1.

The other day I checked in on this group to see if there is anything new 
I should be aware of and found a thread that had me double checking my 
work and I found:

>sudo smartctl -l scterc /dev/sda
[sudo] password for doug: 
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.7.9-200.fc24.x86_64] (local 
build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled


>sudo smartctl -l scterc /dev/sdb
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.7.9-200.fc24.x86_64] (local 
build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
www.smartmontools.org

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled



I verified that the rc.local entries worked correctly and I rebooted to 
make sure that the settings were going in on reboot.  I am using:

>grep smartctl /etc/rc.d/rc.local 
/sbin/smartctl -l scterc,70,70 /dev/sda
/sbin/smartctl -l scterc,70,70 /dev/sdb


When I discovered them being "Disabled" I had a six day uptime so I let 
it sit with a note to recheck periodically and this morning I found that 
it is disabled again. After getting a Raspberry Pi I no longer run my 
desktop like a server and am currently using "systemctl suspend" every 
day. I just confirmed that the scterc setting gets lost during supspend. 
I also realize that this should have been obvious since the drive is 
fully powered off by suspend and only the RAM is powered (at least that 
is my understanding).

I already added something to be run at wake up to "tickle" the screen 
saver so I will see about adding this.

I would be happy to learn about any best practices regarding this.


-- 
Doug Herr 

