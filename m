From: Jens Axboe <axboe@suse.de>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11
Date: Mon, 1 Dec 2003 16:51:43 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031201155143.GF12211@suse.de>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com> <20031201141144.GD12211@suse.de> <3FCB4CFA.4020302@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FCB4CFA.4020302@backtobasicsmgmt.com>
To: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 01 2003, Kevin P. Fleming wrote:
> Jens Axboe wrote:
> 
> >>Hardware is a 2.6CGHz P4, 1G of RAM (4G highmem enabled), SMP kernel but 
> >>no preemption. Kernel config is at:
> >
> >
> >Are you using ide or libata as the backing for the sata drives?
> >
> 
> libata, two of the disks are on an ICH5 and the other four are on a 
> Promise SATA150 TX4.

Alright, so no bouncing should be happening. Could you boot with
mem=800m (and reproduce) just to rule it out completely?

-- 
Jens Axboe

