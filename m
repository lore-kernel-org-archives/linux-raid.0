From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: External bitmap, questions
Date: Sat, 19 Feb 2011 00:47:10 +0000
Message-ID: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

From the mdadm manual:

"-b, --bitmap=
[...]
Note: external bitmaps are only known to work on ext2 and ext3.
Storing bitmap files on other filesystems may result in serious
problems."

I was planning to store the external bitmap on an ext4 partition. Will
this be a problem, or is the warning there because it hasn't been
tested enough but no problems found?

Thanks,
// Mathias
