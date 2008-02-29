From: Franck Routier <franck.routier@axege.com>
Subject: Re: Understanding bonnie++ results
Date: Fri, 29 Feb 2008 09:19:52 +0100
Message-ID: <1204273192.9381.63.camel@franck-gusty>
References: <1204191989.16924.10.camel@franck-gusty>
	 <20080228190609.GA29262@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080228190609.GA29262@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

sorry for being vague on my first post.

Ok, here are the facts:

1) Hardware

-server is a dual AMD dual core opteron system, running Linux 2.6.22 (a=
s
ship by Ubuntu 7.10 server)
-disk controller is an Adaptec 31205 SAS AAC-RAID controller, with 256M=
B
of cache
-disks are 72GB FUJITSU MAX3073RC SAS 3"5 disks at 15krpm with 16MB
buffer size (plus two Maxtor Sata disks for systems controlled by the
mother board)
-system RAM is 8 GB

2) Usage

this will be a Postgresql database server, holding a mix of
Datawarehouse / Operational Data Store application

3) The tests

I am in no way an expert in system administration or benchmarking... so
I simply launched bonnie++ with no parameter other than

$bonnie++ -d /a_dir_on_my_array

letting bonnie decide what best file size and ram size to use. Bonnie's
computed size was 16GB.

=46ile system is XFS with noatime,nodiratime options.

Each test was launched on hardware raid and then on software raid:
- RAID 10 on 6 disks
- RAID 10 on 4 disks
Linux software raid 10 was created using mdadm level with default (near=
)
layout and default chunk size, then with far 2 option and 256k chunk
size.
=46or 4 disks arrays, I also tried to launch 2 bonnie++ tests in parall=
el,
on two different arrays, to see the impact.

Here are the results, in bonnie++ csv format:

6 disks:
-hw raid
goules-hw-raid10-6,16G,72343,98,235192,37,107093,19,64163,89,286958,26,=
1323.1,2,16,23028,95,+++++,+++,20643,70,19770,95,+++++,+++,17396,81
-md raid (chunk 64k)
goules-md-raid10-6,16G,72413,99,196164,42,42249,8,51613,72,52311,5,1486=
=2E7,3,16,13437,61,+++++,+++,9736,42,12128,59,+++++,+++,8526,44

4 disks:
-hw raid:
goules-hw-raid10-4,16G,72462,99,162303,25,87544,16,64049,89,211526,19,1=
179.7,2,16,20894,96,+++++,+++,19563,64,20160,98,+++++,+++,18794,78
-md raid
goules-md-raid10-4,16G,70206,99,162525,35,30169,5,33898,47,34888,3,1347=
=2E3,2,16,17837,81,+++++,+++,14735,61,15211,66,+++++,+++,7810,31
-md raid with f2 option and 256 chunk size
goules-md-raid10-4-f2-256-xfs,16G,69928,97,93985,20,56930,11,68669,98,3=
56923,37,1327.1,2,16,20001,87,+++++,+++,20392,73,19773,88,+++++,+++,522=
8,23

4 disks with 2 bonnie++ running simultaneously:
-hw raid:
goules-hw-raid10-4-P1,16G,70682,96,145883,28,54263,10,60888,86,205427,2=
0,837.4,1,16,20742,97,+++++,+++,20969,76,19801,100,+++++,+++,18789,79
goules-hw-raid10-4-P2,16G,72405,99,138678,26,56571,11,60876,84,205619,2=
1,679.8,2,16,20067,93,+++++,+++,14698,53,17090,87,+++++,+++,9041,42
-md raid with near option and 64k chunk:
goules-md-raid10-4-P1,16G,72183,98,100149,24,28057,5,33398,44,34624,3,7=
71.8,1,16,16057,71,+++++,+++,9576,32,15871,77,+++++,+++,7357,33
goules-md-raid10-4-P2,16G,72467,99,99952,24,28424,5,33361,44,34681,3,88=
3.2,2,16,13032,67,+++++,+++,10759,46,13157,56,+++++,+++,7424,36

4) The interpretation

Here is the difficult part! I also realize that my tests are not so
consistent (chunk size varies for md raid). But here is what I see:
-sequential output is quite similar for each setup, with hw raid being =
a
bit better
-sequential input varies greatly, the big winner being md-f2-256 setup
with 356923K/sec, and the big loser md-near-64 setup with 34888K/sec
(factor of 10 !)
- what seems the most relevant to me, random seeks are always better on
software raid, by 10 to 20%, but I have no idea why.
- and running two bonnie++ in parallel on two 4 disks arrays gives
better iops than 6 disks arrays.

So I tend to think I'd better use md-f2-256 with 3 arrays of 4 disks an=
d
use tablespaces to make sure my requests are spread out on the 3 arrays=
=2E
But this conclusion may suffer from many many flaws, the first one bein=
g
my understanding of raid, fs and io :)

So, any comment ?

Thanks,
=46ranck


Le jeudi 28 f=C3=A9vrier 2008 =C3=A0 20:06 +0100, Keld J=C3=B8rn Simons=
en a =C3=A9crit :
> On Thu, Feb 28, 2008 at 10:46:29AM +0100, Franck Routier wrote:
> > Hi,
> >=20
> > I am experimenting with Adaptec 31205 hardware raid versus md raid =
on
> > raid level 10 with 3 arrays of 4 disks each.
> > md array was created with f2 option.
>=20
> what are the characteristics of your disks? Are they all the same siz=
e
> and same speed etc?
>=20
> What kind of raid are you creating with the Adaptec HW? I assume you
> make a RAID1 with this.
>=20
> What is the chunk size?
>=20
> Are your figures for one of the arrays, that is for an array of 4
> drives?
>=20
> > I get some results with bonnie++ tests I would like to understand:
> >=20
> > - per char sequential output is consistantly around 70k/sec for bot=
h
> > setup
>=20
> I think the common opinion on this list is to ignore this figure.
> However, if you are using this for postgresql databases, this may be =
relevant.
>=20
> > - but block sequential output shows a huge difference between hw an=
d sw
> > raid: about 160k/sec for hw versus 60k/sec for md. Where can this c=
ome
> > from ??
>=20
> Strange. Maybe see if the md array has been fully synced before testi=
ng.
> For sequential writes on a 4 drive raid10,f2 with disks of 90 MB/s
> I would expect a writing rate of about 160 MB/s - which is the same a=
s=20
> your HW rate. (I assume you mean MB/s instead of k/sec)
>=20
> > On the contrary, md beat hw on inputs:
> > - sequential input show 360k/sec versus 220k/sec for hw
>=20
> raid10,f2 stripes, while normal raid1 does not. Also raid10,f2
> tends to only use the outer and faster sectors of disks.
>=20
> > - random seek 1350/sec for md versus 1150/sec for hw
>=20
> Random seeks in raid10,f2 tends to be restricted to a smaller range o=
f
> sectors, thus making average seek times smaller.
> =20
> > So, these bonnie++ tests show quite huge differences for the same
> > hardware between adaptec's hardware setup and md driver.
>=20
> I like to get such results of comparison between HW and SW raid.
> How advanced are Adaptec controllers considered these  days?=20
> My thoughts are that SW raid is faster than HW raid, because Neil and=
 the
> other people here together can develop more sophisticated algorithms,
> but I would like some hard figures to back up that thought.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
