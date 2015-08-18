From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
Subject: [PATCH 0/2] mdadm: Fix udev rule interaction with systemd
Date: Tue, 18 Aug 2015 13:51:31 +0200
Message-ID: <1439898693-936-1-git-send-email-thomas@archlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Good morning,

I discovered a problem with the interaction between systemd, mdadm and lvm: Every 5th boot or so, my lvm physical volume
on top of a raid1 array would not activate. This turned out to be a race condition with mdadm.

When activating the raid array, two uevents happen: an "ADD" event and a "CHANGE" event. In both cases, the mdadm udev
rules look at the md/array_state file in sysfs. However, I observed that an array with md/array_state == clean may still
be inaccessible. So, in order to analyze the issue, I looked at the contents of the "md/array_state" and the "size" sysfs
files. I discovered that during activation, my raid1 was in the following three states:

1) md/array_state: inactive, size: 0
2) md/array_state: clean, size: 0
3) md/array_state: clean, size: (the real array size)

So, if the ADD event happens in state 1) and the CHANGE event happens in state 3), everything is fine. However, sometimes the
ADD event happens in state 2) and the CHANGE event in state 3). In the latter case, the device is activated in systemd during
the ADD event, but udev internal settings like ID_FS_TYPE are not set (since the device is inaccessible). This causes the
problem described above.

What I don't know is if
a) the transition from state 1) to 3) should be atomic in the kernel.
b) state 2) is legal and this needs to be worked around in udev.

The first patch fixes a problem where ENV{SYSTEMD_READY} is never set to 1 after being set to 0.
The second patch checks whether the array has non-zero size before activating the systemd device unit (in case this is
not a kernel bug).
