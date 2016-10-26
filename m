From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: wake up personality thread after array state update
Date: Wed, 26 Oct 2016 12:14:55 -0700
Message-ID: <20161026191455.wja223ageiwfnqiu@kernel.org>
References: <1477408028-3694-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477408028-3694-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 25, 2016 at 05:07:08PM +0200, Tomasz Majchrzak wrote:
> When raid1/raid10 array fails to write to one of the drives, the request
> is added to bio_end_io_list and finished by personality thread. The
> thread doesn't handle it as long as MD_CHANGE_PENDING flag is set. In
> case of external metadata this flag is cleared, however the thread is
> not woken up. It causes request to be blocked for few seconds (until
> another action on the array wakes up the thread) or to get stuck
> indefinitely.
> 
> Wake up personality thread once MD_CHANGE_PENDING has been cleared.
> Moving 'restart_array' call after the flag is cleared it not a solution
> because in read-write mode the call doesn't wake up the thread.

The patch looks good. However can you elaborate how userspace handles the case?
I'd like to understand what the user interface should be to support external
metadata array.

Thanks,
Shaohua
