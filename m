From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which? headaches galore!
Date: Tue, 24 Jan 2006 09:40:28 -0500
Message-ID: <20060124144028.GA23269@havoc.gtf.org>
References: <200601230336.55220.mlaks@verizon.net> <op.s3ty89rfcigqcu@apollo13> <43D53AEC.7060302@xs4all.nl> <op.s3vm4tckcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <op.s3vm4tckcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: John Hendrikx <hjohn@xs4all.nl>, Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 24, 2006 at 10:54:19AM +0100, PFC wrote:
> SATA disks accessed via libata are not currently supported by
> smartmontools. When libata is given an ATA pass-thru ioctl() then an
> additional '-d libata' device type will be added to smartmontools.

It already has support.  Pass "-d ata" to existing smartmontools.

	Jeff


