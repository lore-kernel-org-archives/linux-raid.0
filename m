From: raid@bymeinc.com
Subject: RE: Imaging Mirrored OS Drives
Date: Wed, 16 Aug 2006 13:32:21 -0400 (EDT)
Message-ID: <20060816173221.808211A14CC@bymeinc.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, I EOF'd too soon..
As to creating mirrored partitions over top of existing data, mdadm will write a superblock at the beginning of each mirrored component, which will blow up the first several bytes of the partition (probably the FS descriptor). I believe there is an option to create a raid1 pair without a superblock, but I don't think I would want to use it.

P.S. I'm sorry for not having a full name attached to my email address.. I'm baffled on how to do that with mailx.
