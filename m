From: "H. Peter Anvin" <hpa@zytor.com>
Subject: New RAID-6 snapshot
Date: 30 Dec 2003 03:34:28 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bsrns4$uaa$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I implemented read-modify-write for RAID-6, and at least on my
6-disk system it was a small but measurable performance *loss*.
Therefore, I have cleaned up the patches slightly, but basically
RAID-6 seems to work and it now needs people to test it out and let me
know what bugs is there.

Additionally, the previously mentioned generic md bug relating to
recovery onto multiple disks should be fixed in the main md code (it's
also needed for RAID-1.)

The new snapshot is at:

    http://www.kernel.org/pub/linux/kernel/people/hpa/raid6-20031230.tar.gz

... although I reserve the right to upload newer snapshots on an
ongoing basis :)

	-hpa


-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
