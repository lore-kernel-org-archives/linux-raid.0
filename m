From: "Bene Martin" <martin.bene@icomedias.com>
Subject: RE: Spares and partitioning huge disks
Date: Thu, 13 Jan 2005 10:53:43 +0100
Message-ID: <FA095C015271B64E99B197937712FD025109C6@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Ahh ..  I now recall that maybe I did this in practice for 
> RAID5 simply
> by running RAID5 over individual RAID1s already in degraded mode.  To
> "replace" any of the disks one adds a mirror component to one of the
> degraded RAID1s, waits till it syncs up, then fails and removes the
> original component.  Hey presto - replacement without degradation.
> 
> Presumably that also works for RAID1. I.e. you run RAID1 over several
> RAID1s already in degraded mode. To replace one of the disks 
> you simply
> add in the replacement to one of the "degraded" RAID1s. When it's
> synced you fail out the original component.

Neat concept :-) I still have an issue with it though: the raid 1 resync
will fail if there's an unreadable block on the disk designated for
replacemant; I'd call this fairly probable since there's probably a
reason you want to replace the disk.. The desired situation would be for
raid code to reconstruct the required data from teh remainin disks and
write that to the new disk.

Bye, Martin
