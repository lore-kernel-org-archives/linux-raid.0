From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Mon, 20 Feb 2017 10:42:09 +1100
Message-ID: <87vas5sq7i.fsf@notabene.neil.brown.name>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <87shnevcpr.fsf@notabene.neil.brown.name> <20170217194117.cgbdm247p5p4gj6v@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170217194117.cgbdm247p5p4gj6v@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>
Cc: colyli@suse.de, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17 2017, Shaohua Li wrote:

> On Thu, Feb 16, 2017 at 06:04:00PM +1100, NeilBrown wrote:
>> On Thu, Feb 16 2017, colyli@suse.de wrote:
>>=20
>> > 'Commit 79ef3a8aa1cb ("raid1: Rewrite the implementation of iobarrier.=
")'
>> > introduces a sliding resync window for raid1 I/O barrier, this idea li=
mits
>> > I/O barriers to happen only inside a slidingresync window, for regular
>> > I/Os out of this resync window they don't need to wait for barrier any
>> > more. On large raid1 device, it helps a lot to improve parallel writing
>> > I/O throughput when there are background resync I/Os performing at
>> > same time.
>> >
>> > The idea of sliding resync widow is awesome, but code complexity is a
>> > challenge. Sliding resync window requires several veriables to work
>>=20
>> variables
>>=20
>> > collectively, this is complexed and very hard to make it work correctl=
y.
>> > Just grep "Fixes: 79ef3a8aa1" in kernel git log, there are 8 more patc=
hes
>> > to fix the original resync window patch. This is not the end, any furt=
her
>> > related modification may easily introduce more regreassion.
>> >
>> > Therefore I decide to implement a much simpler raid1 I/O barrier, by
>> > removing resync window code, I believe life will be much easier.
>> >
>> > The brief idea of the simpler barrier is,
>> >  - Do not maintain a logbal unique resync window
>>=20
>> global
>>=20
>> >  - Use multiple hash buckets to reduce I/O barrier conflictions, regul=
ar
>>=20
>> conflicts
>>=20
>> >    I/O only has to wait for a resync I/O when both them have same barr=
ier
>> >    bucket index, vice versa.
>> >  - I/O barrier can be recuded to an acceptable number if there are eno=
ught
>>=20
>> reduced
>> enough
>>=20
>> >    barrier buckets
>> >
>> > Here I explain how the barrier buckets are designed,
>> >  - BARRIER_UNIT_SECTOR_SIZE
>> >    The whole LBA address space of a raid1 device is divided into multi=
ple
>> >    barrier units, by the size of BARRIER_UNIT_SECTOR_SIZE.
>> >    Bio request won't go across border of barrier unit size, that means
>>=20
>> requests
>>=20
>> >    maximum bio size is BARRIER_UNIT_SECTOR_SIZE<<9 (64MB) in bytes.
>> >    For random I/O 64MB is large enough for both read and write request=
s,
>> >    for sequential I/O considering underlying block layer may merge them
>> >    into larger requests, 64MB is still good enough.
>> >    Neil also points out that for resync operation, "we want the resync=
 to
>> >    move from region to region fairly quickly so that the slowness caus=
ed
>> >    by having to synchronize with the resync is averaged out over a fai=
rly
>> >    small time frame". For full speed resync, 64MB should take less the=
n 1
>> >    second. When resync is competing with other I/O, it could take up a=
 few
>> >    minutes. Therefore 64MB size is fairly good range for resync.
>> >
>> >  - BARRIER_BUCKETS_NR
>> >    There are BARRIER_BUCKETS_NR buckets in total, which is defined by,
>> >         #define BARRIER_BUCKETS_NR_BITS   (PAGE_SHIFT - 2)
>> >         #define BARRIER_BUCKETS_NR        (1<<BARRIER_BUCKETS_NR_BITS)
>> >    this patch makes the bellowed members of struct r1conf from integer
>> >    to array of integers,
>> >         -       int                     nr_pending;
>> >         -       int                     nr_waiting;
>> >         -       int                     nr_queued;
>> >         -       int                     barrier;
>> >         +       int                     *nr_pending;
>> >         +       int                     *nr_waiting;
>> >         +       int                     *nr_queued;
>> >         +       int                     *barrier;
>> >    number of the array elements is defined as BARRIER_BUCKETS_NR. For =
4KB
>> >    kernel space page size, (PAGE_SHIFT - 2) indecates there are 1024 I=
/O
>> >    barrier buckets, and each array of integers occupies single memory =
page.
>> >    1024 means for a request which is smaller than the I/O barrier unit=
 size
>> >    has ~0.1% chance to wait for resync to pause, which is quite a small
>> >    enough fraction. Also requesting single memory page is more friendl=
y to
>> >    kernel page allocator than larger memory size.
>> >
>> >  - I/O barrier bucket is indexed by bio start sector
>> >    If multiple I/O requests hit different I/O barrier units, they only=
 need
