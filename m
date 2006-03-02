From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Thu, 2 Mar 2006 14:48:25 +0100
Message-ID: <du6t39$be5$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kasper Dupont <48755289462761382922@expires.02.sep.2006.kasperd.net> wrote:
> A bit too aggressive it seems. How can it end up being marked
> clean when the two mirrors differ?

Do you have write-cache enabled on the mirrors?

Sometimes I have differences between RAID1 mirrors in 2.4, too. Even with
clean shutdown or reboot sequences. However, in my case, it turns out
that this always affects areas which are "free" on the filesystem layer.
This assumption is especially feeded by
a) the fact that the content of at least one of these differing areas is
typically zeroed and
b) that I have md5sums of all my files which don't show up any
differences when I either copy the non-zero content over the zeros or the
other way around.
Especially I have never experienced such "normal" differences on my swap
RAID1 mirrors. Until now I thought this would have to do with kernel 2.4
and block-device-specific dirty-page-flushing and missing write-barriers
and things like that which lead to blocks used for a short time only get
flushed to the one mirror but not to the other (and then, since they are
freed again, the flush to the other mirror will never happen, since the
associated pages are just not dirty anymore).
However, I thought - at least until now ;) - this would change with 2.6,
since there md has more control over the block-devices it uses.


regards
   Mario
-- 
The question of whether a computer can think is no more interesting than
the question of whether a submarine can swim.          -- E. W. Dijkstra

