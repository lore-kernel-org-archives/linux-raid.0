From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Good news / bad news - The joys of RAID
Date: Thu, 2 Dec 2004 22:37:05 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412022229420.23412-100000@coffee.psychology.mcmaster.ca>
References: <200412021147.12410.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412021147.12410.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> not. It is my belief that formatting was inneffective at fixing the drive 
> because the cross writing probably hit some of the low level data, which the 
> drive cannot repair on a format.

the ecc *is* the low-level data.  without performing a controlled experiment
that recreates the power-off scenario, there's no way to distinguish a block
whose media is actually bad from one whose ecc fails because the ecc is bad.

the firmware theory is supported by the fact that many deathstars 
performed perfectly well for many years.  I have at least one that lasted
for 4+ years, and was powered off only a few times, and all of those cleanly.

