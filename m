From: Jim Paris <jim@jtan.com>
Subject: Data corruption after resizing partition, when using bitmaps
Date: Tue, 19 May 2015 10:12:40 -0400
Message-ID: <20150519141239.GA5309@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I had a raid1 mirror consisting of big partitions on two disks.
The first disk was 2TB, partitioned like this:

  [--sda1(128M)--][-------sda2(~2T)--------------]

The second disk was 3TB, partitioned like this:

  [--sdb1(128M)--][-------sdb2(~3T)------------------------------------]

sda2 and sdb2 were part of the array, which was only ~2TB in size due
to the smaller disk.

I realized that I needed to add a BIOS boot partition to the 3TB disk,
so I removed sdb2 from the array, and repartitioned sdb like this:

  [--sdb1(128M)--][--sdb2(1M)--][-------sdb3(~3T)----------------------]

Then I added sdb3 to the array.  And lost all my data. :(

What happened was that the last sector of the big partition did not
change location.  So the metadata (0.90) at the end was still present.
Adding sdb3 to the array was considered a "re-add" because the UUID
and array sizes still matched the array, even though the partition
itself shrank.  And the resync was thus guided by an out-of-date
bitmap, which caused very little data to actually be written to sdb3,
so half the reads from the array started returning junk.  Once the
filesystem got involved, the result was rapid corruption.

If I had not been using write-intent bitmaps, everything would have
worked fine.  I only recently started using bitmaps, and never had any
problems with adjusting partitions like this before that.

Perhaps mdadm can be more careful here -- for example, maybe checking
the actual device size and not just the "used dev size" when
determining whether to trust the bitmap.

I wrote a script (attached) to recreate what happened, using some loop
devices.  It works fine if BITMAP=none, and fails with BITMAP=internal.

Jim

--gKMricLos+KVdGMg
Content-Type: application/x-sh
Content-Disposition: attachment; filename="repro.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Aset -e=0A=0ALOOP1=3D/dev/loop1=0ALOOP2=3D/dev/loop2=0AMD=
=3D/dev/md1=0A=0A# BITMAP=3Dnone works fine, BITMAP=3Dinternal corrupts the=
 data.=0ABITMAP=3Dinternal=0A=0A# Misc helpers=0Alog() {=0A    echo =3D=3D=
=3D $@=0A}=0A=0Aerror() {=0A    echo =3D=3D=3D ERROR =3D=3D=3D $@=0A    fal=
se=0A}=0A=0Amb_to_sector() {=0A    echo $(($1 * 2048))=0A}=0A=0Amb_to_byte(=
) {=0A    echo $(($1 * 1048576))=0A}=0A=0Acheck_md5sum() {=0A    sum=3D$(dd=
 if=3D$MD iflag=3Ddirect | md5sum | cut -d ' ' -f 1)=0A    [ $sum =3D=3D $1=
 ] || error "Data corrupted: got $sum, wanted $1"=0A    log "OK $sum"=0A}=
