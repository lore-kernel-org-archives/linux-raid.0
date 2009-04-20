From: "NeilBrown" <neilb@suse.de>
Subject: Re: Race condition in write_sb_page? (was: Re: Incorrect in-kernel
     bitmap on raid10)
Date: Mon, 20 Apr 2009 11:57:54 +1000 (EST)
Message-ID: <dad4be16a03ccd96d073ecb16b937183.squirrel@neil.brown.name>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
    <18922.50050.860008.242658@notabene.brown>
    <20090419225556.GC14157@darkside.22.kls.lan>
    <18923.45938.499331.641264@notabene.brown>
    <slrngunfh2.90j.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrngunfh2.90j.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, April 20, 2009 10:13 am, Mario 'BitKoenig' Holbe wrote:
> Neil Brown <neilb@suse.de> wrote:
>> On Monday April 20, Mario.Holbe@TU-Ilmenau.DE wrote:
>>> existing bitmapped device. When the full-sync of the new component is
>>> finished, the bitmap on the new component does usually show still lots
>>> of dirty bits (sometimes only a few %, sometimes up to 95%) while the
>> I think that problem is fixed by
>>   commit 355a43e641b948a7b755cb4c2466ec548d5b495f
>> which is in 2.6.29.
>
> .2 probably :)

Actually not - I haven't tagged it for -stable.  It'll be in .30.

I had used "git describe" to see which release it was in, but that
tells me a previous release, but a subsequent one, which make it not
useful for that task.
I should have used 'get name-rev' after  a 'git pull --tags' which
would have told me
  355a43e641b948a7b755cb4c2466ec548d5b495f tags/v2.6.30-rc1~241^2~49
so it is in 30-rc1.


>
> While looking at commit 355a43e641b948a7b755cb4c2466ec548d5b495f I'm not
> sure, if this could raise a race condition: the comment in
> next_active_rdev() states:
> 	 * As devices are only added or removed when raid_disk is < 0 and
> 	 * nr_pending is 0 and In_sync is clear, the entries we return will
> 	 * still be in the same position on the list when we re-enter
> 	 * list_for_each_continue_rcu.
> but commit 355a43e641b948a7b755cb4c2466ec548d5b495f does exactly remove
> the In_sync test. If the comment is true, the removal of the test
> probably opens a window for a race condition.

Thanks for reviewing the code, I really appreciate it.

In this case, I think the code is still fine.
The comment lists a number of conditions that are all true when
something is remove from (or added to) the list.  So we only need
to be sure that one of these is true to be sure the thing wont be removed
from the list.  We previously had 3 of them known to be true.  Now
we only have 2.  But that is still plenty.

Thanks,
NeilBrown

