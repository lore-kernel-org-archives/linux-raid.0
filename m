From: Ninti Systems <office@ninti.com.au>
Subject: Re: Please review: Slackware RAID How-To
Date: 12 May 2004 09:21:05 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1084319464.1071.17.camel@localhost>
References: <1084290138.25942.30.camel@ws101.darkcore.net>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084290138.25942.30.camel@ws101.darkcore.net>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks John, I've been wrestling with this for a while. I ended up
having to use a RedHat9 install to get RAID 1 working on one particular
box ... RAID is my last reason to use RedHat after discovering the joy
of simplicity, Slackware style. I was using mdadm in my Slackware RAID
experiments, and a different approach, but it only ever half worked
(almost certainly the problem was with me, not mdadm!).

Unfortunately, I don't have a spare box lying around that I can test
this on right now, but I will follow this HOWTO's development with great
interest and give it a go as soon as I can. I'm mainly interested in
super reliable 2 disc RAID 1 setups, but it looks like most things still
apply.

Any comments on SATA disks? I'm not sure where SATA fits in to all this
(is it an issue?).

A reliable method for building bootable RAID on Slackware for non-gurus
will propel Slackware into the realm of the "truly awesome" for me, I've
been a RedHat jock for too long!

Mick

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

