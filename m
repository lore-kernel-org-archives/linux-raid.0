From: Florian Lampel <florian.lampel@gmail.com>
Subject: Need Advice regarding chunk size of RAID6 regarding HFS+
Date: Tue, 18 Feb 2014 23:40:43 +0100
Message-ID: <FDEECA55-97E1-448E-AA80-76155613D8FD@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi everyone,

thanks again for getting me up and running again. I'm in the process of copying over my backups, but even when connecting my RAID6 via iSCSI directly via a dedicated ethernet cable using a dedicated IP-Range and Subnet, I only get write speeds of about 55MB/s and read speeds of about 68MB/s when copying a single, large file.

Having read enough about chunk sizes to make my head spin, I would like to know what chunk size you'd recommend for the following scenario:

*) The filesystem used is HFS+, and this means it's hard-coded to a 4kb block size.

*) The RAID is a RAID6 consisting of 12 HDDs (Western Digital RED, 2TB) using a chunk size of 512k (I stuck with the default).

*) Typical Usage consists of downloading material using Bittorrent and JDownloader (aka: lots of small writes) and feeding an AppleTV and Macs using iTunes (aka: Large files (Movies) being read from the RAID).

*) While the Filesystem is encrypted using LUKS, I got everything to align properly and my CPU supports AES-NI, so there is no performance penalty on this front.

*) The filesystem gets exported to a Mac Mini via iSCSI and then shared over the network using AFP and iTunes.


Any ideas?

Thanks,
Florian