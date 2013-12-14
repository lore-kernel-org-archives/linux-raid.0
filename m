From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Help with degraded array
Date: Sat, 14 Dec 2013 12:25:36 -0600
Message-ID: <52ACA2A0.4060405@suddenlinkmail.com>
References: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>	<52AC351E.5050709@suddenlinkmail.com> <CAB1R3siFu3q98bT23Lz1u2uVqkxvth35pguzSdBQ7auZkJwumg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3siFu3q98bT23Lz1u2uVqkxvth35pguzSdBQ7auZkJwumg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/14/2013 11:40 AM, Alex wrote:
> # cat /etc/mdadm.conf
> 
> # mdadm.conf written out by anaconda
> MAILADDR root
> AUTO +imsm +1.x -all
> ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=99acf2a0:afa1266c:b870423d:f06e4009
> 
> So I would then use "mdadm --add /dev/md0 /dev/sdc3" to add it,
> correct? It's not necessary to first fail the device?

From your earlier post:

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed Mar 21 12:31:23 2012
     Raid Level : raid1
     Array Size : 148478904 (141.60 GiB 152.04 GB)
  Used Dev Size : 148478904 (141.60 GiB 152.04 GB)
   Raid Devices : 2
  Total Devices : 1
^^^^^^^^^^^^^^^^^^^^^    Persistence : Superblock is persistent
<snip>
    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
                                      ^^^^^^^^^^^^^^^^^^^^^^
       1       8       18        1      active sync   /dev/sdb2


The drive at /dev/sda3 has already been failed/removed. The reason was:

Buffer I/O error on device sda2, logical block 65536
lost page write due to I/O error on sda2
JBD2: Error -5 detected when updating journal superblock for sda2-8.

  What I would do is run smartctl -t short /dev/sdc, then smartctl -a /dev/sdc
and make sure the drive was reported as PASSED and not in imminent failure. Then
run fsck on /dev/sdc2 (the partition reporting the I/O error on what was sda2 --
DO NOT fsck /dev/sdc3.

  Then I would reboot to see if the drive designation didn't revert to sda and
give mdadm a chance to reassemble the array automatically. If that did not work,
then I would check the drive designation (sda/sdc) and try the "--add" as you
specified, if that failed use "--add --force".

Good luck.



-- 
David C. Rankin, J.D.,P.E.
