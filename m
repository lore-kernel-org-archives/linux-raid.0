From: danci@agenda.si
Subject: Re: Is there a drive error "retry" parameter?
Date: Fri, 3 Jun 2005 11:21:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0506031105010.12831@desktop.agenda.si>
References: <200505021224.35396.mlaks@verizon.net> <429F2458.6070404@update.fsix.com>
 <429F3ED5.4020005@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429F3ED5.4020005@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: cknowlton@science.edu
List-Id: linux-raid.ids

On Thu, 2 Jun 2005, Michael Tokarev wrote:

> Raid code is quite stable and is used in alot of machines all over the
> world.  If you're expiriencing such a weird behaviour, I think it's due
> to some othe problem on your side, and the best would be to find and fix
> the real error, not the symptom.

Sometimes (not very often) a similar thing happens to my server - two of 
the drives are marked faulty (seamingly at the same time).

Fortunately I have always been able to re-construct the array so my data 
was intact (and there was no need for a week of backup restoration), but 
it still is very annoying.

Each time after that happened I tested the failed disks with 'badblocks 
-n', but there were no read/write errors. Unfortunately, libata doesn't 
support SMART (in that version, at least).

To add some details, I'm using a Promise SATA150 TX4 controllers and 4 
Maxtor 6Y200M0 SATA drives for a RAID5 array (holding most of the data). 
Additionally there is an on-board Adaptec AIC-7901A U320 with two IBM 
IC35L073UWDY10-0 for a RAID1 array (holding operating system, homes, ...).

The kernel is 2.6.8-24.11-smp, the OS is SuSE Linux 9.2.

  D.