>> >    to compete I/O barrier with other I/Os which hit the same I/O barri=
er
>> >    bucket index with each other. The index of a barrier bucket which a
>> >    bio should look for is calculated by sector_to_idx() which is defin=
ed
>> >    in raid1.h as an inline function,
>> >         static inline int sector_to_idx(sector_t sector)
>> >         {
>> >                 return hash_long(sector >> BARRIER_UNIT_SECTOR_BITS,
>> >                                 BARRIER_BUCKETS_NR_BITS);
>> >         }
>> >    Here sector_nr is the start sector number of a bio.
>>=20
>> "hash_long() is used so that sequential writes in are region of the
>> array which is not being resynced will not consistently align with
>> the buckets that are being sequentially resynced, as described below"
>>=20
>> >
>> >  - Single bio won't go across boundary of a I/O barrier unit
>> >    If a request goes across boundary of barrier unit, it will be split=
. A
>> >    bio may be split in raid1_make_request() or raid1_sync_request(), if
>> >    sectors returned by align_to_barrier_unit_end() is small than origi=
nal
>>=20
>> smaller
>>=20
>> >    bio size.
>> >
>> > Comparing to single sliding resync window,
>> >  - Currently resync I/O grows linearly, therefore regular and resync I=
/O
>> >    will have confliction within a single barrier units. So the I/O
>>=20
>> ... will conflict within ...
>>=20
>> >    behavior is similar to single sliding resync window.
>> >  - But a barrier unit bucket is shared by all barrier units with ident=
ical
>> >    barrier uinit index, the probability of confliction might be higher
>> >    than single sliding resync window, in condition that writing I/Os
>> >    always hit barrier units which have identical barrier bucket indexs=
 with
