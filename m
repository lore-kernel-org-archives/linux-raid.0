From: Tejun Heo <teheo@suse.de>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
Date: Mon, 24 Nov 2008 23:26:20 +0900
Message-ID: <492AB98C.7030105@suse.de>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org> <20081124133124.GB28946@ZenIV.linux.org.uk> <492AB480.5060207@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <492AB480.5060207@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

Tejun Heo wrote:
> Can we then make gendisk hold owner module till it gets released?  It
> would be much nicer to write code to if we can keep the regular object
> reference counting across module boundaries and being able to taking
> down a module while devices are active isn't a too important
> requirement.  For vast majoerity (ide, scsi, md) one way or the other
> doesn't even matter at all.

If always holding reference is too much of a change, we can do

	if (gendisk->fops->disk_release) {
		__module_get(gendisk->fops->owner);
		gendisk->fops->disk_release(gendisk);
		module_put(gendisk->fops->owner);
	}

So that both parties - drivers which can happily unregister devices
during exit and drivers which want to do reference counting across
module boundaries - can be happy.

Thanks.

-- 
tejun
