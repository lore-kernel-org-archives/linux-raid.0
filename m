From: Sven Hartrumpf <hartrumpf@gmx.net>
Subject: Using a newer mdadm version just for re-adding a device
Date: Wed, 30 May 2012 19:38:15 +0200 (CEST)
Message-ID: <20120530.193815.809240125288589880.hartrumpf@gmx.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

Is it safe to mix mdadm versions in the following scenario?

openSUSE 12.1 comes with mdadm 3.2.2 (and kernel 3.1), which works fine
except that I am hit by the re-add bug:
I removed a partition (after "mdadm --manage --set-faulty ...") from a perfectly
working /dev/md1, but re-adding with "mdadm /dev/md1 -a ..." fails.
Reading the mailing list and the Changelog, I understand that
this is fixed in mdadm 3.2.5.
Hence, I compiled mdadm 3.2.5 from source.

Now my question is:
Can I safely use the resulting binary (renamed to mdadm325 to avoid confusion)
to re-add the device and then continue to use the 3.2.2 package from openSUSE?

Thanks for reading
Sven
