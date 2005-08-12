From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH md 006 of 6] Add write-behind support for md/raid1
Date: Fri, 12 Aug 2005 09:22:52 +0300
Message-ID: <200508120922.52689.a1426z@gawab.com>
References: <20050811171720.10115.patches@notabene> <E1E37OV-0002jU-9q@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1E37OV-0002jU-9q@notabene.cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>, Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> If a device is flagged 'WriteMostly' and the array has a bitmap,
> and the bitmap superblock indicates that write_behind is allowed,
> then write_behind is enabled for WriteMostly devices.

Nice, but why is it dependent on WriteMostly?

> This requires memory allocation to make a local copy of the data
> being written.  If there is insufficient memory, then we fall-back
> on normal write semantics.

Good!

Also, it would be nice to have something like:
echo 1 > /proc/md../../WriteBehindEnabled
echo 10 > /proc/md../../WriteBehindMaxDelayBeforeSync

Thanks!

--
Al

