From: Keld Simonsen <keld@keldix.com>
Subject: Re: help needed - 4 disk raid4 with two missing disks
Date: Wed, 21 Jul 2010 17:18:55 +0200
Message-ID: <20100721151855.GA26511@rap.rap.dk>
References: <969879935.20100721134526@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <969879935.20100721134526@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 21, 2010 at 01:45:26PM +0200, Rainer Fuegenstein wrote:
> hi,
> 
> I don't seem to have any luck with this server :-(
> 
> configuration: intel atom D510 mainboard, promise SATA300 TX4
> controller (4*SATA), 4 WD caviar green 1.5TB disks (sdb, sdc, sdd,
> sde)

Hmm, on most newer mainboards there are 4 sata ports. For
better performance I would suggest you use that instead of a  separate
osata controller.

> system on sda, connected to first onboard-SATA port

I would suggest you put a little (say 10 GB in total of your big disks)
for your system, in a raid setup - to provide against crashes.
Also put your swap on raid to prevent crashes if a single disk 
breaks down.

more on: https://raid.wiki.kernel.org/index.php/Preventing_against_a_failing_disk

best regards
keld
