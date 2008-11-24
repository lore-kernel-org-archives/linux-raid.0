From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
Date: Mon, 24 Nov 2008 23:04:48 +0900
Message-ID: <492AB480.5060207@kernel.org>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org> <20081124133124.GB28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081124133124.GB28946@ZenIV.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

Al Viro wrote:
> On Mon, Nov 24, 2008 at 03:56:12PM +0900, Tejun Heo wrote:
> 
>> mddev holds module reference and till the gendisk is gone mddev won't
>> be gone, so as long as gendisk is around the respective mddev and
>> md.ko are around.
> 
> It doesn't and it *could* *not* - you can't drop the final reference to
> module from within that module, period.

Yeap, right, I was confused.  Referencing self doesn't make any sense.
Got confused with holding sub modules and the days when there was no
preemption inside kernel.  I think there still might be some remnants
of those in SCSI but I need to look again.

>> I don't think it's necessary to allow modules to unload while devices
>> are hot.
> 
> gendisk may stay referenced past the point when everything got closed
> and unregistered.

Can we then make gendisk hold owner module till it gets released?  It
would be much nicer to write code to if we can keep the regular object
reference counting across module boundaries and being able to taking
down a module while devices are active isn't a too important
requirement.  For vast majoerity (ide, scsi, md) one way or the other
doesn't even matter at all.

Thanks.

-- 
tejun
