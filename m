From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: md question re: max_hw_sectors_kb
Date: Wed, 11 May 2011 23:51:16 -0400
Message-ID: <yq1oc38poej.fsf@sermon.lab.mkp.net>
References: <4DC0639E.1070707@sgi.com> <yq17ha6z6tu.fsf@sermon.lab.mkp.net>
	<20110510095243.0a23874b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110510095243.0a23874b@notabene.brown> (NeilBrown's message of
	"Tue, 10 May 2011 09:52:43 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Reed <mdr@sgi.com>, linux-raid@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

Neil,

>> Your fix is functionally correct. However, another case just popped
>> up this week where we need to distinguish between stacking driver and
>> LLD defaults.

Neil> What case is this?

This particular case involved the need to set different defaults for
discard depending on whether it was a stacking or a low level driver.


Neil> If you have FS -> DM -> MD, then any change that MD makes to
Neil> max_hw_sectors_kb will not be visible to the FS.  So adding and
Neil> activating a hot spare with smaller max_hw_sectors_kb cause cause
Neil> it to receive requests that are too big.

Yeah, this issue pops up occasionally. Alasdair and I were discussing it
just a couple of weeks ago.


Neil> So we really need a propery resolution to this problem first.
Neil> i.e. A way for 'dm' to notice when 'md' changes its parameters -
Neil> or in general any stacking deivce to find out when an underlying
Neil> device changes in any way.

Neil> I would implement this by having blkdev_get{,_by_path,_by_dev}
Neil> take an extra arg which is a pointer to a struct of functions.  In
Neil> the first instance there would be just one which tells the claimer
Neil> that something in queue.limits has changed.  Later we could add
Neil> other calls to help with size changes.

I agree we need a way to propagate queue limit and capacity changes up
the stack. I'll put in on my todo list.

-- 
Martin K. Petersen	Oracle Linux Engineering
