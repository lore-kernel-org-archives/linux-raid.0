From: bernd@rhm.de
Subject: RAID1 detection of faulty disks
Date: Wed, 9 Feb 2005 19:49:48 +0100 (MEZ)
Message-ID: <200502091849.TAA05566@node130.rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

just for my understanding of RAID1. When is a partition set faulty?
As soon as a read hits a bad block or only when a write attempts to
write to a bad block?

I'm a little bit confused as I read the thread 'Robust read patch for raid1'.
Does it mean that a read succeeds even if one disk is already gone?

Greetings B. Rieke
