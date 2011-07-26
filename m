From: Phil Turmel <philip@turmel.org>
Subject: Re: Repairing a Raid-6 array
Date: Tue, 26 Jul 2011 18:41:27 -0400
Message-ID: <4E2F4297.2080802@turmel.org>
References: <26253118.121311717357218.JavaMail.SYSTEM@ninja>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26253118.121311717357218.JavaMail.SYSTEM@ninja>
Sender: linux-raid-owner@vger.kernel.org
To: Lemur Kryptering <gottail@lemurdude.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On 07/26/2011 05:56 PM, Lemur Kryptering wrote:
> Hi,
> 
> I have an 8-disk RAID-6 array that's been online while I've been away
> from it physically. It looks like a few disks have dropped out of the
> array due to heat issues. The array uses /dev/sd{a..h}1
> 
> First sde was disabled, then sdg (couple hours later), and finally,
> sdh (two days later).
> 
> sde and sdg have wildly different event counts, and sdh is relatively
> close to what all the other disks are at.
> 
> The most logical thing to do (as I see it) sounds like to force the
> event count on sdh, and let the array rebuild. While I'm certain this
> would bring the array online for me, I'm also fairly certain it would
> fail to rebuild completely due to the fact that sdh has a non-zero
> pending sector count:

No rebuild writes would occur.  By restoring drive "n-2" into the array, you will simply have access to your data in the degraded array.  Any data that is read that was stored "in the clear" on /dev/sde and /dev/sdg will be reconstructed on demand.

> /dev/sda: Current_Pending_Sector: 0 Offline_Uncorrectable: 0
> Reallocated: 1,1, Event count: 66858
> /dev/sdb: Current_Pending_Sector: 0 Offline_Uncorrectable: 0
> Reallocated: 0,0, Event count: 66858
> /dev/sdc: Current_Pending_Sector: 0 Offline_Uncorrectable: 0
> Reallocated: 0,0, Event count: 66858
> /dev/sdd: Current_Pending_Sector: 0 Offline_Uncorrectable: 0
> Reallocated: 0,0, Event count: 66858
> /dev/sde: Current_Pending_Sector: 0 Offline_Uncorrectable: 0
> Reallocated: 2,66, Event count: 25
> /dev/sdf: Current_Pending_Sector: 0 Offline_Uncorrectable: 0
> Reallocated: 0,0, Event count: 66858
> /dev/sdg: Current_Pending_Sector: 30 Offline_Uncorrectable: 0
> Reallocated: 28,12, Event count: 1921
> /dev/sdh: Current_Pending_Sector: 9 Offline_Uncorrectable: 0
> Reallocated: 7,5, Event count: 66851
> 
> Working under the assumption that none of the disks are actually bad
> (but rather simply refused to function during the time they were in a
> hot environment, and were thus kicked from the array), I would like
> to simple re-add them all to the array, but would like to set
> precedence on what disk is trusted over another when performing a
> "repair" via the sync_action. My understanding is that currently,
> whatever drive is chosen as containing the proper information, is not
> chosen in any way that would lend itself to favoring the less stale
> drives.
> 
> So, essentially, what I'm asking for, is the ability to set the
> trustworthiness (freshness) of a drive so that the repair action does
> the right thing. If this were possible, I'd force the event count on
> sdh and sdg, and have mdadm only rely on sdg in the event that there
> was no other way to determine what data belonged in a certain place
> (so, at the least, those 9 pending sectors on sdh).

There is no way to do this in MD proper.  Any non-parity data on /dev/sde and /dev/sdg will be delivered on demand, without even checking the parity blocks.

You'd get the right data for those nine sectors, as MD would have to use sdg to reconstruct (assuming sde is left out).  But any data that should have been written to sdg while it was out, will be assumed to have been written.  When read back, you'll have stale data, with no indication what-so-ever.

Piergiorgio Sartor has put together an *offline* utility to do approximately what you are after.  I suggest you look in the archives for "RAID-6 check standalone suspend array".  (I've been watching his progress... :) )

> Again, please assume none of the disks are actually bad. In essence,
> as if each disk had been replaced, and a "dd if=/dev/olddisk
> /dev/newdisk conv=sync,noerror" had been performed on each disk.
> 
> Finally, on a somewhat unrelated note, I'd like to report that after
> I began doing the recommended "scrubbing" by sending "check" into the
> "sync_action", my problems with the Samsung HD103UJ disks involving
> pending sectors have been resolved. (I've previously posted with
> regard to pending sectors and CCTL/TLER/ERC, and no longer have these
> issues.) I've also since moved on to using Hitach 2TB
> HDS722020ALA330, simply for space reasons, but neither set of disks
> has given me trouble after I started doing this scrubbing on a weekly
> basis.

Scrubbing weekly is a very good practice.  I haven't suffered a rebuild failure in any of my arrays since I started scrubbing.

> Anyway, thank you for your time and input!
> 
> Peter Zieba 312-285-3794

HTH,

Phil
