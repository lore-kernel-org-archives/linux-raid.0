From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 0/2] md: Add support for Multiple PPLs
Date: Thu, 17 Aug 2017 11:03:31 -0700
Message-ID: <20170817180331.baxoqhgbqi5q6fvx@kernel.org>
References: <20170816151346.23382-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170816151346.23382-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 16, 2017 at 05:13:44PM +0200, Pawel Baldysiak wrote:
> Current Partial Parity Log implementation allows only single PPL to be
> written to particular member drive. In such case PPL entry is
> overwritten by every write as it's stored at the same sector of a drive.
> Such approach is suboptimal for SSD drives as it leads to increased
> write amplification factor due to write-after-write limitations.
> 
> This patchset changes the implementation by extending PPL area to 1MB.
> PPL is not stored at fixed location but multiple PPLs are written in a
> circular buffer. There is at most one valid PPL at any time (latest
> one). Recovery algorithm stays the same. The main benefits of this
> approach are increased drive lifespan and in some cases improved
> performance. 

The patches look good. Is this in intel RST standard?

I didn't get the point why this is helpful though. You mentioned reduce write
amplification. Why does this reduce write amplification? As far as I know, SSD
never does in-place write, write to the same sector or different sector has no
difference.

Thanks,
Shaohua
