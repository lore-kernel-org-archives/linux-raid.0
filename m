From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Change metadata version?
Date: Tue, 28 Feb 2012 15:46:44 -0600
Message-ID: <4F4D4B44.7060901@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid5 with metadata version 0.90 and would like to convert it
to 1.2. Is that possible? If so, how?

Backstory: the grub2 toolset (at least for Fedora 16) gets confused when
a raid partition ends on the last sector of the disk and the metadata is
0.90. It thinks that both the whole disk and the partition are
duplicates of each other instead of being the same thing. Moving the
metadata to the front of the partition will prevent this confusion.

--Larkin
