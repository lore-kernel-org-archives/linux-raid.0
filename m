From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] raid5: revert commit 11367799f3d1
Date: Thu, 27 Oct 2016 15:05:21 -0700
Message-ID: <20161027220521.nsre3l3aivmvuils@kernel.org>
References: <1477466439-1797-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477466439-1797-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 26, 2016 at 09:20:39AM +0200, Tomasz Majchrzak wrote:
> Revert commit 11367799f3d1 ("md: Prevent IO hold during accessing to faulty
> raid5 array") as it doesn't comply with commit c3cce6cda162 ("md/raid5:
> ensure device failure recorded before write request returns."). That change
> is not required anymore as the problem is resolved by commit 16f889499a52
> ("md: report 'write_pending' state when array in sync") - read request is
> stuck as array state is not reported correctly via sysfs attribute.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>

Applied.
