From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Grow a RAID-10
Date: Thu, 3 Jul 2008 01:10:26 +0200
Message-ID: <20080702231026.GA15028@rap.rap.dk>
References: <486BF974.70508@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <486BF974.70508@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 02:56:04PM -0700, Daniel L. Miller wrote:
> I currently have a RAID10 across (4) SATA drives.  It looks like I'm 
> going to need to grow in the near future.  Any tips for a procedure for 
> this?  My current plan:
> 
> 1.  Add a PCI SATA controller (MB had 4 SATA + 4 RAID SATA, it's a Tyan 
> MB with a NFORCE chipset, I'm not sure if I want/can use the RAID SATA 
> ports as plain SATA connections).

Why not use the mobo raid sata ports? They are probably faster than a
controller on the pci bus. What kind of pci bus do you have?

PCI-E 1x is likely to be too slow for a 4-drive raid10,f2 array.
My 4-drive raid10,f2 delivers about 320 MB/s and newer disks should be
able to deliver 360 MB/s - well above the 250 MB/s that a PCI-E 1x can
deliver. 

> 2.  Add 2 more drives - not necessarily the same size as the existing 
> (they were all 4 the same)
> 
> 3.  Execute "mdadm --grow /dev/md0"

What kind of raid10 do you have?> 

Best regards
keld
