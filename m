From: "Andris Berzins" <pkix@inbox.lv>
Subject: Re: failed raid re-create changed dev size
Date: Tue, 11 Dec 2012 16:35:15 +0200
Message-ID: <1355236515.50c744a3720c1@mail.inbox.lv>
References: <1355216495.50c6f66f123b1@mail.inbox.lv>
 <20121211092710.GA28593@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121211092710.GA28593@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting "Robin Hill" <robin@robinhill.me.uk>:
>>> I don't know off the top of my head how to change the mdadm data offset
>>> unfortunately.
>>> 
> There's no way in the current mdadm releases to do so. Neil does have a
> version in git which will allow specifying the data offsets on a
> disk-by-disk basis (as it is possible to have multiple offsets within an
> array). If all the disks in your array were using an offset of 2048
> though, then you'll just need to downgrade mdadm to 3.2.3 (or slightly
> earlier) - from what I can find it was changed to 262144 for 3.2.4 (it
> was 272 pre version 3.0, so don't go any further back than that).

Downgraded to mdadm version 3.2.3 and re-created array successfully!

> 
> You will likely have lost some data though, as the new superblocks will
> have overwritten part of the data, so make sure you run a fsck
> afterwards (start with fsck -n though, to make sure the overall array
> looks okay first).

Is it possible that no data was damaged? It is LUKS partition, i mapped it and run "fsck -n" on underlying ext3 partition, 
but fsck returned immediately with status "clean".


> Good luck (and please make sure you try just forcing an assemble next
> time),

I will try to contact these blog authors, who suggested to re-create failed array instead of forcing an assemble, to make a 
notice on their blogs.


> Robin
> --
> ___
> ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
> / / )      | Little Jim says ....                            |
> // !!       |      "He fallen in de water !!"                 |

