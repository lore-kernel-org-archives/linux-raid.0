From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Tue, 10 Feb 2009 09:17:14 +1100
Message-ID: <18832.43882.839120.846061@notabene.brown>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday February 9
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday February 9, jnelson-linux-raid@jamponi.net wrote:
> 
> 
> 
> The typical use case for me is this: I will run the array (/dev/md11) in
> degraded mode (without /dev/nbd0) for a week or so.
> At some point, I will try to synchronize the underlying devices. To do this
> I use:
> 
> mdadm /dev/md11 --re-add /dev/nbd0
> 
> The issues I encounter are this: the array goes into *recovery* mode rather
> than *resync*, despite the fact that /dev/nbd0 was at one point a full
> member (in sync) of the array. Typically, less than 1/3 of the array needs
> to be resynchronized, often much less than that.

I've managed to reproduce this.

If you fail the write-mostly device when the array is 'clean' (as
reported by --examine), it works as expected.
If you fail it when the array is 'active', you get the full recovery.

The array is 'active' if there have been any writes in the last 200
msecs, and clean otherwise.

I'll have to have a bit of a think about this and figure out where
what the correct fix is.   Nag me if you haven't heard anything by the
end of the week.

Thanks,
NeilBrown
