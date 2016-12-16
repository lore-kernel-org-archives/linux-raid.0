From: Egbert Bouwman <eppo@xs4all.nl>
Subject: root in grub for raid1
Date: Fri, 16 Dec 2016 22:14:14 +0100
Message-ID: <20161216221414.7c67f80b@para.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Newbie, but this list seems to be for developers.
If that is true I'll ask my one question, and then retire.

Actually it is a question about grub, but I think the raid specialists
know more about this grub problem than the grubbers do.

Setting up raid1 for /dev/sda and /dev/sdb (actually for missing and /dev/sdb)
on /dev/md/data succeeded, but now I have to do a dpkg-reconfigure
grub-efi-amd64 and i don't know how to specify root in the two grub lines: 
	set root=...
and the linux command line
	linux root=
Please note that i chose md/data, and not the common md0.

egbert
-- 
Egbert Bouwman - Keizersgracht 197 II - 1016 DS Amsterdam - 020 6257991
