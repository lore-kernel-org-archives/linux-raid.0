From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid5: switching cache buffer size
Date: Fri, 13 Dec 2002 22:29:05 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0212132225230.14048-100000@unicorn.drogon.net>
References: <3DFA2E2A.20601@comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DFA2E2A.20601@comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for the replies - I've also been searching the archives of both the
raid and lvm lists and found some more on it. It seems OK until I take a
snapshot, so need to look more into the lvm stuff if I'm going to continue
using it, but I'm starting to think that lvm on raid5 might be more hassle
than it's worth, and I managed to get it to crash too when using
dump/restore and (s)tar to a SCSI tape system while running an lvm
snapshot. I'm now thinking that as I have enough disk space, I'd be better
off with 3 raid5 partitions and simply copy the data from the life
partition onto the 'yesterday' partition every night rather than use the
lvm snapshot facility...

(I was using ext2 btw, was thinking about XFS, but maybe that'd just be
too much for the system!!!)

Cheers,

Gordon

