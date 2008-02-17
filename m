From: Beolach <beolach@gmail.com>
Subject: RAID5 to RAID6 reshape?
Date: Sat, 16 Feb 2008 20:58:07 -0700
Message-ID: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I'm a newbie to RAID, planning a home fileserver that will be pretty
much my first real time using RAID.  What I think I'd like to do is
start w/ 3 drives in RAID5, and add drives as I run low on free space,
eventually to a total of 14 drives (the max the case can fit).  But
when I add the 5th or 6th drive, I'd like to switch from RAID5 to
RAID6 for the extra redundancy.  As I've been researching RAID
options, I've seen that RAID5 to RAID6 migration is a planned feature,
but AFAIK it isn't implemented yet, and the most recent mention I
found was a few months old.  Is it likely that RAID5 to RAID6
reshaping will be implemented in the next 12 to 18 months (my rough
guesstimate as to when I might want to migrate from RAID5 to RAID6)?
Or would I be better off starting w/ 4 drives in RAID6?

I'm also interested in hearing people's opinions about LVM / EVMS.
I'm currently planning on just using RAID w/out the higher level
volume management, as from my reading I don't think they're worth the
performance penalty, but if anyone thinks that's a horrible mistake
I'd like to know sooner rather than later.

And if anyone has comments on good hardware to consider or bad
hardware to avoid, here's what I'm currently planning on getting:
<http://secure.newegg.com/NewVersion/wishlist/PublicWishDetail.asp?WishListNumber=6134331>


TIA,
Conway S. Smith
