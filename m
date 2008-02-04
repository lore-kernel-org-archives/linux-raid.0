From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: raid1 or raid10 for /boot
Date: Mon, 4 Feb 2008 07:34:54 +0100
Message-ID: <20080204063454.GA31046@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand that lilo and grub only can boot partitions that look like
a normal single-drive partition. And then I understand that a plain
raid10 has a layout which is equivalent to raid1. Can such a raid10
partition be used with grub or lilo for booting?
And would there be any advantages in this, for example better disk
utilization in the raid10 driver compared with raid?

best regards
keld
