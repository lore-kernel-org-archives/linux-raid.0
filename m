From: exe@agava.com
Subject: bug in --manage mode
Date: Mon, 20 Aug 2007 11:34:17 +0400
Message-ID: <op.txcknfdohy6b49@exelap>
Reply-To: exe@agava.com
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=koi8-r
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, I hit a bug in mdadm.

According to "--manage --help" this must work, but it doesn't:

-bash-3.2# mdadm --manage -a /dev/md2 /dev/sda3
mdadm: /dev/sda3 does not appear to be an md device

But this works fine:
-bash-3.2# mdadm --manage --add   /dev/md2 /dev/sda3
mdadm: re-added /dev/sda3


The version is:
LFS:root@~:mdadm --version
mdadm - v2.6.2 - 21st May 2007


--
Kandalincev Alexandre
