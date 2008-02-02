From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: RAID 1 and grub
Date: Sun, 3 Feb 2008 00:51:28 +0100
Message-ID: <20080202235128.GB24990@rap.rap.dk>
References: <47A0F4DC.9030005@sauce.co.nz> <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com> <47A13379.50703@sauce.co.nz> <72dbd3150801301847s6bbfa958h1213e782627e64a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72dbd3150801301847s6bbfa958h1213e782627e64a1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 30, 2008 at 06:47:19PM -0800, David Rees wrote:
> On Jan 30, 2008 6:33 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> 
> FWIW, this step is clearly marked in the Software-RAID HOWTO under
> "Booting on RAID":
> http://tldp.org/HOWTO/Software-RAID-HOWTO-7.html#ss7.3

A good an extesive reference, but somewhat outdated.

> BTW, I suspect you are missing the command "setup" from your 3rd
> command above, it should be:
> 
> # grub
> grub> device (hd0) /dev/hdc
> grub> root (hd0,0)
> grub> setup (hd0)

I do not grasp this. How and where is it said that two disks are
involved? hda and hdc should both be involved.

Best regards
keld
