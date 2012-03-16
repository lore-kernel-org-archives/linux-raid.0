From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 19:28:24 +0000
Message-ID: <20323.37976.162802.876821@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<4F633121.10800@hardwarefreak.com>
	<CAKuK5J3GHgWcnYLqwRV8s_wMjO2nBVf7h=yONtn90kPn9A_3Gg@mail.gmail.com>
	<CAKuK5J11JTdwZSBWj7DH7c+hE--MVNQVVrcKXaV2AO-wEpWBog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J11JTdwZSBWj7DH7c+hE--MVNQVVrcKXaV2AO-wEpWBog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@OSS.SGI.com>
List-Id: linux-raid.ids

[ ... ]

>>> write barriers will ensure journal and thus filesystem
>>> integrity in a crash/power fail event. =A0They do NOT guarantee
>>> file data integrity as file data isn't journaled.

Not well expressed, as XFS barriers do ensure file data integrity,
*if the applications uses them* (and uses them in exactly the
right way).

The difference between metadata and data with XFS is that XFS
itself will use barriers on metadata at the right times, because
that's data to XFS, but it won't use barriers on data, leaving
that entirely to the application.

>>> =A0No filesystem (Linux anyway) journals data, only metadata.

>> That's not true, is it? ext3 and ext4 support journal=3Ddata.

They do, because they journal blocks, which is not generally a
great choice, but gives the option to journal data blocks too more
easily than other choices. But it is a very special case that few
people use.

Also, there are significant issues with 'ext3' and 'fsync' and
journaling:

http://lwn.net/Articles/328363/
 =ABThere is one other important change needed to get a truly
  quick fsync() with ext3, though: the filesystem must be
  mounted in data=3Dwriteback mode. This mode eliminates the
  requirement that data blocks be flushed to disk ahead of
  metadata; in data=3Dordered mode, instead, the amount of data to
  be written guarantees that fsync() will always be slower.
  Switching to data=3Dwriteback eliminates those writes, but, in
  the process, it also turns off the feature which made ext3
  seem more robust than ext4.=BB

On a more general note, journaling and barriers are sort of
distinct issues.

The real purpose of barriers is to ensure that updates are
actually on the recording medium, whether in the journal or
directly on final destination.
That is barriers are used to ensure that data or metadata on the
persistent layer is current.

The purpose of a journal is not to ensure that the state on the
persistent layer are *current*, but rather *consistent* (at a
lower cost than synchronous updates), without having to be
careful about the order in which the updates are made current.
The updates are made consistent by writing them to the log as
they are needed (not necessarily immediately), and then on
recovery the order gets sorted out spatially.

Currency does not imply consistency (if the updates are made
current in some arbitrary order) and consistency does not imply
currency (if the recording medium is kept consistent but updates
are applied to it infrequently).

The BSD FFS does not need a journal because it is designed to be
very careful as to the order in which updates are made current,
and log file systems don't aim for spatial currency.

> And btrfs supports COW (as does nilfs2) with "transactions",
> which should/could be similar?

Not quite. They are more like "checkpoints", that is alternate
root inodes that "snapshot" the state of the whole filetree at
some point.

These are not entirely inexpensive, and as a result as I learned
from a talk about some recent updates about the BSD FFS:

  http://www.sabi.co.uk/blog/12-two.html#120222

COW filesystems like ZFS/BTRFS/... need to have a journal too to
support 'fsync' in between checkpoints.

BTW there are now COW versions of 'ext3' and 'ext4', with
snapshotting too:

  http://www.sabi.co.uk/blog/12-two.html#120218b

The 'freeze' features of XFS does not rely on snapshotting, it
relies on suspending all processes that are writing to the
filetree, so updates are avoided for the duration.

As the XFS team have been adding or planning to add various "new"
features like checksums, maybe one day they will add COW to XFS
too (not such an easy task when considering how large XFS extents
can be, but the hole punching code can help there).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
