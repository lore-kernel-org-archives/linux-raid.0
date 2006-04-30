From: Dick Snippe <Dick.Snippe@tech.omroep.nl>
Subject: Re: try to write back redundant data before failing disk in raid5 setup
Date: Mon, 1 May 2006 01:55:18 +0200
Message-ID: <20060430235518.GD24146@tech.omroep.nl>
References: <20060430231742.GC24146@tech.omroep.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060430231742.GC24146@tech.omroep.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 01, 2006 at 01:17:42AM +0200, Dick Snippe wrote:

> Suppose a read action on a disk which is member of a raid5 (or raid1 or any
> other raid where there's data redundancy) fails.
> What ahppens next is that the entire disk is marked as "failed" and a raid5
> rebuild is initiated.
>
> However, that seems like overkill to me. If only one sector on one disk
> failed, that sector could be re-calculated  (using parity calculations)
> AND written back to the original disk (i.e. the disk with the bad sector).
> Any modern disk will do sector remapping, so the bad sector will simply be
> replaced by a good one and there's no need to fail the entire disk.

Sigh. Just checked the kernel source. Recent 2.6 kernels (>= 2.6.15) appear
to have support for this (See raid5_end_read_request in drivers/md/raid5.c).
Earlier versions don't.

-- 
Dick Snippe - Publieke Omroep Internet Services
Gebouw 12.401 (peperbus) Sumatralaan 45 Hilversum  \ fight war
tel +31 35 6774252, email beheer@omroep.nl []()     \ not wars
