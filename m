From: Andrew Burgess <aab@cichlid.com>
Subject: Does mdadm --create harm existing data?
Date: Sat, 3 Dec 2005 08:01:58 -0800
Message-ID: <200512031601.jB3G1wVd019559@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Other than the superblocks, does 'mdadm --create' harm existing data?

It would seem that a fault tolerant array would need to be synchronized but I
don't recall this happening when I created raid6 arrays and it also seems that
you don't really care if parts of the array that haven't been written yet are
in sync.

The '--assume-clean' option would seem to be what I want but the man page say
it's for --build only.

I want to assemble an array from various damaged pieces to find the least
damaged configuration so I don't want any device writing or sync to happen.
I've been editing superblocks by hand but it's a bit of a pain :-)

Thanks for any help.

