From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 00:42:41 +0200
Message-ID: <isri91$fo0$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <isp2g2$rf$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/11 02:01, David Brown wrote:
> Has anyone considered triple-parity raid6 ? As far as I can see, it
> should not be significantly harder than normal raid6 - either to
> implement, or for the processor at run-time. Once you have the GF(2=E2=
=81=B8)
> field arithmetic in place for raid6, it's just a matter of making
> another parity block in the same way but using a different generator:
>
> P =3D D_0 + D_1 + D_2 + .. + D_(n.1)
> Q =3D D_0 + g.D_1 + g=C2=B2.D_2 + .. + g^(n-1).D_(n.1)
> R =3D D_0 + h.D_1 + h=C2=B2.D_2 + .. + h^(n-1).D_(n.1)
>
> The raid6 implementation in mdraid uses g =3D 0x02 to generate the se=
cond
> parity (based on "The mathematics of RAID-6" - I haven't checked the
> source code). You can make a third parity using h =3D 0x04 and then g=
et a
> redundancy of 3 disks. (Note - I haven't yet confirmed that this is
> valid for more than 100 data disks - I need to make my checker progra=
m
> more efficient first.)
>
> Rebuilding a disk, or running in degraded mode, is just an obvious
> extension to the current raid6 algorithms. If you are missing three d=
ata
> blocks, the maths looks hard to start with - but if you express the
> equations as a set of linear equations and use standard matrix invers=
ion
> techniques, it should not be hard to implement. You only need to do t=
his
> inversion once when you find that one or more disks have failed - the=
n
> you pre-compute the multiplication tables in the same way as is done =
for
> raid6 today.
>
> In normal use, calculating the R parity is no more demanding than
> calculating the Q parity. And most rebuilds or degraded situations wi=
ll
> only involve a single disk, and the data can thus be re-constructed
> using the P parity just like raid5 or two-parity raid6.
>
>
> I'm sure there are situations where triple-parity raid6 would be
> appealing - it has already been implemented in ZFS, and it is only a
> matter of time before two-parity raid6 has a real probability of hitt=
ing
> an unrecoverable read error during a rebuild.
>
>
> And of course, there is no particular reason to stop at three parity
> blocks - the maths can easily be generalised. 1, 2, 4 and 8 can be us=
ed
> as generators for quad-parity (checked up to 60 disks), and adding 16
> gives you quintuple parity (checked up to 30 disks) - but that's mayb=
e
> getting a bit paranoid.
>
>
> ref.:
>
> <http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf>
> <http://blogs.oracle.com/ahl/entry/acm_triple_parity_raid>
> <http://queue.acm.org/detail.cfm?id=3D1670144>
> <http://blogs.oracle.com/ahl/entry/triple_parity_raid_z>
>
>
> mvh.,
>
> David
>

Just to follow up on my numbers here - I've now checked the validity of=
=20
triple-parity using generators 1, 2 and 4 for up to 254 data disks=20
(i.e., 257 disks altogether).  I've checked the validity of quad-parity=
=20
up to 120 disks - checking the full 253 disks will probably take the=20
machine most of the night.  I'm sure there is some mathematical way to=20
prove this, and it could certainly be checked more efficiently than wit=
h=20
a Python program - but my computer has more spare time than me!


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
