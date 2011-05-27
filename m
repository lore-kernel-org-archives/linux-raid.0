From: Stijn Hoop <stijn@sandcat.nl>
Subject: race condition in md creation?
Date: Fri, 27 May 2011 15:20:57 +0200
Message-ID: <20110527152057.47ca7176@pclin250.win.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/m/VuAg25iuuDK3Vgv9CwdgZ"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--MP_/m/VuAg25iuuDK3Vgv9CwdgZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

while creating a test suite for internal purposes I ran into a race
condition where a (very small) raid array that was just created cannot
be stopped.

mdadm --create succeeds, but the subsequent mdadm --stop reports
'Device or resource busy'.

Please see the attached script for reproduction purposes, partial output
from a run on my system (Fedora 14, kernel 2.6.35.13-91.fc14.x86_64,
mdadm-3.1.3-0.git20100804.2.fc14.x86_64):


5+0 records in
5+0 records out
5242880 bytes (5.2 MB) copied, 0.0166663 s, 315 MB/s
5+0 records in
5+0 records out
5242880 bytes (5.2 MB) copied, 0.0197533 s, 265 MB/s
mdadm: array /dev/md0 started.
mdadm: failed to stop array /dev/md0: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?
failed to stop /dev/md0, sleep 1 sec then retrying one more time
mdadm: stopped /dev/md0


I know that this might be an artificial bug, for with real raid arrays
people will not stop their just-created raid systems, but I figured
somebody might be interested to find out what was actually going on. As
I have no kernel expertise (yet! :) and I need to move on, I am only
posting my results...

BTW, I'm posting here only because I failed to google a bug tracker for
linux-raid. If there is one, my apologies, I will gladly create a bug
instead.

HTH,

--Stijn
--MP_/m/VuAg25iuuDK3Vgv9CwdgZ
Content-Type: application/x-shellscript
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=mdadm-bug.sh

IyEvYmluL3NoCmZvciBpIGluIGBzZXEgNTBgOyBkbwoJZGQgaWY9L2Rldi96ZXJvIG9mPS90bXAv
bWRsb29wLjAgYnM9MU0gY291bnQ9NQoJZGQgaWY9L2Rldi96ZXJvIG9mPS90bXAvbWRsb29wLjEg
YnM9MU0gY291bnQ9NQoJbG9zZXR1cCAvZGV2L2xvb3AwIC90bXAvbWRsb29wLjAKCWxvc2V0dXAg
L2Rldi9sb29wMSAvdG1wL21kbG9vcC4xCgltZGFkbSAtQyAtLWxldmVsPTEgLS1yYWlkLWRldmlj
ZXM9MiAtLW1ldGFkYXRhPTAuOTAgL2Rldi9tZDAgL2Rldi9sb29wWzAxXQoJaWYgISBtZGFkbSAt
LXN0b3AgL2Rldi9tZDA7IHRoZW4KCQllY2hvICJmYWlsZWQgdG8gc3RvcCAvZGV2L21kMCwgc2xl
ZXAgMSBzZWMgdGhlbiByZXRyeWluZyBvbmUgbW9yZSB0aW1lIgoJCXNsZWVwIDEKCQltZGFkbSAt
LXN0b3AgL2Rldi9tZDAgfHwgZXhpdCAxCglmaQoJbG9zZXR1cCAtZCAvZGV2L2xvb3AxCglsb3Nl
dHVwIC1kIC9kZXYvbG9vcDAKCXJtIC90bXAvbWRsb29wLlswMV0KZG9uZQo=

--MP_/m/VuAg25iuuDK3Vgv9CwdgZ--
