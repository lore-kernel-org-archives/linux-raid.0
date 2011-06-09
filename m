From: David Brown <david.brown@hesbynett.no>
Subject: Triple-parity raid6
Date: Thu, 09 Jun 2011 02:01:06 +0200
Message-ID: <isp2g2$rf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Has anyone considered triple-parity raid6 ?  As far as I can see, it=20
should not be significantly harder than normal raid6 - either  to=20
implement, or for the processor at run-time.  Once you have the GF(2=E2=
=81=B8)=20
field arithmetic in place for raid6, it's just a matter of making=20
another parity block in the same way but using a different generator:

P =3D D_0 + D_1 + D_2 + .. + D_(n.1)
Q =3D D_0 + g.D_1 + g=C2=B2.D_2 + .. + g^(n-1).D_(n.1)
R =3D D_0 + h.D_1 + h=C2=B2.D_2 + .. + h^(n-1).D_(n.1)

The raid6 implementation in mdraid uses g =3D 0x02 to generate the seco=
nd=20
parity (based on "The mathematics of RAID-6" - I haven't checked the=20
source code).  You can make a third parity using h =3D 0x04 and then ge=
t a=20
redundancy of 3 disks.  (Note - I haven't yet confirmed that this is=20
valid for more than 100 data disks - I need to make my checker program=20
more efficient first.)

Rebuilding a disk, or running in degraded mode, is just an obvious=20
extension to the current raid6 algorithms.  If you are missing three=20
data blocks, the maths looks hard to start with - but if you express th=
e=20
equations as a set of linear equations and use standard matrix inversio=
n=20
techniques, it should not be hard to implement.  You only need to do=20
this inversion once when you find that one or more disks have failed -=20
then you pre-compute the multiplication tables in the same way as is=20
done for raid6 today.

In normal use, calculating the R parity is no more demanding than=20
calculating the Q parity.  And most rebuilds or degraded situations wil=
l=20
only involve a single disk, and the data can thus be re-constructed=20
using the P parity just like raid5 or two-parity raid6.


I'm sure there are situations where triple-parity raid6 would be=20
appealing - it has already been implemented in ZFS, and it is only a=20
matter of time before two-parity raid6 has a real probability of hittin=
g=20
an unrecoverable read error during a rebuild.


And of course, there is no particular reason to stop at three parity=20
blocks - the maths can easily be generalised.  1, 2, 4 and 8 can be use=
d=20
as generators for quad-parity (checked up to 60 disks), and adding 16=20
gives you quintuple parity (checked up to 30 disks) - but that's maybe=20
getting a bit paranoid.


ref.:

<http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf>
<http://blogs.oracle.com/ahl/entry/acm_triple_parity_raid>
<http://queue.acm.org/detail.cfm?id=3D1670144>
<http://blogs.oracle.com/ahl/entry/triple_parity_raid_z>


mvh.,

David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
