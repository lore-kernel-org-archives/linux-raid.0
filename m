From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 00:40:04 +0200
Message-ID: <gdj1c4$8nf$1@ger.gmane.org>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
> I was wondering about proactive drive replacement.
[bitmaps, raid1 drive to replace and new drive, ...]

I belive to remember a HowTo going over this list somewhere in the past
(early bitmap times?) which was recommending exactly your way.

> The problem I see with the above is the creation of the raid1 which
> overwrites the superblock. Is there some way to avoid that (--build?)?

You can build a RAID1 without superblock.


regards
   Mario
-- 
[mod_nessus for iauth]
<delta> "scanning your system...found depreciated OS...found
        hole...installing new OS...please reboot and reconnect now"

