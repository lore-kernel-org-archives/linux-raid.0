From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Bad raid0 bio too large problem
Date: Tue, 22 Sep 2015 12:07:09 -0400
Message-ID: <wrfjvbb28mky.fsf@redhat.com>
References: <wrfjoagucvyq.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjoagucvyq.fsf@redhat.com> (Jes Sorensen's message of "Tue, 22
	Sep 2015 11:30:53 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Hi Neil,
>
> I think we have some bad side effects with this patch:
>
> commit 199dc6ed5179251fa6158a461499c24bdd99c836
> Author: NeilBrown <neilb@suse.com>
> Date:   Mon Aug 3 13:11:47 2015 +1000
>
>     md/raid0: update queue parameter in a safer location.
>     
>     When a (e.g.) RAID5 array is reshaped to RAID0, the updating
>     of queue parameters (e.g. max number of sectors per bio) is
>     done in the wrong place.
>     It should be part of ->run, but it is actually part of ->takeover.
>     This means it happens before level_store() calls:
>     
>         blk_set_stacking_limits(&mddev->queue->limits);
>     
> Running the '03r0assem' test suite fills my kernel log with output like
> below. Yi Zhang also had issues where writes failed too.
>
> robably something we need to resolve for 4.2-final or revert the
> offending patch.

Obviously I meant 4.3 here :)

Jes
