From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 module is not ready to take IO request
Date: Thu, 16 Dec 2010 08:52:22 +1100
Message-ID: <20101216085222.77efd1ef@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176B3CE2F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176B3CE2F@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Wed, 15 Dec 2010 17:23:56 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi Neil,
> We have spotted that when RAID 1 array is assembled and stopped in a loop, there is an occasional kernel oops in raid1 module.
> It occurs in make_request function on wait_barrier(conf). In this case mddev->private was NULL, since probably it was not yet initialized in run() function.
> The straightforward approach is test for mdadm->private and return bio_endio with an error if private not set.
> The question is:
> Since raid1 module might receive IO request when it is not ready, what make_request can check for to test if for instance run() function has finished.
> 
> Thanks,
> Marcin Labun


I cannot imagine how this would happen.
It should not be possible to call do_md_stop while there are any requests
still in flight.
Are you generating any IO between assembling the RAID1 and stopping it?  If
so, how?

Can you get me the full oops message?

Thanks,
NeilBrown
