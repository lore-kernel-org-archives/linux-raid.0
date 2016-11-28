From: "Randall C. Grimshaw" <rgrimsha@esf.edu>
Subject: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 17:26:56 +0000
Message-ID: <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have made the mistake of booting a centos-6.8 live cd to manipulate a centos 5 system.
as a result md5 has become md122, md2 has become md125, md4 has become md126, md0 has become md127, and most unfortunately md3 has also become md122.

smartctl shows that the WD brand drives do support SCT
mdadm --examine was used to reveal the mish-mash using uuid numbers compared with the file /etc/mdadm.conf also referencing /etc/fstab.

can someone kindly tell me the mdadm command to put the correct numbers back.

sda7,sdb7 (122) /dev/md5 uuid=11b7e8b7:ca181503:cf45af46:db2a5d9d /
sda1,sdb1 (127) /dev/md0 uuid=d9a5774d:d930fbd8:cf45af46:db2a5d9d /boot
sda3,sdb2 (125) /dev/md2 uuid=23a4116f:1d43390b:cf45af46:db2a5d9d /tmp
sda5,sdb5 (122) /dev/md3 uuid=c89f6357:f1c7a0ef:cf45af46:db2a5d9d /var
sda6,sdb6 (126) /dev/md4 uuid=67ad84bc:05153ebe:cf45af46:db2a5d9d /var/lib/mysql/cmdaemon_mon
sda2,sdb2 (   1) /dev/md1 uuid=5d9f0b00:24d890eb:cf45af46:db2a5d9d swap
sdc1                                                            /home

much appreciated
Randall Grimshaw