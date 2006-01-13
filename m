From: Jared Johnson <spongebobsquarehat@gmail.com>
Subject: "too small for md"
Date: Thu, 12 Jan 2006 22:53:31 -0600
Message-ID: <c571c4540601122053o5ea8224dq3676fb51f19bca22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

I created a raid5 array with 6 parts but one "missing", thus with 5
drives.  I stuck some data on it and all was well.  I rebooted and it
didn't exist.  I think I needed to add something to mdadm.conf or
whatnot, but anyway.  I tried to manually assemble it but it told me
that one of the drives had no superblock. I did mdadm --examine
/dev/hda2 (the partition in question) and it tells me:

mdadm: /dev/hda2 is too small for md.

I don't really understand superblocks at all.  I google'd around and
saw some suggestions that such things might be caused by corrupt
superblocks, really very little information though.  Since my data is
backed up, I decided to try mdadm --zero-superblock /dev/hda2 althogh
I am not sure whether that will just certainly break things.  I get
the same "too small for md".  I tried everything with --force as well
with no change.  The partition in question, btw, is 220GB.

Any ideas?

Thanks

-Jared
