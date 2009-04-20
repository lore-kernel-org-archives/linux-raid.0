From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Race condition in write_sb_page? (was: Re: Incorrect in-kernel
 bitmap on raid10)
Date: Mon, 20 Apr 2009 02:13:22 +0200
Message-ID: <slrngunfh2.90j.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
 <18922.50050.860008.242658@notabene.brown>
 <20090419225556.GC14157@darkside.22.kls.lan>
 <18923.45938.499331.641264@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> On Monday April 20, Mario.Holbe@TU-Ilmenau.DE wrote:
>> existing bitmapped device. When the full-sync of the new component is
>> finished, the bitmap on the new component does usually show still lots
>> of dirty bits (sometimes only a few %, sometimes up to 95%) while the
> I think that problem is fixed by 
>   commit 355a43e641b948a7b755cb4c2466ec548d5b495f
> which is in 2.6.29.

.2 probably :)

While looking at commit 355a43e641b948a7b755cb4c2466ec548d5b495f I'm not
sure, if this could raise a race condition: the comment in
next_active_rdev() states:
	 * As devices are only added or removed when raid_disk is < 0 and
	 * nr_pending is 0 and In_sync is clear, the entries we return will
	 * still be in the same position on the list when we re-enter
	 * list_for_each_continue_rcu.
but commit 355a43e641b948a7b755cb4c2466ec548d5b495f does exactly remove
the In_sync test. If the comment is true, the removal of the test
probably opens a window for a race condition.


regards
   Mario
-- 
Programmieren in C++ haelt die grauen Zellen am Leben. Es schaerft
alle fuenf Sinne: den Schwachsinn, den Bloedsinn, den Wahnsinn, den
Unsinn und den Stumpfsinn.
                                 [Holger Veit in doc]

