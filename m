From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [md:for-linus 7/8] drivers/md/md.c:5297:6: sparse: symbol
 '__md_stop' was not declared. Should it be static?
Date: Tue, 20 Nov 2012 16:52:54 +0800
Message-ID: <20121120085254.GA12104@localhost>
References: <50ab3e71.l5WJWEVMFL2rb1jK%fengguang.wu@intel.com>
 <20121120194614.3bb75ef0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121120194614.3bb75ef0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 20, 2012 at 07:46:14PM +1100, NeilBrown wrote:
> On Tue, 20 Nov 2012 16:25:21 +0800 kbuild test robot <fengguang.wu@intel.com>
> wrote:
> 
> > tree:   git://neil.brown.name/md for-linus
> > head:   879d63a5d4cc36ff804a9cf0de2c092dd538fa45
> > commit: fceef26b94e8507f33e28741f755c010de052042 [7/8] md: make sure everything is freed when dm-raid stops an array.
> > 
> > 
> > sparse warnings:
> > 
> > drivers/md/md.c:1553:34: sparse: cast to restricted __le64
> > drivers/md/md.c:1823:40: sparse: incorrect type in assignment (different base types)
> > drivers/md/md.c:1823:40:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
> > drivers/md/md.c:1823:40:    got restricted __le64 [usertype] <noident>
> > drivers/md/md.c:1898:26: sparse: incorrect type in assignment (different base types)
> > drivers/md/md.c:1898:26:    expected restricted __le64 [usertype] super_offset
> > drivers/md/md.c:1898:26:    got unsigned long long [unsigned] [usertype] sb_start
> > + drivers/md/md.c:5297:6: sparse: symbol '__md_stop' was not declared. Should it be static?
> > 
> > Please consider folding the attached diff :-)
> 
> Wow!  What wonderful service.
> 
> Attached diff has been folded in.

Thank you! :)

Regards,
Fengguang
