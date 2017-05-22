From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Mon, 22 May 2017 21:43:12 +0100
Message-ID: <87k258y65b.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
        <87o9ukykmk.fsf@esperi.org.uk> <592336E6.8080906@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <592336E6.8080906@youngman.org.uk> (Wols Lists's message of "Mon,
        22 May 2017 20:07:18 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22 May 2017, Wols Lists verbalised:

> aiui, provided you're using a v1 superblock, the data offset means there
> is spare space on the drives precisely for the purpose (one of then at
> least) of keeping a backup. So the reshape will start reshaping into the
> spare space and eliminate the need for the backup - the new version of
> the stripe will be safely written before the space occupied by the old
> stripe is required.

But it's only a few KiB by default! The amount of seeking needed to
reshape with such a small intermediate would be fairly horrific. (It was
bad enough as it was: the reshape of 7TiB took more than two days,
running at under 15MiB/s, though the component drives can all handle
220MiB/s easily. The extra time was spent seeking to and from the
backup, it seems.)

> Typically, the new layout will move the data offset, pushing the data
> block up or down.

Will it? Why? You'd need to move the data offset quite a long way to
make enough space for the 500MiB backup file I saw being created during
my last reshape.

(Though, for me, this is somewhat redundant:

    Data Offset : 262144 sectors

because I set a data offset specifically to allow reshaping without
having to move anything. Is the idea that reshaping that adds data
spindles will move the data offset such that it is (still) on a chunk or
stripe multiple? That's neat, if so, and means I wasted 128MiB on this,
uh, 12TiB array. OK I'm not terribly blown away by this, particularly
given that I'm wasting the same again inside the bcache partition for
the same reason: I'm sure mdadm won't move *that* data offset.)

-- 
NULL && (void)
