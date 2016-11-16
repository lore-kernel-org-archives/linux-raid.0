From: Wols Lists <antlists@youngman.org.uk>
Subject: Just a thought - linux raid wiki - raid 5 grows getting stuck at 0%
Date: Wed, 16 Nov 2016 23:51:01 +0000
Message-ID: <582CF0E5.2030605@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've just been doing a bit of work on the wiki when I put 2 and 2
together, and hope I haven't made 5 ...

Bitmaps interfere with grow operations, I believe ...

And mdadm has recently been modified so that bitmaps are switched on by
default, I also believe ...

Could this be silently blocking the grow, so you don't get any error and
it just sits there doing nothing?

But that brings up two points. Should mdadm now explicitly look for a
bitmap when growing an array, and warn that the bitmap needs to be
disabled? Apparently it currently comes up with some errors that hint at
the cause rather than explicitly say so.

And secondly, I'm sure someone sent an email to the list that explained
when a bitmap was created. I can't find it in my archives. The man page
says it's created if the array is over 100G, but I'm sure the email gave
rather more detail than that and that the figure actually varied.

But I'm sure you can see from this that I'm updating this bit of the
wiki. Is there anything else I ought to know about bitmaps, so I can
document it? :-)

Cheers,
Wol
