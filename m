From: rich turner <rich@storix.com>
Subject: mdadm create error
Date: Thu, 23 Sep 2004 10:42:26 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095961346.3465.29.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i cant figure out what is wrong with the following command. when i
remove the "parity=right-asymmetric" command option it does not fail.
but i need to be able to create the raid device with different parity
algorithms. it also fails on --level=5 and using the short forms of the
flags.

mdadm --create /dev/md2 --chunk=64 --level=6 --raid-devices=4 
--parity=right-asymmetric --spare-devices=2 /dev/vg0/turnerlv1
/dev/vg0/turnerlv2 /dev/vg0/turnerlv3 /dev/vg0/turnerlv4
/dev/vg0/turnerlv5 /dev/vg0/turnerlv6

mdadm: layout may only be sent once.  Second value was right-asymmetric

rich:/tmp # mdadm --version
mdadm - v1.5.0 - 22 Jan 2004

