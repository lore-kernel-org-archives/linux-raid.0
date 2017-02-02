From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] MD: add doc for raid5-cache
Date: Thu, 02 Feb 2017 11:37:55 +1100
Message-ID: <87mve5xw9o.fsf@notabene.neil.brown.name>
References: <25051bd79d94b45c7be24ce466a8b6eb2fba66c0.1485890144.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25051bd79d94b45c7be24ce466a8b6eb2fba66c0.1485890144.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: antlists@youngman.org.uk, philip@turmel.org, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31 2017, Shaohua Li wrote:

> I'm starting document of the raid5-cache feature. Please let me know
> what else we should put into the document. Of course, comments are
> welcome!
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  Documentation/md/raid5-cache.txt | 99 ++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 99 insertions(+)
>  create mode 100644 Documentation/md/raid5-cache.txt
>
> diff --git a/Documentation/md/raid5-cache.txt b/Documentation/md/raid5-ca=
che.txt
> new file mode 100644
> index 0000000..17a6279
> --- /dev/null
> +++ b/Documentation/md/raid5-cache.txt
> @@ -0,0 +1,99 @@
> +RAID5 cache
> +
> +Raid 4/5/6 could include an extra disk for data cache. The cache could be
> +in write-through or write-back mode. mdadm has a new option

"can" fits better than "could".  "could" suggests past-tense: something
that was true before but might have changed.

> +'--write-journal' to create array with cache. By default (raid array
> +starts), the cache is in write-through mode. User can switch it to
> +write-back mode by:

I think "The user" or "A user" is better than just "User".


> +
> +echo "write-back" > /sys/block/md0/md/journal_mode
> +
> +And switch it back to write-through mode by:
> +
> +echo "write-through" > /sys/block/md0/md/journal_mode
> +
> +In both modes, all writes to the array will hit cache disk first. This m=
eans
> +the cache disk must be fast and sustainable (if you use a SSD as the cac=
he).

"(if you use a SSD as the cache)"

Are you trying to say "You should normally use an SSD or similar for the
cache", or is this really a condition: "If you use an SSD as the cache,
then ...."??


> +
> +-------------------------------------
> +write-through mode:
> +
> +This mode mainly fixes 'write hole' issue. For RAID 4/5/6 array, an
                         ^the


> +unclean shutdown could cause data in some stripes is not in consistent
                    can                             to not be in a consiste=
nt


> +state, eg, data and parity don't match. The reason is a stripe write
                                                    is that a
> +involves several raid disks and it's possible writes don't hit all raid
> +disks yet before the unclean shutdown. After an unclean shutdown, MD try
                                                                        tri=
es
> +to 'resync' the array to put all stripes back into consistent state. In
> +the resync, any disk failure will cause real data corruption. This probl=
em
                               could cause
The write hole often won't cause corruption, but it is a real
possibility. So "it could ..."
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
> +is called 'write hole'. So the 'write hole' issue occurs between unclean
> +shutdown and 'resync'. This window isn't big.

I don't think this is the best way to explain the write hole.
If the array is already degraded, there is no window at all.  A crash
of a degraded array exposes you to the chance of data corruption due to
the write hole.

>                                                 On the other hand, if one
> +disk fails, other disks could fail soon, which happens sometimes if the
> +disks are from the same vendor and manufactured in the same time. This
> +will increase the chance of 'write whole', but overall the chance isn't
> +big, so don't panic even not using cache disk.

I don't think you really need to talk about the "two drive failure" case
at all - it isn't relevant.
Just focus on "system crash while array is degraded", and mention that
if the array becomes degraded before resync completes, the write hole
still applies.

> +
> +The write-through cache will cache all data in cache disk first. Until t=
he
> +data hits into the cache disk, the data is flushed into RAID disks. The

Drop "into".  Just "data hits the cache disk"..
Also use "After", not "Until".
I wouldn't say "hit" either - it is colloquial.

 After the data is safe on the cache disk, the data will be flushed onto
 the RAID disks.

This implies that the cache disk is not one of the RAID disks.  I do
prefer to think if it that way, but your opening statement suggest that a
RAID5 can "include" another disk for the cache.  That suggests that the
cache disk is part of the RAID... so it would be a RAID disk.

I think it is important to get this terminology right to avoid
confusion.  An array can have several RAID disks which can be
supplemented with a cache disk. (That is how you talk about them later).

> +two-step write will guarantee MD can recover correct data after unclean
> +shutdown even with disk failure. Thus the cache can close the 'write
> +hole'.
> +
> +In write-through mode, MD reports IO finish to upper layer (usually

"IO finished", or "IO completion". (same changed needed twice more below)

> +filesystems) till the data hits RAID disks, so cache disk failure doesn't

"after", not "till". (and "is safe on", rather than "hits").

> +cause data lost. Of course cache disk failure means the array is exposed

"cause data loss". or "cause data to be lost".

> +into 'write hole' again.

"expose to", not "exposed into".

> +
> +--------------------------------------
> +write-back mode:
> +
> +write-back mode fixes the 'write hole' issue too, since all write data is
> +cached in cache disk. But the main goal of 'write-back' cache is to spee=
d up
> +write. If a write crosses all raid disks of a stripe, we call it full-st=
ripe
> +write. For non-full-stripe write, MD must do a read-modify-write. The ex=
tra
> +read (for data in other disks) and write (for parity) introduce a lot of

