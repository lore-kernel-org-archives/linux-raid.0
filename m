From: NeilBrown <neilb@suse.de>
Subject: Re: md raid performance with 3-18-rc3
Date: Wed, 3 Dec 2014 16:19:54 +1100
Message-ID: <20141203161954.2515740d@notabene.brown>
References: <5472E7DE.5070702@caviumnetworks.com>
	<20141125133742.0154a4d4@notabene.brown>
	<54758B3B.5080907@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/S_QvUaUpoAl=EPL19ZM5znJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54758B3B.5080907@caviumnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manish Awasthi <manish.awasthi@caviumnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/S_QvUaUpoAl=EPL19ZM5znJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2014 13:41:39 +0530 Manish Awasthi
<manish.awasthi@caviumnetworks.com> wrote:

>=20
> On 11/25/2014 08:07 AM, NeilBrown wrote:
> > On Mon, 24 Nov 2014 13:40:06 +0530 Manish Awasthi
> > <manish.awasthi@caviumnetworks.com> wrote:
> >
> >> Hi,
> >>
> >> We benchmarked the md raid driver performance on 3-18-rc3 kernel and
> >> compared the results with that of 3.6.11. The reason for this exercise
> >> is to understand if multithreaded raid driver has any performance
> >> benefits over 3.6.11 which is single threaded. Here are some details
> >> about the setup
> > Thanks for doing this!!!! I love it when people report test results.
> >
> >
> >> System: Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz 4 cores (8threads),
> >> 8GB RAM.
> >> Setup: 3 SSDs create a raid5 array
> >> test tool: iozone (only read/re-read, write/re-write tested), blocksiz=
e:
> >> 4k-64k, filesize: 1Gig to 200Gig
> >>
> >> Comparison was done for speed of data transfer in kBytes/sec and also
> >> the CPU utilization as reported by iozone.
> >>
> >> raid on 3.18.0-rc3 performed much worse than raid on 3.6.11.
> >>
> >> Read/Write: raid on 3.18.0-rc3 operated at almost half the speed of ra=
id
> >> on 3.6.11
> > That really isn't very good.... Can you try some of the kernels in betw=
een
> > and see if there was a single point where performance dropped, or if th=
ere
> > were several steps?
> Can you give me some starting point when multithread support for raid=20
> was added. It might be a good starting point. For instance, I have a=20
> benchmark on 3.6.11, now I'd like to go to the first kernel that has=20
> support for multithread raid and then take it from there.

Multi-thread support appeared in 3.12.


> >
> >
> >> CPU Utilization: With md raid on 3.18.0-rc3, the CPU utilization was
> >> less than half of md raid on 3.6.11 on WRITE operations. However, for
> >> READ operations, 3.18-0.rc3 had more CPU utilization than 3.6.11.
> > Can you use "perf" to determine where the extra time is going?
> >
> >    perf record
> >    run test
> >    stop perf
> >    perf report
> >
> > or something like that.
> I can do this but as I mentioned below, Its better if I can get to=20
> understand all the possible tweaks that can be done to get the optimal=20
> results unless ofcourse you expect 3.18.0 to perform better than that of=
=20
> 3.6.11 even if default case without any tweaks.

I have no particular expectations.  I like to see concrete measurements and
then try to interpret them.

I prefer to compare default setting (no tweaks) in the first instance.
Because that is what most people will be using.


> >
> >> Also, I noticed that scaling up the CPU cores of the system scales down
> >> the raid througput with 3.18.0-rc3.
> > This is by writing numbers to "group_thread_cnt" ??? Can you provide a =
simple
> > table comparing thread count to throughput?  Or maybe a graph.  I love
> > graphs :-)
> I did not tweak anything on the 3.18.0 kernel. I assumed all the=20
> required support is built-in and did not bother to go into the depth of=20
> the code as we're still in nascent stages where we are comparing the=20
> data on specific kernel versions. Can you point me to some text that can=
=20
> describe tweaks like "group_thread_cnt" etc?

Multi-threading is disabled by default, so if you haven't explicitly enabled
it, then it cannot be affecting your performance.

If you
  echo 8 > /sys/block/mdXXX/md/group_thread_cnt

it will use 8 thread to perform 'xor' calculations and submit IO requests.


> >
> >> I do have detailed logs of the comparison but I'm not sure I should se=
nd
> >> those on this mailing list.
> > A few megabytes?  Yes.  100Meg?  No.
>=20
> Whatever data I have on comparison is attached, I have consolidated this=
=20
> from log files to excel. See if this helps.

Thanks.  I'll have a look at the tables and see if anything looks interesti=
ng.

Thanks,
NeilBrown



> >
> > If you could put them on a website somewhere that I can browse or downl=
oad
> > I'll try to have a look.
> >
> >> If my observation aligns with someone else's, then what is really the
> >> gain with multithreaded raid.
> > Some testing shows real improvements.  Obviously we cannot test everyth=
ing
> > and I'm very glad to have extra testing from other people.
> > If we can quantify the regressions and confirm exactly when they occurr=
ed, we
> > can start looking for a solution.
> >
> > Thanks a lot!
> >
> > NeilBrown
> >
> >
> >> Manish
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Sig_/S_QvUaUpoAl=EPL19ZM5znJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVH6dejnsnt1WYoG5AQLaBhAArt/+KdAZwR6olZYCaMRPh4ogiX6207gN
8Qnp32MUx7pWwLUClSVHpX6rZ2IVAfKYXSeLkodhsdx8DJRxZyQ8DRiV5z43rGrU
uzLziTJZr0KXuQiVqrSdivgXISfNJLQGXQwb85DyhKMjKf5vyyXziWbgAQmP4Z/1
sfspM5vHIxj8AVpbBxZuIEj6mezLvHxy3ASVNSLnweCpCs5v+mJm8NJ+v4Ex58y1
YW6SO3SIsgS9LadmiEjjy+uYb1yMFgjz1HDpuf62bdfCUxS2vmMqX2n6VRM3W9Jm
LHX6wo0ehgZ5TXAyEoZQbFemKpN2D2G14w0/ujGuhsQsZAmEbNKlZI9Hh4KuCE2Z
tS7SK0E0v9UZXWOALhJ8+QKjIWru28KLSvlYWWjcbQc5CADUlj8gIrkbdpv+VJiO
lG/l4622xy+xusT3jk/m/IPK2y+XTAWHW9EQL2dqbfDM4r4ajF35LTwC15vT8VDZ
OrDQxrhHTzyo08WTlyRBse+8FwBQKBHWFNqL0B9uUKZ6ltN9+7I+KQ49vMKX91kV
c04tFhKS8q+1Mty5Zhl/qaMnmAiAexu+Wf5VowOIWynuN91j5qxEsKg/ZHzv1tTE
mLOjIK/boKVKu061ZYX5sLZ7pVsKNN1Zy1FGajTuu9wdEwckI5/m6ZFA4dgAwKdu
G2pzM8DQHow=
=3Bdf
-----END PGP SIGNATURE-----

--Sig_/S_QvUaUpoAl=EPL19ZM5znJ--
