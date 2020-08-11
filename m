From: Michael Fritscher <michael@fritscher.net>
Subject: Re: Recommended filesystem for RAID 6
Date: Tue, 11 Aug 2020 21:19:07 +0200
Message-ID: <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

if you really want to use these tiny 2 TB HDDs - yes, RAID 6 (2x - the
second for the backup system on a physically different location) is a
good choice.

But: If you can, buy some 8-12 TB HDDs and forget the old rusty tiny
HDDs. You'll save a lot at the system - and power.

ext4 is fine. In my experience, it is rock-solid, and also fsck.ext4 is
fairly qick (don't know what Roy is doing that it is so slow - do you
really made a full-fledged ext4 with journal or a old ext2 file system?^^)

Another way would be deploying zfs with raid-z2 (Yes, I can hear the
screams :-D )

Best regards,
Michael Fritscher
