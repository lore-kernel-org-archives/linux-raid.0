From: Ray Van Dolson <rvandolson@esri.com>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Mon, 9 Feb 2009 08:59:40 -0800
Message-ID: <20090209165940.GA805@esri.com>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com> <C5B60EA5.C47B%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C5B60EA5.C47B%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 09, 2009 at 08:47:33AM -0800, Iain Rauch wrote:
> > The typical use case for me is this: I will run the array (/dev/md11) in
> > degraded mode (without /dev/nbd0) for a week or so.
> > At some point, I will try to synchronize the underlying devices.
> 
> Sounds like rsync is more suited to your application.
> Why are you using RAID?
> 
> Iain

Seems academic to me.  Whatever the reasons, the above _should_ work
should it not?

Could this be NBD's fault somehow?

Ray
