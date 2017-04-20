From: Scott Sinno <scott.sinno@nasa.gov>
Subject: issue with assembly of named arrays w/selinux==permissive on CentOS7
Date: Thu, 20 Apr 2017 12:31:16 -0400
Message-ID: <3ec4cc1b-ce19-bbae-265c-f4f06e96be3a@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Jasen, John E." <john.jasen@nasa.gov>, "Spear, Carrie E. (GSFC-606.0)[COMPUTER SCIENCE CORP]" <carrie.e.spear@nasa.gov>, "David M. Kemeza" <dkemeza@nccs.nasa.gov>
List-Id: linux-raid.ids


	On a reasonably vanilla CentOS 7 platform, we're having trouble
assembling *named* mdadm arrays using selinux==permissive.  An example
from mdadm.conf

ARRAY /dev/md/upper7  UUID=e1203894:e9f3cd5d:94472a7f:3553137b
name=upper7 devices=/dev/dm-[0-9]*

	mdadm will quietly exit code 2 when we attempt assembly.  If selinux is
disabled outright, OR the array definition is changed to something more
conventional, ala

ARRAY /dev/md17  UUID=e1203894:e9f3cd5d:94472a7f:3553137b
devices=/dev/dm-[0-9]*

	It assembles just fine, reports healthy, etc.  Any insight?

#basic sysinfo
root@dass01:~# cat /etc/redhat-release
CentOS Linux release 7.2.1511 (Core)
root@dass01:~# uname -r
3.10.0-327.36.3.el7.x86_64
root@dass01:~# mdadm --version
mdadm - v3.3.2 - 21st August 2014



	
