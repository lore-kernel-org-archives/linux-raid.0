From: Neil Brown <neilb@suse.de>
Subject: Re: PULL REQUEST  assorted md fixes etc for 2.6.28
Date: Thu, 16 Oct 2008 17:09:05 +1100
Message-ID: <18678.55937.368463.888660@notabene.brown>
References: <18678.48960.359352.48245@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Thursday October 16
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thursday October 16, neilb@suse.de wrote:
> 
> Nothing earth shattering here.  Just cleanups and little bugs and a
> couple of minor improvements.

Just added another one that I missed:

Dan Williams (1):
      md: fix input truncation in safe_delay_store()

If you haven't pulled yet I guess they'll all come together.

NeilBrown

> 
> The following changes since commit 278429cff8809958d25415ba0ed32b59866ab1a8:
>   Linus Torvalds (1):
>         Merge branch 'i2c-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6
> 
> are available in the git repository at:
> 
>   git://neil.brown.name/md/ for-linus
> 
