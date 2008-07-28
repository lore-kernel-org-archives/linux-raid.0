From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: cosmetic bug in mdadm
Date: Mon, 28 Jul 2008 12:35:14 -0500
Message-ID: <cccedfc60807281035n23a93665s412cab3b25464ef5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mdadm --grow --help shows

  --raid-disks=  -n   : Change the number of active devices in an array.
                      : array.

but the manpage uses:

  --raid-devices

The latter should be preferred?
Also, a --grow fails without a spare or --backup-file, however
--backup-file is only in the manpage, not in the --help. That's pretty
minor but useful.



-- 
Jon
