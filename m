From: Neil Brown <neilb@suse.de>
Subject: Re: pata_via with software raid1: "attempt to access beyond end of
 device"
Date: Thu, 19 Jul 2007 13:54:50 +1000
Message-ID: <18078.57482.951240.250360@notabene.brown>
References: <dju2n4-lcf.ln1@tux.abusar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Fraga on Wednesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 18, fragabr@gmail.com wrote:
> Linux 2.6.22
> Intel(R) Celeron(R) CPU 2.26GHz
> 00:0f.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE (rev 06)
> Reiserfs3
> 
> 	I have 2 PATA HDs and they always worked perfectly with
> software (kernel) raid1 using the old IDE kernel drivers. Now I use
> the new libata drivers (VIA), and it keep giving those erros messages:
> 
> attempt to access beyond end of device
> md1: rw=0, want=155284112, limit=155284096

The resierfs filesystem is trying to access beyond the end of the
raid1 array.  Maybe some indexing information in the array is
corrupted.
Did you recreate the array (mdadm --create) after changing to the new
drivers?  If so, could you have accidentally made it a little smaller?

Possibly try running fsck and see if it finds anything to fix.

NeilBrown
