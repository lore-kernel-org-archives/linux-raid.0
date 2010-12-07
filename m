From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: interrupted resync not restarted properly?
Date: Tue, 7 Dec 2010 15:37:00 -0500
Message-ID: <AC1B83CE65082B4DBDDB681ED2F6B2EF866DF8@EXHQ.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It seems to me that resuming an interrupted resync doesn't always work
right... here's what I'm doing (kernel 2.6.36):

- start with a 2 disk raid1 with internal bitmap
- fail/remove one disk and zero the superblock
- add the disk to the raid1
- before resync completes, fail/remove the disk again
- re-add the disk again

For version 0 superblocks, this works the way I'd expect: on adding the
disk the second time, the resync continues (or restarts from the
beginning, not sure).

But for version 1 superblocks, on adding the disk the second time, the
resync completes immediately, leaving some part of the array
out-of-sync.

Should there be something in the v1 superblock to prevent this?

If the raid1 is stopped in the middle of the resync (instead of removing
the target disk) the resync is resumed correctly on re-assembly with
both devices.

Nate

