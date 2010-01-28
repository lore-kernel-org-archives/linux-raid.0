From: "Joseph L. Casale" <jcasale@activenetwerx.com>
Subject: Raid 1 usage in a lab
Date: Thu, 28 Jan 2010 04:09:11 +0000
Message-ID: <CA5A491E9DEFBE4CB777DE97E21575E90BFAF8@prato.activenetwerx.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a box with a two discs mirrored. Suppose I want to remove the primary
and boot off the secondary alone to test, then roll back to the primary after
the test.

I have been doing this by:

1. Removing sda, booting off the sdb and running:
     # mdadm --grow /dev/md[0|1] --raid-devices=1 --force
     Then test away, shutdown...

2. Remove sdb, install sda only and run:
     # mdadm --grow /dev/md[0|1] --raid-devices=1 --force
     shutdown...

3. Install sdb and reboot, the run:
    # mdadm --manage /dev/md0 --add /dev/sdb1
    # mdadm --grow /dev/md0 --raid-devices=2
 
    # mdadm --manage /dev/md1 --add /dev/sdb2
    # mdadm --grow /dev/md1 --raid-devices=2


Is there a simpler way with less reboots? What criteria does md use to
determine which disc is most recent, even a solo reboot with sda, after
which attaching sdb causes the system to prefer sdb, even though the solo
boot off sda should have made timestamps prove sda most current.

Thanks!
jlc
