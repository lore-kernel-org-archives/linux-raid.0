From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: RAID6 starts before RAID0 component - how to force the order?
Date: Fri, 5 Aug 2005 23:50:43 -0500
Message-ID: <20050806045043.GA31307@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll keep this short and to the point and I'm hoping for a quick simple 
high-level answer from the gurus.  I don't need hand holding, so please 
take a quick look!

I have a new RAID6 array.  A component of that array is a RAID0 sub-array.  
mdadm creates and rebuilds this multilevel array just fine.  Then I 
reboot.  Boot log shows RAID6 detected first, _THEN_ RAID0.  Thus RAID6 is 
degraded without its RAID0 component.

The RAID0 array is fine/clean.  It's just a boot order problem I'm sure.

How do I set/force the order that arrays are started at boot time?  When 
doing multi-level arrays, you would think either a) you can force it or b) 
it would be "smart" about it.

FC3 kernel-2.6.12-1.1372_FC3
using mdadm
no raidtab

Thanks!

PS #1: if this is a mailing list, please CC my email.
PS #2: I did google searches for 2 hours and there is ZILCH on this topic
