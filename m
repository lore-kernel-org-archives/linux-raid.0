From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/11][v3] md: support for asynchronous execution of RAID6 operations
Date: Wed, 14 Jan 2009 12:00:26 -0700
Message-ID: <e9c3a7c20901141100r666007cbv76a869eddf292371@mail.gmail.com>
References: <200901130342.55633.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200901130342.55633.yur@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Mon, Jan 12, 2009 at 5:42 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
>  Hello,
>
>  This is the next attempt on asynchronous RAID-6 support. This patch-set
> has the Dan Williams' comments (Dec, 17) addressed with the following
> exception:
>
> - I still think that using 'enum dma_ctrl_flags' for PQ-specific
> operations is better than introducing another group of flags and
> enhance the device_prep_dma_pq()/device_prep_dma_pqzero_sum() with one
> more parameter. If unchanged 'enum dma_ctrl_flags' will be a criteria
> of acceptance, please let me know - I'll re-implement this exactly as
> Dan suggested.

Ignore that Dan character :-), dma_ctrl_flags is the proper place for
this functionality.

However, I do not believe we need/want ASYNC_TX_ZERO_{P,Q}.  I will
reply to 0002 and 0003 with details.

>
>
>  Fearing to look like a spammer, I post only those patches, which had
> been affected by the changes intended to address Dan's comments. These
> are the following five:
>
> 0002-async_tx-add-support-for-asynchronous-GF-multiplica.patch
> 0003-async_tx-add-support-for-asynchronous-RAID6-recover.patch
> 0004-md-run-RAID-6-stripe-operations-outside-the-lock.patch
> 0008-md-asynchronous-handle_parity_check6.patch
> 0011-ppc440spe-adma-ADMA-driver-for-the-PPC440SP-e-syst.patch
>
>  As regarding the other six patches of asynchronous RAID-6 support
> patchset:
>
> 0001-async_tx-don-t-use-src_list-argument-of-async_xor.patch
> 0005-md-common-schedule_reconstruction-for-raid5-6.patch
> 0006-md-change-handle_stripe_fill6-to-work-in-asynchrono.patch
> 0007-md-rewrite-handle_stripe_dirtying6-in-asynchronous.patch
> 0009-md-change-handle_stripe6-to-work-asynchronously.patch
> 0010-md-remove-unused-functions.patch
>
>  they are the same as in my 09 Dec 2008 post:

Do you have a git tree where you can post this series?  That would
make it easier for me to track/review.

Thanks,
Dan
