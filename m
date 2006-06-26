From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Subject: Re: recover data from linear raid
Date: Mon, 26 Jun 2006 18:40:14 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0606261835040.18573@tassadar.physics.auth.gr>
References: <Pine.LNX.4.64.0606242233000.32322@tassadar.physics.auth.gr>
	<17566.13544.15613.709664@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606261640330.16450@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261818510.18573@tassadar.physics.auth.gr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0606261818510.18573@tassadar.physics.auth.gr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, ext3-users@redhat.com
List-Id: linux-raid.ids


 	This is what I get now, after creating with fdisk /dev/hdb1 and 
/dev/hdc1 as linux raid autodetect partitions

mdadm -E /dev/hdb1
/dev/hdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : a7e90d4b:f347bd0e:07ebf941:e718f695
   Creation Time : Wed Mar 16 18:14:25 2005
      Raid Level : raid0
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Wed Jun 21 21:57:37 2006
           State : clean, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : c8c21ed8 - correct
          Events : 0.82

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       3       65        0      active sync   /dev/hdb1
    0     0       3       65        0      active sync   /dev/hdb1
    1     1      22        1        1      active sync   /dev/hdc1
[root@node004 root]# mdadm -E /dev/hdc1
/dev/hdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : a7e90d4b:f347bd0e:07ebf941:e718f695
   Creation Time : Wed Mar 16 18:14:25 2005
      Raid Level : raid0
     Device Size : 244195904 (232.88 GiB 250.06 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Wed Jun 21 21:57:37 2006
           State : clean, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : c8c21ead - correct
          Events : 0.82

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1
    0     0       3       65        0      active sync   /dev/hdb1
    1     1      22        1        1      active sync   /dev/hdc1


--
============================================================================

Dimitris Zilaskos

Department of Physics @ Aristotle University of Thessaloniki , Greece
PGP key : http://tassadar.physics.auth.gr/~dzila/pgp_public_key.asc
 	  http://egnatia.ee.auth.gr/~dzila/pgp_public_key.asc
MD5sum  : de2bd8f73d545f0e4caf3096894ad83f  pgp_public_key.asc
============================================================================
