From: Pedro Teixeira <finas@aeiou.pt>
Subject: strange problem with raid6 read errors on active non-degraded array
Date: Wed, 02 Jul 2014 10:32:41 +0100
Message-ID: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

- I'm having the following problem on a raid6 md volume consisting og =20
16 1TB Seagtes SSHD's. ( using kernel 3.15.3 or 3.14.0 ) mdadm is 3.3.

  - every time I run a fsck.ext4 I will get the exact same errors ( =20
=2E..short read ). Forcing a repair on the md0 volume shows no errors =20
and completes without problems. All disks are active and the volume is =
=20
not degraded, still I can't get rid of the short errors on those 16 =20
blocks and when the filesystem is mounted the read errors will come up =
=20
from time to time as they are probably in use.

- If I try to read those blocks with DD  ( dd if=3D/dev/md0  of=3Dtest.=
txt =20
seek=3D458227712 count=3D6 bs=3D4096 ) it will instantly create a 1.8T =
file =20
but the file doesn't appear to have nothing on it ( and the file =20
doesn't take the 1.8T on disk as the disk is much smaller )

- this started happening after having a three disk failure. I =20
recovered from that failure by recreating the array with the =20
non-failed 13 disks plus the last failed one ( events didn't differ =20
much ). I then readed the other disks. The failed disks are all =20
physically good, tested them with hdat2 and they don't have read/write =
=20
errors so I reused them. I don't know why they failed, maybe some =20
incompatibility with SSHD's and the LSI HBA controller..

root@nas3:/# dd if=3D/dev/md0  of=3Dteste.txt seek=3D458227712 count=3D=
6 bs=3D4096
6+0 records in
6+0 records out
24576 bytes (25 kB) copied, 0.0019239 s, 12.8 MB/s
root@nas3:/# ls -lah teste.txt
-rw-r--r-- 1 root root 1.8T Jul  2 10:22 teste.txt
root@nas3:/#



root@nas3:/# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sde[0] sdq[15] sdp[14] sdo[17] sdn[19] sdm[16] =20
sdl[18] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sdb[3] sdd[2] sdc[1]
       13672838144 blocks super 1.2 level 6, 512k chunk, algorithm 2 =20
[16/16] [UUUUUUUUUUUUUUUU]

- When doing a fsck.ext4 of /dev/md0 it returns the following ( and I =20
can do it over and over again with the exact same errors) :

