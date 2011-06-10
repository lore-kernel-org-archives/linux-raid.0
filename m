From: Phil Turmel <philip@turmel.org>
Subject: Re: SRaid with 13 Disks crashed
Date: Fri, 10 Jun 2011 10:49:29 -0400
Message-ID: <4DF22EF9.1030507@turmel.org>
References: <20110610144429.298520@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110610144429.298520@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/10/2011 10:44 AM, Dragon wrote:
> "fsck automatically calls fsck.ext4 when it sees an ext4 filesystem.  15.4% Notcontiguous == 15.4 fragmented.  No lost data."
> -> ok, puh
> 
> Now that you have a good filesystem, mounting it and taking a backup would be a good idea.  Or at least retrieve any files that are very important to you.
> -> ups
> 
> NO! You must use "mdadm --grow".  Yes, "--grow" also does "shrink".  Your fsck shows that the ext4 filesystem is still sized for the original 12-disk setup, so you don't have to shrink the filesystem.  You do have to shrink the raid:
> 
> ->mount was successfull and i can see all of my data ;) im so happy, but have still no possibility to make a backup

Yay! :) and Oooo! :(

> Step 1a: Tell mdadm the final size you are aiming for.  MD will emulate this while you test that the new size works:
> mdadm /dev/md0 --grow --array-size=16116523456k
> -> shows
> mdadm /dev/md0 --grow --array-size=16116523456k
> mdadm: invalid array size: 16116523456k
> 
> might be: 16896000k better? 1500*1024*11

No, it must be "Used Device Size" * 11 = 16116523456.  Try it without the 'k'.

Phil