The parity write is not an extra write.  The only extras are reads.
The main cause of slowdown is the need to wait for the reads before the
parity calculation can happen.  i.e. the fact that the reads are
synchronous is important.
  For non-full-stripe writes, MD must read old data before the new
  parity can be calculated.  These synchronous reads hurt write
  throughput.

maybe.


> +overhead. Some writes which are sequential but not dispatched in the sam=
e time
> +will suffer from this overhead too. write-back cache will aggregate the =
data
> +and flush the data to raid disks till the data becomes a full stripe wri=
te.

... flush the data to the RAID disks only after the data becomes...

> +This will completely avoid the overhead, so it's very helpful for some
> +workloads. A typical workload which does sequential write and follows fs=
ync is
> +an example.

 "which does sequential writes followed by fsync() is an example".
=20
> +
> +In write-back mode, MD reports IO finish to upper layer (usually filesys=
tems)
> +right after the data hit cache disk. The data is flushed to raid disks l=
ater
> +after specific conditions met. So cache disk failure will cause data los=
t.
> +
> +--------------------------------------
> +The implementation:
> +
> +The write-through and write-back cache use the same disk format. The cac=
he disk
> +is organized as a simple write log. The log consists of 'meta data' and =
'data'
> +pairs. The meta data describes the data. It also includes checksum and s=
equence
> +ID for recovery identification. Data could be IO data and parity data. D=
ata is
> +checksumed too. The checksum is stored in the meta data ahead of the dat=
a. The
> +checksum is an optimization because MD can write meta and data freely wi=
thout
> +worry about the order. MD superblock has a field pointed to the valid me=
ta data
> +of log head.
> +
> +The log implementation is pretty straightforward. The difficult part is =
the
> +order MD write data to cache disk and raid disks. Specifically, in

 "the order in which MD writes data to the cache disk and the RAID disks".

> +write-through mode, MD calculates parity for IO data, writes both IO dat=
a and
> +parity to the log, write the data and parity to raid disks after the dat=
a and
                      writes

> +parity is settled down in log and finally the IO is finished. Read just =
reads
> +from raid disks as usual.
> +
> +In write-back mode, MD writes IO data to the log and reports IO finish. =
The
> +data is also fully cached in memory at that time, which means read must =
query
> +memory cache. If some conditions are met, MD will flush the data to raid=
 disks.
> +MD will calculate parity for the data and write parity into the log. Aft=
er this
> +is finished, MD will write both data and parity into raid disks, then MD=
 can
> +release the memory cache. The flush conditions could be stripe becomes a=
 full
> +stripe write, free cache disk space is low or in-kernel memory cache spa=
ce is
> +low.
> +
> +After an unclean shutdown, MD does recovery. MD reads all meta data and =
data
> +from the log. The sequence ID and checksum will help us detect corrupted=
 meta
> +data and data. If MD finds a stripe with data and valid parities (1 pari=
ty for
> +raid4/5 and 2 for raid6), MD will write the data and parities to raid di=
sks. If
> +parities are incompleted, they are discarded. If part of data is corrupt=
ed,
> +they are discarded too. MD then loads valid data and writes them to raid=
 disks
> +in normal way.

Good work,
thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliSf2MACgkQOeye3VZi
gbkZXBAAvidcOKRPvJrSRRBPEL5YNGTIsA4IJJOSED5JWsUbdvKR+eR4tn1hCYOQ
eKm52QTNeh5vvLafCvOmcdQO6MyRNXVBa7XNNVhs1/Zh+aFFuyrawRcSVnnP0bmL
6djDAoz6yqtQmqng1VNISKpQR2M+djEwXdSmMznELymrMIzNwJboQmWg/RM2XCqS
uy6qc2E5ISU+whZCQo4QDDufxSxlFt/zp8HVdbbqP1063rs0YZWAzY4q9wzeGAO8
VajZ9iiSNxdMcL5N5VavdH9pColOSnk482GetYYsr3KbkclSa9DiJPGIk+cW75uE
/K79pcnVP/RVnqWpRFRgAoXpEIdq8LEUIjmeLClu5KeetZTo1u3RmHvE/H9YvV06
VOaMZvpULvCFbfcCJf3N5JXl8gg4hE2M61x3aDkHbxqnt0IqA1BbnWVBdQLs2hAg
e1hdIHkb0BdkiBU5IMsXGlxN/03GDHWZGmp2ueld+DHu88nEAAcBxgGQ4AI03Irc
qqsw3fI7pF+LgVhJterf9l7ynKB8cT6JJld8fjaoK+a3icmDTGoPWYyhh9RmAf25
xWEU3DfmMtTO8Ayc3vd+04MZ44bv5/t3CU3OctT7W6BPQyDBpTzPBY/leeKYt81s
cwM8UGMbAvBBVBK6fnJ0oLrBGVOW1I6oF3y0BgUf1OmqJkQK9bI=
=PS77
-----END PGP SIGNATURE-----
--=-=-=--
