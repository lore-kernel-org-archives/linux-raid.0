From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: device-mapper library
Date: Mon, 8 Nov 2004 23:25:41 +0000
Message-ID: <20041108232541.GA2965@agk.surrey.redhat.com>
References: <20040826174830.GA27929@romulus.a-s-i.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040826174830.GA27929@romulus.a-s-i.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-raid.ids

On Thu, Aug 26, 2004 at 12:48:30PM -0500, Bob Glamm wrote:
> Is there an issue building device-mapper.1.00.1[89] against
> 2.6 kernels?  struct dm_target_msg does not appear in the
> kernel headers for 2.6.5 or 2.6.7 (include/linux/dm-ioctl.h)
> but does appear in kernel/ioctl/dm-ioctl.h in the device-mapper
> sources.  Is there a set of 2.6.x patches somewhere I missed?
 
A late reply, but for the record the userspace device-mapper 
library should cope fine: you compile it using its local copy of 
that header.  If your kernel was compiled with an older version of
it, the library code is designed to fallback at runtime to using
a correspondingly older version whenever it reasonably can, or else
return errors for features that can't be approximated using the 
old API.

So far, dm_target_msg is only used by multipath code in the 
unstable device-mapper trees at http://sources.redhat.com/dm/

Alasdair
-- 
agk@redhat.com
