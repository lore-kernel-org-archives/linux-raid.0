From: Ninti Systems <office@ninti.com.au>
Subject: Re: Please review: Slackware RAID How-To
Date: 16 May 2004 15:13:36 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084686215.1197.24.camel@localhost>
References: <1084290138.25942.30.camel@ws101.darkcore.net>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084290138.25942.30.camel@ws101.darkcore.net>
To: John Lange <john.lange@bighostbox.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John, I've had a chance to review the Slackware RAID How-to, which I
used to help build a RAID1 array with two disks under Slackware 9.1.

Building the arrays went like a dream, I don't know why I never thought
of doing it this way before, rather than trying to work with degraded
arrays etc after the OS was already installed.

I had some initial problems loading software, I kept getting disk full
messages, but I think that was an installer script issue: it doesn't
seem very tolerant of option changes being made, and there is often no
going back if you make a wrong selection.

Anyway, I built the arrays and installed the OS, but can't get LILO
figured out. No matter whether I try to use automatic or expert mode, I
can't install LILO to either the MBR or /boot. So I never get a bootable
system at the end of the process. 

I've read the lilo and lilo.conf man pages to try a find out what my
lilo.conf file should look like and what files should be where (eg
vmLinuz etc), but they're not much use to someone new to this. 


On Wed, 2004-05-12 at 01:12, John Lange wrote:
> As mentioned, I have created a Slackware RAID How-To and an initial
> draft is located here:
> 
> http://www.langefamily.ca/howto/SlackwareRaidHowTo.html
> 
> This document covers getting Slackware installed on a system with RAID.
> This technique does not require a temporary hard drive or anything other
> than a Slackware boot CD.
> 
> I am fairly new to linux software RAID so I really hope some more
> experienced people will take some time to read it and give me some
> feedback. I would hate to have some glaring errors inflicted on others!
> 
> Thanks.
-- 
--------------------------------------
Ninti Systems: Smart IT Solutions
Michael Hall
Mobile: 0429 095 392
Ph/Fax: 08 8953 1442       
Email:  office at ninti dot com dot au
Web:    http://ninti.com.au
--------------------------------------

