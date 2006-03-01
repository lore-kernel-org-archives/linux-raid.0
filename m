From: "Francois Barre" <francois.barre@gmail.com>
Subject: [RFC] Generic Migration
Date: Wed, 1 Mar 2006 13:59:28 +0100
Message-ID: <fd8d0180603010459j316a8776j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2645_1981638.1141217968637"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

------=_Part_2645_1981638.1141217968637
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

I hope I won't bore you too much, but I had these ideas on my mind for
a couple of days now, so I just wanted to share them to you.
It is not a long document, so I guess it would take 10mins to read.
Sorry for my sometimes obscure english, ya know, I did the best I could...

I do welcome any comments, critics, suggestions, ... especially
because it's really a first draft here.

I of course would wish to implement what i'm speaking about, one day
or another...

Best regards,

F.-E.B.

------=_Part_2645_1981638.1141217968637
Content-Type: text/plain; name=md-generic-migration.txt; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Attachment-Id: f_ek9nltq0
Content-Disposition: attachment; filename="md-generic-migration.txt"

=EF=BB=BFGeneric reshape model for MD

1. Introduction

The aim of this document is to present a concept of generic online md level
migration, such as raid1 to raid5, raid growth, ...
Regardless to implementation issues, the only migrations that are strictly
impossible are those where data (and replications) will not fit in the disk
at the end of the migration. For example, raid5 to raid1 with the same numb=
er
of disks is strictly impossible.
The aim of generic migration is to make each migration possible and easily
implementable (if not straitforward), including the ones that would imply=
=20
a growth, to the extend that enough spare disks are provided.

2. Proposal

2.1. Initial Concept.

Migration always imply a total read/re-write of the whole disks, just as=20
a resync or a growth would do.

Needless to say, raid-levels are always aware of their own layout, and know
how to read or write stuff to disk with regard to their layout.

So in short, the concept is : let's benefit of their awareness.
Let's add a layer on top of the raidX block layer, which would be responsib=
le=20
for reading a certain amount of data using the previous raid level/layout=
=20
(feeding the window), and writing this window using the target raid=20
level/layout. Both reads and writes use the corresponding level implementat=
ion,
just as a regular use would do.
So, don't forget the window is read/written at md level.

2.2. Layout shape and calculations
(Nota : we would not consider here linear md models).

At this point, we should detail three different types of migrations, in ter=
ms
of migration of data at the disk level.

Considering only raid1, 4, 5 and 6, it is clear that we can find an exact=
=20
ratio M between the size of the window (in sectors) and the corresponding=
=20
number of sectors involved on disk.
For raid1, M =3D 1, for raid 4 and 5, M =3D k - 1 (k being the total number=
 of=20
disks in a non-degraded setup), and for raid 6, M =3D k - 2.

In a migration context, we have to know M for the previous setup and M' for=
=20
the target setup.

Let's call W the size of the window. A convenient window size shall be a=20
multiple of M and M', such as each window read involves W/M sectors on
each disk, and each window write involves W/M' sectors on each disk.

First, a little bit of notation issues.
=09s(n,p,q) defines sectors p to p+q on the nth disk before migration.
=09s'(n,p,q) defines sectors p to p+q on the nth disk after migration.=20
=09w(m) defines the mth window of the migration (window at sector m,
=09and of size W).

=09k defines the number of disks before migration.
=09k' defines the number of disks after migration.


=09w(m) =3D s(0,p,W/M) ... s(k,p,W/M) means the mth window is built using
=09the pth sector of disks 0...k. All disks may not be necessary
=09to build the window, but it is asserted that we *can* build
=09the window knowing this.
=09(Nota : don't misunderstand this ugly notation : this is not concatenati=
on..)

=09In the general case, migration consists on=20
=091. Building window
=09w(m) =3D s(0,p,W/M) ... s(k,p, W/M)

