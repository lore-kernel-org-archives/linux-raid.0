From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Hints on reducing kickouts
Date: Sun, 11 Mar 2012 14:15:08 -0500
Message-ID: <20120311191508.GA28110@atlantis.cc.ndsu.nodak.edu>
References: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com> <20120301182218.GB9106@atlantis.cc.ndsu.nodak.edu> <CAOscVdKo6aU+H6xGfpMTdN_XCAVnF3V2XXuqN4V5rYBux3e3_Q@mail.gmail.com> <20120303222424.GA29339@atlantis.cc.ndsu.nodak.edu> <CAOscVdL_gTLVVHvFAQzv0XocDVH6t8oBSrqMQUHL5nH3vLQxgA@mail.gmail.com>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOscVdL_gTLVVHvFAQzv0XocDVH6t8oBSrqMQUHL5nH3vLQxgA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Obaterspok <john.obaterspok@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 11, 2012 at 07:55:10PM +0100, John Obaterspok wrote:
> Hello,
> 
> mdadm --grow /dev/md2 --bitmap=internal
> mdadm: failed to set internal bitmap.
> 
> I then tried it on md1 and this crashed my machine. (bitmap_endwrite
> <- handle_stripe)
> hmm.
> 
> I don't know what to do.

This looks like a bug that Neil commented about last week (I
deleted the thread, so can't directly forward it to you).
The thread I'm referring to can be found here:

http://marc.info/?t=133122326800004&r=1&w=2

Subject of the thread is: "invalid bitmap file superblock: bad
magic".  Neil indicated that the fix in included in the following
commit:

http://neil.brown.name/git?p=mdadm;a=commitdiff;h=6ef89052d85b8137b8a7100f761d896ae6f61001


Bryan
