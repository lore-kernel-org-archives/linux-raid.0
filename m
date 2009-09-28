From: Aggelos Kyritsis <filodoksos@gmail.com>
Subject: mdadm 3.0.2 won't read mdadm.conf file
Date: Mon, 28 Sep 2009 10:13:28 +0300
Message-ID: <1e36c70e0909280013o616d74draf419a548183cc7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear sir/madam,

I am running ubuntu 9.04. Until recently I used the mdadm version that
exists in the ubuntu repositories, with perfect success. However,
since that version is fairly old (2.6, I think), I decided to install
the latest version 3.0.2.

On a freshly formatted system with no mdadm I downloaded
http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.0.2.tar.gz,
unzipped it and run the "sudo make" and "sudo make install" commands.
According to mdadm --version, I succesfuly installed version 3.0.2 of
the program. I was also successful on creating and mounting a fresh
raid 5 array.

However, the installation didn't create either the
/etc/mdadm/mdadm.conf or the /etc/mdadm.conf file, where I need to
specify the array details so that it is assembled during boot time.

I manually created the mdadm.conf file in both locations and added the
"DEVICE partitions" line and a line with the result from mdadm
--examine --scan

Even though this was enough on the old version of mdadm for auto
assemble during the boot sequence (so that /etc/fstab could mount
/dev/md0), on version 3.0.2 it made no diferrence at all, as if the
mdadm I compiled and installed manually wouldn't read the mdadm.config
file, neither on /etc/mdadm/mdadm.conf or on /etc/mdadm.conf

Is there anything I could do to address this problem? Any way to
permanently point the mdadm to its mdadm.conf file? is there an
mdadm.conf file created on some other location on the disk, where I
can add the array information?

Thanks in advance

Kind regards

Angelos Kyritsis.