=092. Writing back the window
=09s'(0,p',W/M') ... s'(k',p',W/M') =3D w(m)

=09So, m =3D M * p =3D M' * p'.

It is clear here that we should ask level-specific code for their M value,
as we provide them the number of disks we want to use for migrations.

2.3. Different types of migrations.

As a result, we can have three different migrations=20

- stable migration : when the data before and after migration sits at the s=
ame
part of the disk, i.e., M =3D M', and for each m, p' =3D=3D p.
  So data at s(0,p) ... s(k,p) will be copied to s(0,p) ... s(k',p).
  A good example ? Raid-5 to Raid-6 conversion with an additionnal disk.
  k' =3D k + 1, M =3D k - 1, M' =3D k' - 2 =3D k - 1 =3D M.
  A consequence of M =3D M' is that the md device size does not change afte=
r the
  migration.

- downsize migration : that means M' > M, and p' < p.
  An example ? Raid-6 to Raid-5 conversion with the same number of disks.
  We have M =3D k - 2 and M' =3D k - 1, so M' > M.
  Indeed, when we will finish migrating, space will remain at the end of di=
sks
  so md device size will increase and we'll need an extra resync of the
  remaining part.

- upsize migration : that means p' > p. This is only possible when underlyi=
ng
  (partition) size is greater than the one actually used. This can be part =
of
  'standard' growth and is strictly off-topic.


2.4. Implementation in short

Well, I will NOT underestimate the work to accomplish by saying 'easy, just=
=20
change that and code this... Piece of cake !'.
The basic concept is : rely on the current implementation of involved raid
levels to do the job. That is, using request_queue and bio, read the window
and write it back.
That also implies we have two concurrent raid level drivers on top of the
same drives.
During the migration process, the block device at md level will be splitted=
 in
two parts : the one that has migrated (and is written on disk using the tar=
get
layout), and the one that is to be migrated (which is stored on disk using =
the
previous layout). This border evolves during the process, starting at the
beginning of the md, finishing at the end of the previous layout.

(In the case of a downsize migration, a resync of the remaining part must b=
e
performed after the migration of previous content.)

Let's call current_sector the current start sector of the window to be copi=
ed.
current_sector starts at 0, and ends at the previous layout size. It can on=
ly
grow, because we only consider stable and downsize migration.

Let's assume the mddev->queue is empty and clean at the beginning of the
migration.
Let's assume that each level-specific cache is cleared.
Let's assume we are able to strictly forbid the underlying level drivers to
read or write stuff outside of their own border.
That is, the previous driver will not read nor write on sectors after=20
current_sector (and the corresponding sectors on disk), and the target driv=
er
will not read nor write before.
That also imply inhibiting level-specific resync threads, ...

So, an idea of the implementation could be a wrapper around the=20
make_request_fn set for the queue of the mddev, plus a migration thread.

The make_request_fn of the migration will be responsible for choosing the
relevant level driver for the (userland) requests it recieves.
If the request is before current_sector, call the target level driver.
If the request is after current_sector, call the previous one.
If the request is inside the window, delay it.
Of course, overlapping issues will appear here.

The migration thread will be responsible for fetching the window content,
increment current_sector, write window with the new layout. Locking and=20
unlocking as necessary.

2.5. Journaling and failure recovery

Consider these points :
- before migration starts, we recorder in the superblocks all necessary=20
setup information regarding the targetted raid level and layout. This inclu=
des
disk role in the target layout, window size, ...
- during migration, we regularly write the current status (the current_sect=
or)
of the migration in (some ?) superblocks.
This way, we could handle crash recovery of migrations, at least for dowsiz=
e
migrations.
Because stable migrations are a bit more complex to handle, because we writ=
e=20
stuff where we have read it. This means we don't know after a crash if :
A: window was being read
B: window was being written
C: window was completely written.

Status A and C are safe, at least if we can determine that we started writi=
ng=20
the window or not.
Status B is unsafe : we started writing data but did not finish, so sectors
are in a mix of old and new layout.
Several options could turn here :
- use another device/journal (nvram ?) to backup the window before writing
- write all data at a certain offset to forbid a window to be rewritten whe=
re=20
it was read. This shall imply a change in all underlying drivers...

3. Open Issues

As we rely on the level-specific code for reading/writing, we benefit from =
its
own redundancy implementation. So we could migrate a degraded array.




------=_Part_2645_1981638.1141217968637--
