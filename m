From: Timo.Bolse@SerNet.DE
Subject: RAID1 Mirroring question.
Date: Mon, 5 Apr 2004 16:45:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BAVLe-0001EM-00@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List,

We have a Linux Software RAID1 (mirroring). If there is a little error on one
of the disks (such a little error that the kernel dosn't recognize it). There
is a read request on the raid for a specific file. The output of one of the
disks differ from the output of the other disk. (But there are no errors 
recognized by the kernel / fs / raid-driver. Only one inverted bit for example)
What is RAID/MD doing? Are there checksums for the original file?


Timo
