From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: libata + raid
Date: Mon, 24 Nov 2003 21:58:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031124195815.GS17908@hvs.envisage.co.za>
References: <200311241842.39015.oheinz@stud.fbi.fh-darmstadt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200311241842.39015.oheinz@stud.fbi.fh-darmstadt.de>
To: Oliver Heinz <oheinz@stud.fbi.fh-darmstadt.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 24, 2003 at 06:42:39PM +0100, Oliver Heinz wrote:
> 
> Libata support seems to be derived from the pdc-ultra-driver which seems to
>  be non-raid only unlike the partly closed source par15-driver, right?
> When I boot with libata enabled on a pdc20378 in raid-mode I get two
> independend drives instead off one raid-array.

Which is typically also the case with W2k/XP/etc. except that the driver
"hides" that fact to you by interpreting the on disk/bios information and
it then does the sofware RAID. Thus you are using Software RAID with BIOS
support for booting the RAID. Elsewher called "quasi-raid".

> Will raid-mode be supported? Is there a way I can help? Or maybe it's just
> stupid to complain about missing support on a quite powerful machine (2xXeon
> 2.6GHz), and I should use software raid anyway?

Refer to the (getting obsolete) ataraid/pdcraid/hptraid modules, which emulated
the Windows driver.

> Does libata (need to?) support hot-plugging?

Hopefully it does :)

