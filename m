From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Date: Mon, 24 Nov 2008 13:31:24 +0000
Message-ID: <20081124133124.GB28946@ZenIV.linux.org.uk>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <492A500C.9090200@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

On Mon, Nov 24, 2008 at 03:56:12PM +0900, Tejun Heo wrote:

> mddev holds module reference and till the gendisk is gone mddev won't
> be gone, so as long as gendisk is around the respective mddev and
> md.ko are around.

It doesn't and it *could* *not* - you can't drop the final reference to
module from within that module, period.

> I don't think it's necessary to allow modules to unload while devices
> are hot.

gendisk may stay referenced past the point when everything got closed
and unregistered.

