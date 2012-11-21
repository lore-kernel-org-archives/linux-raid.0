From: "George Spelvin" <linux@horizon.com>
Subject: Re: want-replacement got stuck?
Date: 21 Nov 2012 11:33:00 -0500
Message-ID: <20121121163300.30697.qmail@science.horizon.com>
References: <20121120221145.9905.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121120221145.9905.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

Just to follow up to that earlier complaint, ext4 is now noticing some errors:

Nov 21 06:21:53 science kernel: EXT4-fs error (device md5): ext4_find_entry:1234: inode #5881516: comm rsync: checksumming directory block 0
Nov 21 07:57:03 science kernel: EXT4-fs error (device md5): ext4_validate_block_bitmap:353: comm flush-9:5: bg 4206: bad block bitmap checksum
Nov 21 08:41:37 science kernel: EXT4-fs error (device md5): ext4_validate_block_bitmap:353: comm flush-9:5: bg 3960: bad block bitmap checksum
Nov 21 08:45:18 science kernel: EXT4-fs error (device md5): ext4_validate_block_bitmap:353: comm flush-9:5: bg 4737: bad block bitmap checksum
Nov 21 08:50:16 science kernel: EXT4-fs error (device md5): ext4_mb_generate_buddy:741: group 4206, 5621 clusters in bitmap, 6888 in gd
Nov 21 08:50:16 science kernel: JBD2: Spotted dirty metadata buffer (dev = md5, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
Nov 21 15:50:29 science kernel: EXT4-fs error (device md5): ext4_validate_block_bitmap:353: comm python: bg 4138: bad block bitmap checksum
Nov 21 16:21:00 science kernel: UDP: bad checksum. From 187.194.52.187:65535 to 71.41.210.146:6881 ulen 70

I also experienced transient corruption of the last few K of my incoming mailbox.  (I.e. the last
couple of messages were overwritten with some other text file.  This morning, it's fine.)

Something is definitely wonky here...  I'm leaving it in the "stuck" state for a while
in case there's useful debugging info to be extracted, but I'm getting very alarmed by these
messages and want to reboot soon.
