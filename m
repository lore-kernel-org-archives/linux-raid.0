From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid1: handle read error also in readonly mode
Date: Fri, 28 Oct 2016 22:01:30 -0700
Message-ID: <20161029050130.ltp23ikkol3y3wen@kernel.org>
References: <1477658758-22637-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477658758-22637-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 28, 2016 at 02:45:58PM +0200, Tomasz Majchrzak wrote:
> If write is the first operation on a disk and it happens not to be
> aligned to page size, block layer sends read request first. If read
> operation fails, the disk is set as failed as no attempt to fix the
> error is made because array is in auto-readonly mode. Similarily, the
> disk is set as failed for read-only array.
> 
> Take the same approach as in raid10. Don't fail the disk if array is in
> readonly or auto-readonly mode. Try to redirect the request first and if
> unsuccessful, return a read error.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>

Applied, thanks!
