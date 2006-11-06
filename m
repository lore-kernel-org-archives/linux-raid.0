From: dean gaudet <dean@arctic.org>
Subject: Re: RAID5 array showing as degraded after motherboard replacement
Date: Mon, 6 Nov 2006 00:29:52 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611060028120.20361@twinlark.arctic.org>
References: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
 <Pine.LNX.4.64.0611051247550.13706@twinlark.arctic.org>
 <ef2613f30611051607t24fdcec0qe6f37227e4118b73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30611051607t24fdcec0qe6f37227e4118b73@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 6 Nov 2006, James Lee wrote:

> Thanks for the reply Dean.  I looked through dmesg output from the
> boot up, to check whether this was just an ordering issue during the
> system start up (since both evms and mdadm attempt to activate the
> array, which could cause things to go wrong...).
> 
> Looking through the dmesg output though, it looks like the 'missing'
> disk is being detected before the array is assembled, but that the
> disk is throwing up errors.  I've attached the full output of dmesg;
> grepping it for "hde" gives the following:
> 
> [17179574.084000]     ide2: BM-DMA at 0xd400-0xd407, BIOS settings:
> hde:DMA, hdf:DMA
> [17179574.380000] hde: NetCell SyncRAID(TM) SR5000 JBOD, ATA DISK drive
> [17179575.312000] hde: max request size: 512KiB
> [17179575.312000] hde: 625134827 sectors (320069 MB), CHS=38912/255/63, (U)DMA
> [17179575.312000] hde: set_geometry_intr: status=0x51 { DriveReady
> SeekComplete Error }
> [17179575.312000] hde: set_geometry_intr: error=0x04 { DriveStatusError }
> [17179575.312000] hde: cache flushes supported

is it possible that the "NetCell SyncRAID" implementation is stealing some 
of the sectors (even though it's marked JBOD)?  anyhow it could be the 
disk is bad, but i'd still be tempted to see if the problem stays with the 
controller if you swap the disk with another in the array.

-dean
