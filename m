From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/3] md: set MD_CHANGE_PENDING in a atomic region
Date: Sun, 8 May 2016 15:12:27 -0700
Message-ID: <20160508221227.GA2271@kernel.org>
References: <1462328535-22566-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462328535-22566-1-git-send-email-gqjiang@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Martin Kepplinger <martink@posteo.de>, Andrew Morton <akpm@linux-foundation.org>, Denys Vlasenko <dvlasenk@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 03, 2016 at 10:22:13PM -0400, Guoqing Jiang wrote:
> Some code waits for a metadata update by:
> 
> 1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
> 2. setting MD_CHANGE_PENDING and waking the management thread
> 3. waiting for MD_CHANGE_PENDING to be cleared
> 
> If the first two are done without locking, the code in md_update_sb()
> which checks if it needs to repeat might test if an update is needed
> before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
> in the wait returning early.
> 
> So make sure all places that set MD_CHANGE_PENDING are atomicial, and
> bit_clear_unless (suggested by Neil) is introduced for the purpose.

Applied the 3, thanks!
