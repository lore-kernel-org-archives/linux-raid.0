From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Which raid card to buy for Sarge
Date: Thu, 1 Apr 2004 00:39:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404010539.i315dQW21693@dns1.watkins-home.com>
References: <406BA23F.7000506@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406BA23F.7000506@wasp.net.au>
To: 'seth vidal' <skvidal@phy.duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Your RAID is 2MB/s?  I don't know how you make it so slow!
Today's IDE disks are much faster than that!
I bet something is configured wrong!

My P3-500 system gives me 30-40MB/s on a 14 disk RAID5.
It's SCSI, but my disks are slow compared to today's IDE disks.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Thursday, April 01, 2004 12:02 AM
To: seth vidal
Cc: linux-raid@vger.kernel.org
Subject: Re: Which raid card to buy for Sarge

seth vidal wrote:
>>One point. Hardware raid (and faux hardware raid) provides real hot swap
with on-the-fly rebuilds.
>>Linux software raid can't (yet).
> 
> 
> umm. That's surprising. My software raid arrays running on dell
> powervault 221s scsi boxes with adaptec 39160 controllers are
> hotswappable and when I put in a new disk and add it to the array it
> resyncs on the fly.
> 
> Are you just talking about ide-based raid?

Yes. ATA and SATA raid (Which is the majority of low budget linux software
raid stuff)
I realise scsi is hotswap. It comes with the turf.

I would find it pretty hard to justify the expense of scsi for my 7 drive
1.4TB low speed array (Low 
speed because I never *need* more than about 2MB/s in any direction but I
need heaps of space)

Brad
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