>> >    the resync I/Os. This is a very rare condition in real I/O work loa=
ds,
>> >    I cannot imagine how it could happen in practice.
>> >  - Therefore we can achieve a good enough low confliction rate with mu=
ch
>>=20
>> ... low conflict rate ...
>>=20
>> >    simpler barrier algorithm and implementation.
>> >
>> > There are two changes should be noticed,
>> >  - In raid1d(), I change the code to decrease conf->nr_pending[idx] in=
to
>> >    single loop, it looks like this,
>> >         spin_lock_irqsave(&conf->device_lock, flags);
>> >         conf->nr_queued[idx]--;
>> >         spin_unlock_irqrestore(&conf->device_lock, flags);
>> >    This change generates more spin lock operations, but in next patch =
of
>> >    this patch set, it will be replaced by a single line code,
>> >         atomic_dec(&conf->nr_queueud[idx]);
>> >    So we don't need to worry about spin lock cost here.
>> >  - Mainline raid1 code split original raid1_make_request() into
>> >    raid1_read_request() and raid1_write_request(). If the original bio
>> >    goes across an I/O barrier unit size, this bio will be split before
>> >    calling raid1_read_request() or raid1_write_request(),  this change
>> >    the code logic more simple and clear.
>> >  - In this patch wait_barrier() is moved from raid1_make_request() to
>> >    raid1_write_request(). In raid_read_request(), original wait_barrie=
r()
>> >    is replaced by raid1_read_request().
>> >    The differnece is wait_read_barrier() only waits if array is frozen,
>> >    using different barrier function in different code path makes the c=
ode
>> >    more clean and easy to read.
>>=20
>> Thank you for putting the effort into writing a comprehensve change
>> description.  I really appreciate it.
>>=20
>> >=20=20
>> > @@ -1447,36 +1501,26 @@ static void raid1_write_request(struct mddev *=
mddev, struct bio *bio,
>> >=20=20
>> >  static void raid1_make_request(struct mddev *mddev, struct bio *bio)
>> >  {
>> > -	struct r1conf *conf =3D mddev->private;
>> > -	struct r1bio *r1_bio;
>> > +	void (*make_request_fn)(struct mddev *mddev, struct bio *bio);
>> > +	struct bio *split;
>> > +	sector_t sectors;
>> >=20=20
>> > -	/*
>> > -	 * make_request() can abort the operation when read-ahead is being
>> > -	 * used and no empty request is available.
>> > -	 *
>> > -	 */
>> > -	r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>> > +	make_request_fn =3D (bio_data_dir(bio) =3D=3D READ) ?
>> > +			  raid1_read_request : raid1_write_request;
>> >=20=20
>> > -	r1_bio->master_bio =3D bio;
>> > -	r1_bio->sectors =3D bio_sectors(bio);
>> > -	r1_bio->state =3D 0;
>> > -	r1_bio->mddev =3D mddev;
>> > -	r1_bio->sector =3D bio->bi_iter.bi_sector;
>> > -
>> > -	/*
>> > -	 * We might need to issue multiple reads to different devices if the=
re
>> > -	 * are bad blocks around, so we keep track of the number of reads in
>> > -	 * bio->bi_phys_segments.  If this is 0, there is only one r1_bio and
>> > -	 * no locking will be needed when requests complete.  If it is
>> > -	 * non-zero, then it is the number of not-completed requests.
>> > -	 */
>> > -	bio->bi_phys_segments =3D 0;
>> > -	bio_clear_flag(bio, BIO_SEG_VALID);
>> > +	/* if bio exceeds barrier unit boundary, split it */
>> > +	do {
>> > +		sectors =3D align_to_barrier_unit_end(
>> > +				bio->bi_iter.bi_sector, bio_sectors(bio));
>> > +		if (sectors < bio_sectors(bio)) {
>> > +			split =3D bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
>> > +			bio_chain(split, bio);
>> > +		} else {
>> > +			split =3D bio;
>> > +		}
>> >=20=20
>> > -	if (bio_data_dir(bio) =3D=3D READ)
>> > -		raid1_read_request(mddev, bio, r1_bio);
>> > -	else
>> > -		raid1_write_request(mddev, bio, r1_bio);
>> > +		make_request_fn(mddev, split);
>> > +	} while (split !=3D bio);
>> >  }
>>=20
>> I know you are going to change this as Shaohua wantsthe spitting
>> to happen in a separate function, which I agree with, but there is
>> something else wrong here.
>> Calling bio_split/bio_chain repeatedly in a loop is dangerous.
>> It is OK for simple devices, but when one request can wait for another
>> request to the same device it can deadlock.
>> This can happen with raid1.  If a resync request calls raise_barrier()
>> between one request and the next, then the next has to wait for the
>> resync request, which has to wait for the first request.
>> As the first request will be stuck in the queue in
>> generic_make_request(), you get a deadlock.
>> It is much safer to:
>>=20
>>     if (need to split) {
>>         split =3D bio_split(bio, ...)
>>         bio_chain(...)
>>         make_request_fn(split);
>>         generic_make_request(bio);
>>    } else
>>         make_request_fn(mddev, bio);
>>=20
>> This way we first process the initial section of the bio (in 'split')
>> which will queue some requests to the underlying devices.  These
>> requests will be queued in generic_make_request.
>> Then we queue the remainder of the bio, which will be added to the end
>> of the generic_make_request queue.
>> Then we return.
>> generic_make_request() will pop the lower-level device requests off the
>> queue and handle them first.  Then it will process the remainder
>> of the original bio once the first section has been fully processed.
>
> Good point! raid10 has the same problem. Looks this doesn't solve the iss=
ue for
> device with 3 times stack though.
>
> I knew you guys are working on this issue in block layer. Should we fix t=
he
> issue in MD side (for 2 stack devices) or wait for the block layer patch?

We cannot fix everything at the block layer, or at the individual device
layer.  We need changes in both.
I think that looping over bios in a device driver is wrong and can
easily lead to deadlocks.  We should remove that from md.
If the block layer gets fixed that way I want it to, then we could move
the generic_make_request() call earlier, so that above could be

>>     if (need to split) {
>>         split =3D bio_split(bio, ...)
>>         bio_chain(...)
>>         generic_make_request(bio);
>>         bio =3D split()
>>    }
>>    make_request_fn(mddev, bio);

which is slightly simpler.  But the original would still work.

So yes, I think we need this change in md/raid1. I suspect that if
you built a kernel with a smaller BARRIER_UNIT_SECTOR_BITS  - e.g. 4 -
you could very easily trigger a deadlock with md/raid1 on scsi.
At 17, it is not quite so easy, but is a real possibility.

I've had similar deadlocks reported before when the code wasn't quite
careful enough.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliqLVEACgkQOeye3VZi
gblH5w/8DlG2K89kuLITjLRH8/eMzM9+PdpSK1OJvgQ0imXaF3uZ5v+lAMiHh/Wp
y2o+aUe6Iw01pcxiVSlWCS1Wuck8yaOXvv6AloNCBYgPKJNsr3huJ0xKhAlr1GOK
cq48xjNcYD5vXD1UCOPduIR9M5f8iLR9kGW7xNaG7Nu5efpQ8kF1bQPWSITDsppf
G/LrcH+H2ruWq9wOnHHhVGLtDeKqmNqlJ0EEgl48i4Hkd5IuUkiJGUNL91pUCoUT
15xQZndagAN29nTlWEPjztKdQKLLStMgNLnBxjasjFmoo8u38aJIZfkdOGK7x/yb
5hsl0AgNSPIeFDNKNHkrvJbCXo5vcXSN+7ocLFCgyiVheULsyE07HxYomnuWlAH0
Vxc7h1NchOs4WcJpQ3Gs1dosgJorqmENcs4R+vMVM7IcxSjKBc8rgGLLX2x17Jf0
MZB/Nh/vn+9OMCIhA7xLoEDEu0P3co/y2h+iXPBaJdZ7bpO43ZYAD4ZpjAPxRy4k
hgFinlEMiB4FG8SVg70rPcqpis1y806rvoIYl61BBcs4D7USjK10oMefxhQ6Orix
GmXUePYV5ff8PBpARBWsaoD+yvS09WPYhhk6RMvNO/nHYT5FN7H5NhV3syGPcPHZ
eKzir9Z3xObRauPYcvMkhIAkEZLZyzJGdo9hggi6XJX/2eFbNQ4=
=ofOS
-----END PGP SIGNATURE-----
--=-=-=--
