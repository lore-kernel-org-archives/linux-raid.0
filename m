From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommended filesystem for RAID 6
Date: Tue, 11 Aug 2020 20:45:48 +0100
Message-ID: <5F32F56C.7040603@youngman.org.uk>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Fritscher <michael@fritscher.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/08/20 20:19, Michael Fritscher wrote:
> Hi,
> 
> if you really want to use these tiny 2 TB HDDs - yes, RAID 6 (2x - the
> second for the backup system on a physically different location) is a
> good choice.
> 
> But: If you can, buy some 8-12 TB HDDs and forget the old rusty tiny
> HDDs. You'll save a lot at the system - and power.
> 
I'm looking at one of these ...
https://www.amazon.co.uk/Seagate-ST8000DM004-Barracuda-internal-Silver/dp/B075WYBQXJ/ref=pd_ybh_a_8?_encoding=UTF8&psc=1&refRID=WF1CTS2K9RWY96D1RENJ

Note that it IS a shingled drive, so fine for backup, much less so for
anything else. I'm not sure whether btrfs would be a good choice or not ...

> ext4 is fine. In my experience, it is rock-solid, and also fsck.ext4 is
> fairly qick (don't know what Roy is doing that it is so slow - do you
> really made a full-fledged ext4 with journal or a old ext2 file system?^^)
> 
> Another way would be deploying zfs with raid-z2 (Yes, I can hear the
> screams :-D )
> 
Cheers,
Wol
