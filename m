From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md: bug in file raid5.c, line 540 (kernel 2.4.20)
Date: Mon, 14 Apr 2003 08:58:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16025.60290.947267.144414@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.53.0304140015310.24622@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Monday April 14
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 14, raid@a2000.nu wrote:
> trying to do a raidsetfaulty on my hotspare disk (i was trying to see if i
> would get any email from mdadm --monitor)

1/ The only real BUG here is the fact that it prints out a confusing
message.  The real meaning of "bug in file raid5.c, line 540" is "I
got a failure message on a drive that I wasn't even using".

2/ A hot spare cannot fail in 'real life' as it is not being
used. i.e. you cannot fail to do something when you are not being
asked to do anything.
So no, mdadm won't report it, as it cannot happen.

(I'm not saying that a hot spare cannot fail.  I might suddenly catch
on fire for all I know.  But there is no sense in which that is a
meaningful failure for md.)

NeilBrown
