From: Christoph Hellwig <hch@infradead.org>
Subject: Re: high throughput storage server?
Date: Thu, 24 Mar 2011 13:07:53 -0400
Message-ID: <20110324170753.GA29482@infradead.org>
References: <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>
 <4D868C36.5050304@hardwarefreak.com>
 <20110321024452.GA23100@www2.open-std.org>
 <4D875E51.50807@hardwarefreak.com>
 <20110321221304.GA900@www2.open-std.org>
 <20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
 <20110322101403.GA9329@www2.open-std.org>
 <4D89B519.3020907@hardwarefreak.com>
 <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
 <4D8A1D9B.7020100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D8A1D9B.7020100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 23, 2011 at 12:19:39PM -0400, Joe Landman wrote:
> The issue though is that xfs stores journals internally by default.
> You can change this, and in specific use cases, an external journal
> is strongly advised.  This would be one such use case.

In general if you have enough spindles, or an SSD for the log for
an otherwise disk based setup the external log will always be
a win.  For many workloads log will be the only backwards seeks.

This is slightly offtopic here through, because as Joe already
sais corretly it won't matter too much for a read heavy workload.

> Unfortunately, xfs snapshots have to be done via LVM2 right now.  My
> memory isn't clear on this, there may be an xfs_freeze requirement
> for the snapshot to be really valid.  e.g.

That's not needed anymore for a long time now - device mapper
now calls the freeze_fs method to invoke exactly the same code
to freeze the filesystem.

