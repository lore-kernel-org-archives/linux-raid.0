From: Andy Arvai <arvai@scripps.edu>
Subject: filesystems for large arrays
Date: Tue, 11 Feb 2003 01:25:56 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302110925.BAA08326@astra.scripps.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Does anyone have comments about the various filesystems typically used
with large (terabyte) arrays, regarding performance and reliability?

The three most common filesystems seem to be ext3, reiser and xfs. Ext3
and reiser are part of the standard linux kernel (not sure about xfs),
implying that they are fairly robust. I've been using reiser and
haven't had any problems, but I've heard that when the filesystem gets
full there may be problems and it's also optimized for many small files
instead of larger files. Ext3 sounds like it is very robust (since it
is based on ext2), although I've heard the performance is worse than
reiser. I've heard some good things about xfs, but have never used it.

If anyone has any real-world experiences or benchmarks I would be
interested.

Andy


