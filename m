From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: add missing sysfs_notify on array_state update
Date: Tue, 19 Jul 2016 11:28:15 -0700
Message-ID: <20160719182815.GC46288@kernel.org>
References: <1467276429-9359-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467276429-9359-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 30, 2016 at 10:47:09AM +0200, Tomasz Majchrzak wrote:
> Changeset 6791875e2e53 has added early return from a function so there is no
> sysfs notification for 'active' and 'clean' state change.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>

Applied, thanks!
