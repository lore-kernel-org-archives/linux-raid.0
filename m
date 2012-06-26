From: Ralph Berrett <ralph.berrett@avid.com>
Subject: A disk failure during the initial resync after create, does not
 always suspend the resync to start the recovery
Date: Tue, 26 Jun 2012 21:14:54 +0000
Message-ID: <0B3484EB4B5B284199C5204D116920FC047E8D@WAL-MBS04.global.avidww.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A disk failure during the initial resync after create, does not always =
suspend the resync to start the recovery
=A0
Steps:
1. Create multiple Raid6 arrays (in my case 8 arrays, this is a large s=
torage system)
2. Create 2 spares (with one spare in md1 and other in md5)
3. Set two different "spare-group" in /etc/mdamd/mdadm.conf so that md1=
-md4 and md5-md8 each share one of the two spare.
4. While resync is still in progress, fail a disk in the arrays that do=
 not have the spare (physically pulled).
5. The spare drive is moved from to the effected array via mdadm --moni=
tor daemon that is running. But the "recovery" does not always started.=
 Most of the time it waits for the "resync" to complete before starting=
 the "recovery", but not always.
=A0
Which is the expected behavior, should it stop the resync to do the rec=
overy or not?  If not, since these are fairly large arrays, the "resync=
" could take a while before it even starts the "recovery" leaving the s=
ystem in degraded state.  From my experiments, the "resync" is not stop=
ped more often than it is stopped.
=A0
The only workaround I have found is to send "echo "ilde" > /sys/block/m=
d2/md/sync_action" which will suspend the resync and then the recovery =
will start.  This is a intended as a embedded system so this is not an =
optimal workaround.
=A0
emDebain 6.0.4
Kernel:    2.6.32
mdadm:   v3.1.4 - 31st August 2010
=A0
=A0
Example:  I failed a disk in md2 and then later on in md6.  In both cas=
es the spares from md1 and md5 (respectively) were moved into the degra=
ded array.  But md2 stopped the "resync" and started the "recovery" alm=
ost immediately but md6 stayed in "resync" until it finished, before st=
arting the "recovery"
=A0
# cat /etc/mdadm/mdadm.conf
DEVICE /dev/sd*[^0-9]
ARRAY /dev/md1 metadata=3D1.2 name=3Dnl-emdebian:1 UUID=3D29156c78:d55c=
d2dd:07c02578:9238ec0a spare-group=3Dgroup0
ARRAY /dev/md2 metadata=3D1.2 name=3Dnl-emdebian:2 UUID=3D4e7531bb:8f29=
7d64:d8c1aab8:6b711384 spare-group=3Dgroup0
ARRAY /dev/md3 metadata=3D1.2 name=3Dnl-emdebian:3 UUID=3Dd14eb677:d9f8=
b9d9:7de9c5de:c6cee4c8 spare-group=3Dgroup0
ARRAY /dev/md4 metadata=3D1.2 name=3Dnl-emdebian:4 UUID=3D4ee94f31:65af=
2645:0f8b557d:58b4a203 spare-group=3Dgroup0
ARRAY /dev/md5 metadata=3D1.2 name=3Dnl-emdebian:5 UUID=3Dfe6a448c:68b6=
0591:a939b315:9dabc1d1 spare-group=3Dgroup1
ARRAY /dev/md6 metadata=3D1.2 name=3Dnl-emdebian:6 UUID=3D832328d7:1107=
804e:1dfc3a48:760a2341 spare-group=3Dgroup1
ARRAY /dev/md7 metadata=3D1.2 name=3Dnl-emdebian:7 UUID=3D231c4ff6:be34=
8e5e:ff144e55:1cfa0c9f spare-group=3Dgroup1
ARRAY /dev/md8 metadata=3D1.2 name=3Dnl-emdebian:8 UUID=3Dd2904af6:cbc6=
d409:8f1601a4:d1f2229e spare-group=3Dgroup1
=A0
=A0
# mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Tue Jun 26 10:57:51 2012
     Raid Level : raid6
     Array Size : 7814090752 (7452.10 GiB 8001.63 GB)
  Used Dev Size : 976761344 (931.51 GiB 1000.20 GB)
   Raid Devices : 10
  Total Devices : 11
    Persistence : Superblock is persistent
=A0
  Intent Bitmap : Internal
=A0
    Update Time : Tue Jun 26 15:54:45 2012
          State : active, degraded, recovering
 Active Devices : 9
Working Devices : 10
 Failed Devices : 1
  Spare Devices : 1
=A0
         Layout : left-symmetric
     Chunk Size : 512K
=A0
 Rebuild Status : 0% complete
=A0
           Name : nl-emdebian:2
           UUID : 4e7531bb:8f297d64:d8c1aab8:6b711384
         Events : 364
=A0
    Number   Major   Minor   RaidDevice State
      10      67      160        0      spare rebuilding   /dev/sdbg
       1      68      112        1      active sync   /dev/sdbt
       2      68      128        2      active sync   /dev/sdbu
       3      67       80        3      active sync   /dev/sdbb
       4      67       48        4      active sync   /dev/sdaz
       5      67       64        5      active sync   /dev/sdba
       6      67       96        6      active sync   /dev/sdbc
       7      67       16        7      active sync   /dev/sdax
       8      67       32        8      active sync   /dev/sday
       9      66      144        9      active sync   /dev/sdap
=A0
       0      68      160        -      faulty spare
=A0
=A0
# mdadm --detail /dev/md6
/dev/md6:
        Version : 1.2
  Creation Time : Tue Jun 26 10:57:58 2012
     Raid Level : raid6
     Array Size : 7814090752 (7452.10 GiB 8001.63 GB)
  Used Dev Size : 976761344 (931.51 GiB 1000.20 GB)
   Raid Devices : 10
  Total Devices : 11
    Persistence : Superblock is persistent
=A0
  Intent Bitmap : Internal
=A0
    Update Time : Tue Jun 26 15:54:04 2012
          State : active, degraded, resyncing
 Active Devices : 9
Working Devices : 10
 Failed Devices : 1
  Spare Devices : 1
=A0
         Layout : left-symmetric
     Chunk Size : 512K
=A0
 Rebuild Status : 2% complete
=A0
           Name : nl-emdebian:6
           UUID : 832328d7:1107804e:1dfc3a48:760a2341
         Events : 336
=A0
    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3      65      144        3      active sync   /dev/sdz
       4      65      112        4      active sync   /dev/sdx
       5      65      128        5      active sync   /dev/sdy
       6      65      160        6      active sync   /dev/sdaa
       7      65       80        7      active sync   /dev/sdv
       8      65       96        8      active sync   /dev/sdw
       9       8      208        9      active sync   /dev/sdn
=A0
       0       8       80        -      faulty spare
      10      65      224        -      spare   /dev/sdae


Ralph Berrett
Senior Software Engineer | P&S Broadcast & Storage

Avid
65 Network Drive
Burlington, MA 01803
United States
ralph.berrett@avid.com=A0

t 9786403674=A0

We're Avid.=A0=A0Learn more at=A0www.avid.com



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
