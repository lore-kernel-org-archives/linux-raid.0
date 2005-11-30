From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: Linux Raid boot - stuck in a raid start loop - Advice
Date: Wed, 30 Nov 2005 10:57:38 +0100
Message-ID: <438D7792.76A3C0A@ardistech.com>
References: <438D73E2.70502@projecthugo.co.uk>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: kernel-lists@projecthugo.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Darcy wrote:
> 
> Hi all,
> 
> this is not a bug, this is a tricky situation due to a few bad choices
> on my part.
> 
> I am using a 8 port Sata controller (MV88SX5081 8-port SATA I PCI-X
> Controller) with the 2.6.12.6 kernel.
> 
> I am using the 3rd party sata_mv drivers as the sata_mv drivers included
> in the 2.6.15 kernel are not stable enough yet - This problem will go
> away when these drivers become stable. The 3rd party driver limits me to
> 2.6.12.6.
> 
> The 3rd party driver can only be built as a module, and not directly
> into the kernel - just making that clear before people suggest building
> it into the kernel.
> 
I did put this module in a initrd image which the kernel loads before
first access to the SATA drives.

	Bart
