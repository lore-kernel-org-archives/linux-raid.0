From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Adding disks with raid to existing raid system.
Date: Sun, 14 Mar 2010 22:23:46 -0800
Message-ID: <40b437201003142323g7b0f4e48wb9d58b963f12e988@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have just built a system and have it booting off a software raid
partition. The raid sets use devices /dev/md0, /dev/hd1, /dev/md2,
/dev/md3.

I now need to transfer some additional disks to this system. These
disks are presently in another system where they host a number of raid
sets, currently also /dev/md0 - /dev/md4.

I need to ensure that the data on the raid set that I am adding to the
system is not lost. However, clearly, I can't have the raid sets on
these disks come up as /dev/md0-md4. How do I ensure this and have
these raid sets come up on /dev/md5 and higher?

Simon
