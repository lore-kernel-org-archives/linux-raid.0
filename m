From: Dan Egli <dan@eglifamily.dnsalias.net>
Subject: Re: invalud argument when replacing disk of raid 5 set
Date: Sat, 08 Nov 2003 09:39:10 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FAD1C2E.5010706@eglifamily.dnsalias.net>
References: <3FAC523E.3050509@eglifamily.dnsalias.net> <news2mail-boj5ci$leu$1@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <news2mail-boj5ci$leu$1@cartman.spoiled.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Juri Haberland wrote:

| Dan Egli <dan@eglifamily.dnsalias.net> wrote:
|
|
|>I have a machine with a 3 disk raid 5 set. One of the disks has
|>developed bad sectors in the parity block (I'm assuming it is in the
|>block because badblocks /dev/hdb shows bad areas, badblocks /dev/md0
|>does not), which causes it to randomly get kicked out of the set. I got
|>a drive to replace it with today. It's not the exact same model, but
|>it's the same physical dimentions (C/H/S & capasity are identical). It's
|>just a little faster than the others, with a little more cache on the
|>drive. But when I repalce the bad drive with the good drive, I get
|>invalid arguments when trying to bring up the array. I don't get it.
|>There is a perfectly valid linux partition on the drive, /dev/hdb1 which
|>meeds the same specs as /dev/hdc1 and /dev/hdd1, but replacing hdb with
|>a drive showing no bad blocks won't work.
|
|
| What commands do you exactly type and what error messages do you
| exactly get?
|
| Juri
|
This is from memory because I"m at home and the machine is at the
office. But it should be close enough.

# raidstart /dev/md0
raidstart: Invalid Argument

if I let the system auto-start it during boot, it looks like this:

Starting Raid Devices: /dev/md0
raidstart: Invalid Argument
/dev/md0 is not a RAID0 or LINEAR set


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD4DBQE/rRwutwT22Jak4/4RAv1QAJdyw4dR732+FuonhE9EM+VudpZKAKCSMa7/
ljORujPwHAoD6127OmNbcQ==
=qA9k
-----END PGP SIGNATURE-----



