From: Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>
Subject: force raid reassembly
Date: Tue, 8 Aug 2017 22:27:29 +0000
Message-ID: <WM!bafd27028d31e7e922c12b615def50baa8369ba598ac220b2884f1706eddac34cd0580e2d54cc3da9be1bbadf104dab1!@mailhub-mx1.ncl.ac.uk>
References: <DB4PR07MB409B56E9B9173E33079902ED58A0@DB4PR07MB409.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

I'd be grateful of another pair of eyes just to check and verify what I'm thinking. I've had an array fail and I've checked the components with the mdadm --examine command. Five out of the six event counts are correct and I'm hoping I can get it to assemble with the force option: -

"mdadm --assemble --force /dev/mdX <list of devices>"

mdadm --assemble --force /dev/md0 /dev/sdd1 /dev/sdg1 /dev/sdf1 /dev/sde1 /dev/sdb1 /dev/sdc1

Output from --examine is as follows: -


[root@inscribe4 dev]# mdadm --examine /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
           Name : intermediate0
  Creation Time : Tue Oct 15 21:03:50 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1154 sectors
          State : clean
    Device UUID : 8d0b6c8e:0c526265:6ec0a71b:52a636ba

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 14:16:53 2017
       Checksum : 44b7b461 - correct
         Events : 119894

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe4 dev]# mdadm --examine /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
           Name : intermediate0
  Creation Time : Tue Oct 15 21:03:50 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1154 sectors
          State : clean
    Device UUID : e238e74b:d40efc43:d34d876d:ca0700b0

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 14:16:53 2017
       Checksum : 28758d54 - correct
         Events : 119894

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe4 dev]# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
           Name : intermediate0
  Creation Time : Tue Oct 15 21:03:50 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1154 sectors
          State : clean
    Device UUID : 1732f121:f6f0df09:fafd2411:7c78ce00

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 14:16:53 2017
       Checksum : b8cf8981 - correct
         Events : 119894

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe4 dev]# mdadm --examine /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
           Name : intermediate0
  Creation Time : Tue Oct 15 21:03:50 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1154 sectors
          State : clean
    Device UUID : 3d414ad2:4310c1f9:98f50214:3e9b1e33

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 14:16:53 2017
       Checksum : 8e37d25d - correct
         Events : 119894

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe4 dev]# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
           Name : intermediate0
  Creation Time : Tue Oct 15 21:03:50 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1154 sectors
          State : clean
    Device UUID : a84263cd:75ce20b9:a3a72a1c:b18b2457

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jul 31 22:50:37 2017
       Checksum : 74d320d6 - correct
         Events : 119879

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)

[root@inscribe4 dev]# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ace00fb5:8771d55a:cf36728b:ddc3ce89
           Name : intermediate0
  Creation Time : Tue Oct 15 21:03:50 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 9766901760 (9314.44 GiB 10001.31 GB)
  Used Dev Size : 3906760704 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1154 sectors
          State : clean
    Device UUID : be5ec20e:249645e5:22aeca25:a60c7599

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Aug  8 14:16:53 2017
       Checksum : 2e529fae - correct
         Events : 119894

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAA.A. ('A' == active, '.' == missing, 'R' == replacing)

Thanks

Bryan