=0A=0ACLEANUP=3D()=0Acleanup() {=0A    set +e=0A    for (( idx=3D${#CLEANUP=
[@]}-1 ; idx>=3D0 ; idx-- )) ; do=0A        log "cleanup: ${CLEANUP[idx]}"=
=0A        eval "${CLEANUP[idx]}"=0A    done=0A}=0Atrap "cleanup" 0 1 2 15=
=0A=0Alog "Create 20 MiB disk1, partitioned as:"=0Alog "disk1p1: 1 MiB"=0Al=
og "disk1p2: 18 MiB"=0Add if=3D/dev/zero of=3Ddisk1 bs=3D1M count=3D20=0Asf=
disk --quiet --force disk1 <<EOF=0Aunit: sectors=0Adisk1p1: start=3D$(mb_to=
_sector 1), size=3D$(mb_to_sector 1), Id=3Dfd=0Adisk1p2: start=3D$(mb_to_se=
ctor 2), size=3D$(mb_to_sector 18), Id=3Dfd=0AEOF=0A=0Alog "Create 30 MiB d=
isk2, partitioned as:"=0Alog "disk2p1: 1 MiB"=0Alog "disk2p2: 28 MiB"=0Add =
if=3D/dev/zero of=3Ddisk2 bs=3D1M count=3D30=0Asfdisk --quiet --force disk2=
 <<EOF=0Aunit: sectors=0Adisk2p1: start=3D$(mb_to_sector 1), size=3D$(mb_to=
_sector 1), Id=3Dfd=0Adisk2p2: start=3D$(mb_to_sector 2), size=3D$(mb_to_se=
ctor 28), Id=3Dfd=0AEOF=0A=0Alog "Create loop devices for the big partition=
s"=0Alosetup -o $(mb_to_byte 2) --sizelimit $(mb_to_byte 18) $LOOP1 disk1=
=0ACLEANUP+=3D("losetup -d $LOOP1")=0Alosetup -o $(mb_to_byte 2) --sizelimi=
t $(mb_to_byte 28) $LOOP2 disk2=0ACLEANUP+=3D("losetup -d $LOOP2")=0A=0Alog=
 "Create MD device with just disk1"=0Amdadm -C $MD -e 0.90 -n 2 -l 1 --bitm=
ap=3D$BITMAP --bitmap-chunk=3D1M $LOOP1 missing=0ACLEANUP+=3D("mdadm --stop=
 $MD")=0Acat /proc/mdstat=0A=0Alog "Add disk2 and wait for sync"=0Amdadm --=
add $MD $LOOP2=0Amdadm --wait $MD=0Acat /proc/mdstat=0A=0AMDSIZE=3D$(blockd=
ev --getsize64 $MD)=0A=0Alog "Write some data"=0Ayes 'aaaaa' | tr -d '\n' |=
 head --bytes=3D$((MDSIZE)) > $MD=0Async=0A=0Alog "Check md5sum"=0Acheck_md=
5sum 3e6cfeb0f93be97da0886768395264d2=0A=0Alog "Remove disk2"=0Amdadm --fai=
l $MD $LOOP2=0Amdadm --remove $MD $LOOP2=0A=0Alog "Now change the first hal=
f of the data"=0Ayes 'bbbbb' | tr -d '\n' | head --bytes=3D$((MDSIZE / 2)) =
> $MD=0Async=0A=0Alog "Repartition disk2 as:"=0Alog "disk2p1: 1 MiB"=0Alog =
"disk2p2: 1 MiB"=0Alog "disk2p3: 27 MiB"=0Alosetup -d $LOOP2=0Asfdisk --qui=
et --force disk2 <<EOF=0Aunit: sectors=0Adisk2p1: start=3D$(mb_to_sector 1)=
, size=3D$(mb_to_sector 1), Id=3Dfd=0Adisk2p2: start=3D$(mb_to_sector 2), s=
ize=3D$(mb_to_sector 1), Id=3Dfd=0Adisk2p3: start=3D$(mb_to_sector 3), size=
=3D$(mb_to_sector 27), Id=3Dfd=0AEOF=0Alosetup -o $(mb_to_byte 3) --sizelim=
it $(mb_to_byte 27) $LOOP2 disk2=0A=0Alog "Check md5sum with only disk1 in =
the array"=0Acheck_md5sum 0dd300d45a0290dbf5e4cc91f2024da5=0A=0Ahd $MD || t=
rue=0A=0Alog "Re-add disk2 to the array and wait for it to sync up"=0Amdadm=
 --add $MD $LOOP2=0Acat /proc/mdstat=0Amdadm --wait $MD=0Acat /proc/mdstat=
=0A=0Alog "Remove disk1"=0Amdadm --fail $MD $LOOP1=0Amdadm --remove $MD $LO=
OP1=0A=0Ahd $MD || true=0A=0Alog "Check md5sum with only disk2 in the array=
"=0Acheck_md5sum 0dd300d45a0290dbf5e4cc91f2024da5=0A=0Aecho "OK!"=0A
--gKMricLos+KVdGMg--
