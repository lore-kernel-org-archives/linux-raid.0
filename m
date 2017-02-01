From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] MD: add doc for raid5-cache
Date: Wed, 1 Feb 2017 17:54:35 +0000
Message-ID: <15D1A7BF-3CB4-4189-8AD2-93EFC35C1D27@fb.com>
References: <25051bd79d94b45c7be24ce466a8b6eb2fba66c0.1485890144.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25051bd79d94b45c7be24ce466a8b6eb2fba66c0.1485890144.git.shli@fb.com>
Content-Language: en-US
Content-ID: <41D397DB85FCB142A7B1E27750B6BF05@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "antlists@youngman.org.uk" <antlists@youngman.org.uk>, "philip@turmel.org" <philip@turmel.org>, "neilb@suse.com" <neilb@suse.com>
List-Id: linux-raid.ids


> On Jan 31, 2017, at 11:18 AM, Shaohua Li <shli@fb.com> wrote:
>=20
> I'm starting document of the raid5-cache feature. Please let me know
> what else we should put into the document. Of course, comments are
> welcome!
>=20
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
> Documentation/md/raid5-cache.txt | 99 +++++++++++++++++++++++++++++++++++=
+++++
> 1 file changed, 99 insertions(+)
> create mode 100644 Documentation/md/raid5-cache.txt
>=20
> diff --git a/Documentation/md/raid5-cache.txt b/Documentation/md/raid5-ca=
che.txt
> new file mode 100644
> index 0000000..17a6279
> --- /dev/null
> +++ b/Documentation/md/raid5-cache.txt
> @@ -0,0 +1,99 @@
> +RAID5 cache
> +
> +Raid 4/5/6 could include an extra disk for data cache. The cache could b=
e
> +in write-through or write-back mode. mdadm has a new option
> +'--write-journal' to create array with cache. By default (raid array
> +starts), the cache is in write-through mode. User can switch it to
> +write-back mode by:
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
> +
> +-------------------------------------
> +write-through mode:
> +
> +This mode mainly fixes 'write hole' issue. For RAID 4/5/6 array, an
> +unclean shutdown could cause data in some stripes is not in consistent
> +state, eg, data and parity don't match. The reason is a stripe write
> +involves several raid disks and it's possible writes don't hit all raid
> +disks yet before the unclean shutdown. After an unclean shutdown, MD try
> +to 'resync' the array to put all stripes back into consistent state. In
> +the resync, any disk failure will cause real data corruption. This probl=
em
> +is called 'write hole'. So the 'write hole' issue occurs between unclean
> +shutdown and 'resync'. This window isn't big. On the other hand, if one
> +disk fails, other disks could fail soon, which happens sometimes if the
> +disks are from the same vendor and manufactured in the same time. This
> +will increase the chance of 'write whole', but overall the chance isn't
> +big, so don't panic even not using cache disk.
> +
> +The write-through cache will cache all data in cache disk first. Until t=
he
> +data hits into the cache disk, the data is flushed into RAID disks. The
> +two-step write will guarantee MD can recover correct data after unclean
> +shutdown even with disk failure. Thus the cache can close the 'write
> +hole'.
> +
> +In write-through mode, MD reports IO finish to upper layer (usually
> +filesystems) till the data hits RAID disks, so cache disk failure doesn'=
t
> +cause data lost. Of course cache disk failure means the array is exposed
> +into 'write hole' again.
> +
> +--------------------------------------
> +write-back mode:
> +
> +write-back mode fixes the 'write hole' issue too, since all write data i=
s
> +cached in cache disk. But the main goal of 'write-back' cache is to spee=
d up
> +write. If a write crosses all raid disks of a stripe, we call it full-st=
ripe
> +write. For non-full-stripe write, MD must do a read-modify-write. The ex=
tra
> +read (for data in other disks) and write (for parity) introduce a lot of
> +overhead. Some writes which are sequential but not dispatched in the sam=
e time
> +will suffer from this overhead too. write-back cache will aggregate the =
data
> +and flush the data to raid disks till the data becomes a full stripe wri=
te.
> +This will completely avoid the overhead, so it's very helpful for some
> +workloads. A typical workload which does sequential write and follows fs=
ync is
> +an example.
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
> +write-through mode, MD calculates parity for IO data, writes both IO dat=
a and
> +parity to the log, write the data and parity to raid disks after the dat=
a and
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
> --=20
> 2.9.3
>=20

Looks great!

Reviewed-by: Song Liu <songliubraving@fb.com>


