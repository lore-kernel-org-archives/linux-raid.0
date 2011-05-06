From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Problems creating MS-RAID1: "device .. not suitable for any style of raid array" / "Device or resource busy"
Date: Fri, 6 May 2011 15:36:46 -0500
Message-ID: <15.66.09483.9DB54CD4@cdptpa-omtalb.mail.rr.com>
References: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ulrich Windl' <Ulrich.Windl@rz.uni-regensburg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Ulrich Windl
> Sent: Friday, May 06, 2011 7:16 AM
> To: linux-raid@vger.kernel.org
> Subject: Problems creating MS-RAID1: "device .. not suitable for any style
> of raid array" / "Device or resource busy"
> 
> Hello!
> 
> I'm having strange trouble with SLES11 SP1 amd MD RAID1 (mdadm - v3.0.3
> (mdadm-3.0.3-0.22.4), 2.6.32.36-0.5-xen):
> 
> I was able to create one RAID1 array, but not a second one. I have no idea
> what's wrong, but my guesses are:
> 
> 1) An error when using "--bitmap internal" for a 30GB disk
> 2) Unsure whether the disks needs an msdos signature or a RAID partition

	It doesn't necessarily require either one.  They don't have to be
partitioned at all, and indeed there is no fundamental reason to partition
the drives if the entire disk is to be used for the array.  If you do need
to partition the disk, I don't think it matters what the partition type is.

