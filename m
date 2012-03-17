From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Sat, 17 Mar 2012 15:35:06 +0000
Message-ID: <20324.44842.473837.511238@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

[ ... ]

> I've read a recommendation to start the partition on the 1MB
> mark. Does this make sense?

As a general principle it is good, that has almost no cost.
Indeed recent versions of some partitionig tools do that by
default.

I often recommend aligning partitions to 1GiB, also because I
like to have 1GiB or so of empty space at the very beginning and
end of a drive.

> I'd like to read about the NFS blog entry but the link you
> included results in a 404.  I forgot to mention in my last
> reply.

Oops I forgot a bit of the URL:
  http://www.sabi.co.uk/blog/0707jul.html#070701b

Note that currently I suggest different values from:

 =ABvm/dirty_ratio                  =3D4
  vm/dirty_background_ratio       =3D2=BB

Because:

  * 4% of memory "dirty" today is often a gigantic amount.
    I had provided an elegant patch to specify the same in
    absolute terms in
      http://www.sabi.co.uk/blog/0707jul.html#070701
    but now the official way is the "_bytes" alternative.

  * 2% as the level at which writing becomes uncached is too
    low, and the system become unresposive when that level is
    crossed. Sure it is risky, but, regretfully, I think that
    maintaining responsiveness is usually better than limiting
    outstanding background writes.

> Based on what I understood from your thoughts above, if an
> applications issues a flush/fsync and it does not complete due
> to some catastrophic crash, xfs on its own can not roll back
> to the prev version of the file in case of unfinished write
> operation. disabling the device caches wouldn't help either
> right?

If your goal is to make sure incomplete updates don't get
persisted, disabling device caches might help with that, in a
very perverse way (if the whole partial update is still in the
device cache, it just vanishes). Forget that of course :-).

The main message is that filesystems in UNIX-like system should
not provide atomic transactions, just the means to do them at
the applications level, because they are both difficult and very
expensive.

The secondary message is that some applications and the firmware
of some host adpters and drives don't do the right thing, and
if your really want to make sure about atomic transactions it is
an expensive and difficult system integration challenge.

> [ ... ] only filesystems that do COW can do this at the
> expense of performance? (btrfs and zfs, please hurry and grow
> up!)

=46ilesystems that do COW sort-of do *global* "rolling" updates,
that is filtree level snapshots, but that's a side effect of a
choice made for other reasons (consistency more than currency).

> [ ... ] If you were in my place with the resource constraints,
> you'd go with: xfs with barriers on top of mdraid10 with
> device cache ON and setting vm/dirty_bytes, [ ... ]

Yes, that seems a reasonable overall tradeoff, because XFS is
implemented to provide well defined (and documented) semantics,
to check whether the underlying storage layer actually does
barriers, and to perform decently even if "delayed" writing is
not that delayed.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