root@nas3:/# fsck.ext4 -f /dev/md0
e2fsck 1.42.10 (18-May-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Error reading block 458227712 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227713 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227714 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227715 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227716 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227717 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227718 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227719 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227720 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227721 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227722 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227723 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227724 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227725 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227726 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Error reading block 458227727 (Attempt to read block from filesystem =20
resulted in short read) while reading inode and block bitmaps.  Ignore =
=20
error<y>? yes
=46orce rewrite<y>? yes
Block bitmap differences:  +(458227712--458231839) =20
+(458234642--458235681) +(458244447--458245519) =20
+(458246454--458247229) +(458248461--458248750) +458250468 +458251108 =20
+(458261280--458261284) +(458263296--458263297) +458263312 +458263328 =20
+(458265376--458265379) +(458267392--458267394) =20
+(458269440--458269441) +458269456 +(458269472--458269474) =20
+(458271520--458271543) +(458273536--458273547) =20
+(458275584--458275585) +458275600 +458275616 +(458277664--458277669) =20
+(458279680--458279682) +(458281728--458281729) =20
+(458283776--458284059) +458285824 +458285837 +458285840 =20
+(458285856--458285857) +(458287904--458287907) =20
+(458289920--458289922) +458291968 +458291984 +458292000 =20
+(458294048--458294054) +(458296064--458296065) +458296080 =20
+(458296096--458296116) +(458298144--458298169) =20
+(458300160--458300504) +(458302208--458302209) +458302224 +458302240 =20
+(458304288--458304298) +(458306304--458307950) =20
+(458310400--458310401) +458310416 +458310432 +(458312480--458312483) =20
+458314496 +458316544 +458316550 +458317824 +(458321152--458321950) =20
+458321952 +458321954 +458321956 +458321958 +458321965 +458321981 =20
+(458323981--458323986) +(458327296--458327297) =20
+(458328094--458328097) +(458331392--458331393) =20
+(458333440--458333441) +(458335488--458335489) =20
+(458337536--458337537) +458339584 +458339593 +458339595 +458339600 =20
+458339616 +458341616 +(458343680--458343681) +(458345728--458345729) =20
+458347776 +458347792 +458347808 +458349808 +(458351872--458351874) =20
+458351888 +458351904 +458353904 +(458355968--458355969) =20
+(458356765--458356815) +(458359809--458360062) +458360064 +458360080 =20
+458360096 +(458360113--458360120) +458362096 +(458364160--458364161) =20
+458364176 +458364192 +458366192 +(458368256--458368257) +458370304 =20
+458370307 +(458373115--458373116) +458373119 +(458373127--458373160) =20
+(458375168--458379263) +(458379271--458379304) =20
+(458381319--458381352) +(458383360--458432511) =20
+(458433367--458433686) +(458434560--458514535) =20
+(458516480--458516488) +(458516496--458561535) =20
+(458561680--458565631) +(458565648--458574328) =20
+(458574416--458575982) +(458576912--458577167) =20
+(458577680--458579535) +(458579968--458582015) =20
+(458594304--458594585) +(458594632--458595592) =20
+(458595627--458595725) +(458595728--458596527) =20
+(458596545--458596687) +(458597423--458598607) =20
+(458598990--458602495) +(458602922--458603023) =20
+(458604256--458604623) +(458605072--458605135) =20
+(458605520--458605717) +(458605908--458608536) =20
+(458608642--458609662) +(458609680--458610704) =20
+(458610776--458613449) +(458613519--458615179) =20
+(458616265--458616831) +(458617702--458618383) =20
+(458618512--458619007) +(458619088--458619151) =20
+(458619896--458621625) +(458621648--458622175) =20
+(458622224--458622489) +(458622508--458622830) =20
+(458622848--458623129) +(458623162--458623345) =20
+(458623394--458623953) +(458623962--458624460) =20
+(458624896--458624975) +(458624986--458626127) =20
+(458626282--458627727) +(458627920--458629119) =20
+(458629195--458632207) +(458632695--458632841) =20
+(458633168--458633231) +(458633668--458633923) =20
+(458634370--458634621) +(458634646--458634660) =20
+(458634704--458635306) +(458635344--458636303) =20
+(458636734--458637311) +(458638356--458639359) =20
+(458639440--458640109) +(458640195--458645071) =20
+(458645178--458645503) +(458645776--458645922) =20
+(458646009--458646479) +(458646546--458647589) =20
+(458647696--458648655) +(458649040--458649807) =20
+(458650640--458651663) +(458652432--458653695) =20
+(458657064--458657199) +(458657792--458658625) =20
+(458658628--458658631) +(458658640--458659231) =20
+(458659513--458659748) +(458659792--458659882) =20
+(458660432--458661337) +(458661899--458663417) =20
+(458663760--458664083) +(458665232--458665295) =20
+(458665552--458665706) +(458665808--458668031) =20
+(458668240--458668855) +(458669126--458669127) =20
+(458669419--458670079) +(458674183--458674216) +458675464 =20
+(458676231--458676267) +(458676360--458676370) =20
+(458676488--458676498) +458676616 +(458676744--458676754) =20
+(458676872--458676873) +458677000 +458677128 +(458677256--458677257) =20
+458677384 +458677512 +(458677640--458678410) +458678536 +458678664 =20
+458678666 +(458678792--458678794) +458678920 +(458679048--458679049) =20
+458679306 +(458679688--458679770) +(458680327--458680360) =20
+(458681736--458681781) +(458682375--458682408) =20
+(458683784--458685154) +(458685192--458685193) =20
+(458685832--458685882) +(458686471--458686507) =20
+(458686600--458686604) +(458687112--458687115) +458687240 +458687368 =20
+(458687880--458688062) +(458688264--458688265) =20
+(458688519--458688552) +(458689928--458690083) =20
+(458690567--458690602) +458690978 +(458691976--458693464) =20
+(458693510--458693514) +458693638 +(458693766--458693769) +458693894 =20
+(458694024--458694652) +(458694663--458694696) =20
+(458696072--458705014) +458705160 +458705288 +(458705416--458705473) =20
+(458706312--458706320) +(458706951--458706984) =20
+(458708999--458709032) +(458711047--458711080) =20
+(458713095--458713128) +(458715143--458715176) =20
+(458717191--458717224) +(458719239--458719272) +458720616 =20
+(458721287--458721320) +(458721416--458721421) +458721544 +458722056 =20
+(458722184--458722187) +(458722696--458723254) =20
+(458723335--458723368) +458723976 +(458724360--458724361) =20
+(458725383--458725416) +(458725896--458725965) =20
+(458727431--458727464) +(458727942--458728837) =20
+(458729479--458729512) +(458731527--458731560) =20
+(458733575--458733703) +(458734984--458739136) =20
+(458739719--458739752) +(458741767--458741800) =20
+(458743815--458743848) +(458745863--458745896) =20
+(458747911--458747944) +(458749959--458749992) +(458751368--458751999)
=46ix<y>? yes

/dev/md0: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md0: 9057/427278336 files (7.2% non-contiguous), =20
1157126209/3418209536 blocks


dmesg ( while doing the fsck.txt4 ) shows:


[84019.232630] Buffer I/O error on device md0, logical block 458227712
[84019.232715] Buffer I/O error on device md0, logical block 458227712
[84024.149583] Buffer I/O error on device md0, logical block 458227713
[84024.149679] Buffer I/O error on device md0, logical block 458227713
[84025.073526] Buffer I/O error on device md0, logical block 458227714
[84025.073617] Buffer I/O error on device md0, logical block 458227715
[84025.073688] Buffer I/O error on device md0, logical block 458227716
[84025.073765] Buffer I/O error on device md0, logical block 458227714
[84026.571139] Buffer I/O error on device md0, logical block 458227715
[84027.654387] Buffer I/O error on device md0, logical block 458227717
[84027.654474] Buffer I/O error on device md0, logical block 458227718
[84027.654549] Buffer I/O error on device md0, logical block 458227719
[84027.654617] Buffer I/O error on device md0, logical block 458227720
[84027.654684] Buffer I/O error on device md0, logical block 458227721
[84030.577188] quiet_error: 8 callbacks suppressed
[84030.577190] Buffer I/O error on device md0, logical block 458227720
[84031.233856] Buffer I/O error on device md0, logical block 458227721
[84031.907058] Buffer I/O error on device md0, logical block 458227722
[84032.534278] Buffer I/O error on device md0, logical block 458227723
[84033.186672] Buffer I/O error on device md0, logical block 458227724
[84033.847581] Buffer I/O error on device md0, logical block 458227725
[84034.453947] Buffer I/O error on device md0, logical block 458227726
[84035.073116] Buffer I/O error on device md0, logical block 458227727
[84068.605347] Buffer I/O error on device md0, logical block 458227712
[84068.605427] lost page write due to I/O error on md0
[84068.605439] Buffer I/O error on device md0, logical block 458227713
[84068.605519] lost page write due to I/O error on md0
[84068.605528] Buffer I/O error on device md0, logical block 458227714
[84068.605747] lost page write due to I/O error on md0
[84068.605757] Buffer I/O error on device md0, logical block 458227715
[84068.605828] lost page write due to I/O error on md0
[84068.605837] Buffer I/O error on device md0, logical block 458227716
[84068.605910] lost page write due to I/O error on md0
[84068.605919] Buffer I/O error on device md0, logical block 458227717
[84068.605995] lost page write due to I/O error on md0
[84068.606048] Buffer I/O error on device md0, logical block 458227718
[84068.606217] lost page write due to I/O error on md0
[84068.606227] Buffer I/O error on device md0, logical block 458227719
[84068.606295] lost page write due to I/O error on md0
[84068.606327] Buffer I/O error on device md0, logical block 458227720
[84068.606398] lost page write due to I/O error on md0
[84068.606407] Buffer I/O error on device md0, logical block 458227721
[84068.606471] lost page write due to I/O error on md0


Doing a resync brings no errors and finishes without problem:

[24406.670968] md: requested-resync of RAID array md0
[24406.670971] md: minimum _guaranteed_  speed: 1410065407 KB/sec/disk.
[24406.670973] md: using maximum available idle IO bandwidth (but not =20
more than 1410065407 KB/sec) for requested-resync.
[24406.670981] md: using 128k window, over a total of 976631296k.
[33488.135225] md: md0: requested-resync done.


- doing:
root@nas3:/# debugfs /dev/md0
debugfs 1.42.10 (18-May-2014)
/dev/md0: Can't read a block bitmap while reading block bitmap
debugfs:

- brings the same kind of errors to dmesg.


- filesystem mounts and unmounts fine:

root@nas3:/# mount /dev/md0 /mnt
root@nas3:/# df -h
=46ilesystem            Size  Used Avail Use% Mounted on
/dev/sda1             106G  5.3G   95G   6% /
tmpfs                 3.9G     0  3.9G   0% /lib/init/rw
udev                  3.9G  196K  3.9G   1% /dev
tmpfs                 3.9G     0  3.9G   0% /dev/shm
tmpfs                 3.9G     0  3.9G   0% /tmp
/dev/md0               13T  4.3T  8.5T  34% /mnt

[84215.958792] EXT4-fs (md0): mounted filesystem with ordered data =20
mode. Opts: (null)

root@nas3:/# umount /mnt

mdadm --examine /dev/sd[bcdefghijklmnopqr] >> raid.status


/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : b56fa722:c5be1eda:5b3e89cc:7199d266

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : e8a1ec1f - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : e72b076e:42886d45:8978e63b:b70c3c1b

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : c3171f37 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : a195ff09:a794b5fc:7c830670:bcf450f1

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 208c8851 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 6ab2bcfc:872649a6:a053e0fe:94fe1fc3

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 1d8610fd - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdf:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : f4612be4:5e8b4db0:4e23f28d:e37d27b6

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 9112745e - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdg:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : e595d71c:c45d6fda:24a49338:2615328b

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 738c92c6 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdh:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 347fa638:4193adb2:4b8616d4:058fff18

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 90ea0da1 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdi:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 2f6ab7cb:3957ffa0:8b2decd2:b133cb5a

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 52ee087a - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdj:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : cd1cbc05:552bedbd:bf8f7be8:960afcd1

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 36a0c84e - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 8
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdk:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 4e352f48:398c4529:b39cd8c8:d5a14e7e

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 711be5ee - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 9
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdl:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 01e6c661:a4d8c466:84fd830c:dc3ec346

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : d452e0ec - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 10
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdm:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : aa22b86a:fb4effe6:8028a5ae:df01a2c2

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 7b7e81eb - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 11
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdn:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 8e0f1a50:50538cf7:c7553f75:22af1e8a

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : ff844db0 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 12
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdo:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : ea496b92:ac96fabc:23b5026a:30b0b80f

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 81a12bd0 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 13
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdp:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : 01173faa:f45adebc:9a1dc160:306641a2

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 229fdb9c - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 14
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)
/dev/sdq:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 9e97c588:59135324:c7d3fdf6:e543bdc3
            Name : nas3:Datastore  (local to host nas3)
   Creation Time : Tue May 27 12:18:06 2014
      Raid Level : raid6
    Raid Devices : 16

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 13672838144 (13039.43 GiB 14000.99 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D432 sectors
           State : clean
     Device UUID : a7a6c77f:88c5d5d7:c330ab03:6cf98a83

     Update Time : Wed Jul  2 10:03:48 2014
   Bad Block Log : 512 entries available at offset 72 sectors - bad =20
blocks present.
        Checksum : 97537c43 - correct
          Events : 1128363

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 15
    Array State : AAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng, 'R' =20
=3D=3D replacing)












_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
