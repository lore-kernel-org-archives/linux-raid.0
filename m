From: Derek Vadala <derek@cynicism.com>
Subject: Re: RAID0 versus Linear
Date: Mon, 23 Sep 2002 17:10:36 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0209231704260.10988-100000@jaded.cynicism.com>
References: <C65F89D1AC0BB54B865127151A24DA780BAD5BA7@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C65F89D1AC0BB54B865127151A24DA780BAD5BA7@nbexchm2.aliant.icn>
To: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 23 Sep 2002, Shaw, Marco wrote:

> be OK.  The logs complained about an invalid superblock on the device
> 0 everytime.)

If it's still broke, send the log entries, kernel version, etc.

> I'd also like to confirm that RAID0 can only be used for disks of
> aproximately the same size.  If they aren't, does the extra space
> become unusable?

RAID-0 can use disks of varying sizes and will stripe data across
remaining disks when individual drives fill up.

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek


