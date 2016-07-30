From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid10: increment write counter after bio is split
Date: Sat, 30 Jul 2016 14:01:51 -0700
Message-ID: <20160730210151.GB9149@kernel.org>
References: <1469694505-20018-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469694505-20018-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

On Thu, Jul 28, 2016 at 10:28:25AM +0200, Tomasz Majchrzak wrote:
> md pending write counter must be incremented after bio is split,
> otherwise it gets decremented too many times in end bio callback and
> becomes negative.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Applied, thanks!
