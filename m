From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Proposed enhancements to MD
Date: Tue, 13 Jan 2004 13:41:07 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113134107.A7646@lists.us.dell.com>
References: <40033D02.8000207@adaptec.com> <40043C75.6040100@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40043C75.6040100@pobox.com>; from jgarzik@pobox.com on Tue, Jan 13, 2004 at 01:44:05PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Scott Long <scott_long@adaptec.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Tue, Jan 13, 2004 at 01:44:05PM -0500, Jeff Garzik wrote:
> You sorta hit a bad time for 2.4 development.  Even though my employer 
> (Red Hat), Adaptec, and many others must continue to support new 
> products on 2.4.x kernels,

Indeed, enterprise class products based on 2.4.x kernels will need
some form of solution here too.

> kernel development has shifted to 2.6.x (and soon 2.7.x).
> 
> In general, you want a strategy of "develop on latest, then backport if 
> needed."

Ideally in 2.6 one can use device mapper, but DM hasn't been
incorporated into 2.4 stock, I know it's not in RHEL 3, and I don't
believe it's included in SLES8.  Can anyone share thoughts on if a DDF
solution were built on top of DM, that DM could be included in 2.4
stock, RHEL3, or SLES8?  Otherwise, Adaptec will be stuck with two
different solutions anyhow, one for 2.4 (they're proposing enhancing
MD), and DM for 2.6.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
