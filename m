From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Aacraid - terrible performance on RHES3 pedge 2450
Date: Mon, 25 Oct 2004 07:22:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025122227.GB25232@lists.us.dell.com>
References: <7B3248565B589149B35D353FB966388E296F56@bunny.cartesian.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7B3248565B589149B35D353FB966388E296F56@bunny.cartesian.co.uk>
To: Zoe May <Zoe.May@Cartesian.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 25, 2004 at 11:31:07AM +0100, Zoe May wrote:
> 
> I am experiencing disk performance issues (very slow) with hardware and
> software combo listed below.
> 
> Poweredge 2450 
> Perc 3/si controller.
> RH linux ES3 (2.4.21-4.Elsmp)

up2date your system to kernel-smp-2.4.21-20.EL and see how much that
helps.

You're not the only person who has seen slow disk performance with the
-4.EL kernel.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
