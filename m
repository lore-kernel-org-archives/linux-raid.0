From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: need help, possibly shred my array, no backups, debian install issue - safe for now
Date: Tue, 11 Mar 2008 16:12:22 +0100
Message-ID: <200803111612.22329.Dexter.Filmore@gmx.de>
References: <200803111414.14400.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200803111414.14400.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I rebooted the ols Slackware system and the array assembles fine there.

The point was that debian didn't see the partitions sda1, sdb1 and sdc1 for 
reasons beyond me. c/sfdisk reported the partitons fine but they weren't 
in /proc/partitions, Bob knows why.

So when debian scanned the disks, it saw an old UUID from my first raid steps 
when I made the entire disk part of the raid instead of setting up an 0xFD 
partition, guess the old UUID is somehow still around.

Questions that remain are: why doesn't debian see the partitions and how do I 
get rid of the old relicts from the first try?

Dex
