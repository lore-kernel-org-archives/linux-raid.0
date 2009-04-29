From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] Proof-of-concept: refactoring raid6 recovery for the async
 case
Date: Tue, 28 Apr 2009 18:49:56 -0700
Message-ID: <49F7B244.5090304@zytor.com>
References: <1240962819.10249.2.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240962819.10249.2.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan Williams wrote:
> The goal of the following implementation is to demonstrate a proposed
> re-factoring of the raid6 recovery code to isolate the operations that
> can be accelerated by hardware.  These operations are xor,
> gf-multiplication by a scalar (mult), and sum_product (the xor-sum of
> two vectors multiplied by two scalars).
> 
> This version passes the tests from drivers/md/raid6test/test.c and
> barring objections the approach (of course not this code) will be used
> in the next version of the async-raid6 patchset.
> 
> Thanks,
> Dan

Seems quite reasonable to me.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

