From: linux-raid@zerog.net
Subject: Re: Raidreconf w/ 2.6.2
Date: Mon, 16 Aug 2004 16:44:13 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408161641350.11896-100000@arctic.zerog.net>
References: <412133FD.6080207@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412133FD.6080207@earthlink.net>
To: Mike Baynton <mikeb414@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mike,

Glad to know that it's helped someone else.  It's a little worrying to see
the error messages...

I believe that is the error message I received.  It appears to happen when
the disks are of differing sizes.  I think what's happening is that it
runs off of the end of one of the disks - i.e., Disk1 = 200 blocks and
Disk2 =99 blocks.  It assumes that all of the disks are the same size
instead of looking at the lowest common denominator.

Hope this helps.

-steffan-


On Mon, 16 Aug 2004, Mike Baynton wrote:

> Hi
> This is related to a message you put on linux-raid months ago
> (http://marc.theaimsgroup.com/?l=linux-raid&m=108509877724484&w=2 ). I
> am having the same problem (as near as I can tell so far all my data's
> intact using the method you suggested in that post...I had no data near
> the end of my array) but I'd like to be sure we're dealing with the same
> problem/bug before I start speculating about a bug in raidreconf on
> linux-raid.
>
> Do you remember if you got an error message like
>
> raid5_map_global_to_local: disk 0 block out of range: 2442004 (2442004)
> gblock = 7326012
> aborted (core dumped)
>
> when this happened to you?
>
> Thanks,
> Mike Baynton
>



