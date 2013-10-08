From: Hristo Chonov <chonov@vkm.tu-darmstadt.de>
Subject: mdadm >= 3.0 - udev test rule
Date: Tue, 8 Oct 2013 14:12:24 +0200
Message-ID: <CAHsdBYNPTp1tB9RsLPHAsCaFbSxMA2OZ3cqbqyKsqrjcC7-jkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have just a simple question about the udev rule:
TEST!="md/array_state", GOTO="md_end" or in the last two releases with
the systemd support: TEST!="md/array_state", ENV{SYSTEMD_READY}="0",
GOTO="md_end".

We are running a XenSever 6.2 system which is based on CentOS 5.7 with
included an old version of udev: udev-095. This version doesn't
support the ATTR keyword so I am going to swap it with the old one
SYSFS, but it appears that udev doesn't recognize as well the TEST
keyword, so I am wondering what exactly this rule is there for? Is it
checking if "md/array_state" appears somewhere in the attributes and
if not it jumps to "md_end"?
And do you have any idea how the rule should be rewritten for older
versions of udev?

Kind regards,
Hristo Chonov,
VKM, TU Darmstadt
