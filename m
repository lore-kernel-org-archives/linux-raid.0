From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: not again - raid corrupts data
Date: Thu, 24 Oct 2002 20:27:05 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210241827.UAA04947@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been here some time ago with this strange problem:

intel dual pentium server running redhat 7.1, 2 scsi disks
mirrored as software raid. when copying large files from
one partition to another, the file gets corrupted:

[vor@server tmp]$ cp /opt/java/jdk-1.3.1_02.i386.rpm .
[vor@server tmp]$ diff /opt/java/jdk-1.3.1_02.i386.rpm jdk-1.3.1_02.i386.rpm 
Binary files /opt/java/jdk-1.3.1_02.i386.rpm and jdk-1.3.1_02.i386.rpm differ

solution then was to upgrade the firmware of the two IBM scsi disks.

but, what a nightmare, after a (forced) reboot the whole problem is
here again. and, worst of all, the reboot caused a resync of the 
raid and a file system check which obviously corrupted some other
larger files.

I'm at the end of my sanity - any ideas, hints ?

tnx in advance.

