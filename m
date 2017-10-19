From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/2] Fix problems with reshape on degraded raid5/6
Date: Wed, 18 Oct 2017 20:06:33 -0700
Message-ID: <20171019030633.un33jxp6qgdmrdbl@kernel.org>
References: <150821741376.9754.10397416458024667409.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150821741376.9754.10397416458024667409.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 17, 2017 at 04:18:36PM +1100, Neil Brown wrote:
> Reshape on a degraded array is supposed to work, but it
> obviously hasn't been tested.
> These two patches make at least one test case (reported by
> Curt <lightspd@gmail.com>) to work.

Applied, thanks!
