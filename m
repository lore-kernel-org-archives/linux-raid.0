From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [PATCH v4] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Fri, 18 Aug 2017 15:10:05 +0900
Message-ID: <20170818061005.GB20323@X58A-UD3R>
References: <1502426543-15229-1-git-send-email-byungchul.park@lge.com>
 <20170818012426.GX20323@X58A-UD3R>
 <34c37201-1ec8-270e-91b0-a8d94b7a7d6e@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34c37201-1ec8-270e-91b0-a8d94b7a7d6e@coly.li>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, nborisov@suse.com, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On Fri, Aug 18, 2017 at 02:04:20PM +0800, Coly Li wrote:
> On 2017/8/18 上午9:24, Byungchul Park wrote:
> > On Fri, Aug 11, 2017 at 01:42:23PM +0900, Byungchul Park wrote:
> >> Although llist provides proper APIs, they are not used. Make them used.
> > 
> > Any opinions about this?
> > 
> 
> The patch is good. If Eric has no time, I will take care of it later.

Hi, Coly

Thanks a lot. :)
