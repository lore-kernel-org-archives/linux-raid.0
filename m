From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] Abort pending request for RAID10
Date: Tue, 19 Jan 2016 10:53:42 -0800
Message-ID: <20160119185342.GA8149@kernel.org>
References: <1453193726-4617-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453193726-4617-1-git-send-email-hare@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 19, 2016 at 09:55:26AM +0100, Hannes Reinecke wrote:
> RAID10 delays the write until the bitmap has been updated.
> So it really should check if the device is still working
> before sending requests, otherwise it'll happily sending
> I/O to a known faulty device.

Hi,

__make_request already checks the faulty bit. That's possible the disk becomes
faulty after __make_request check though. But faulty bit can be set any time,
for example, after the check with your patch. There is no guarantee pending
writes get canceled immediately after the disk is marked faulty. I'm wondering
what's the real problem.

Thanks,
Shaohua
