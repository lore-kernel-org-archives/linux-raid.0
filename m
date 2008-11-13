From: "Ryan Wagoner" <rswagoner@gmail.com>
Subject: Superblock limits / conversion
Date: Thu, 13 Nov 2008 09:46:23 -0500
Message-ID: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID 5 array with 3 TB drives. When reading through the list
I realized that the v0.90 superblock doesn't support arrays over 2TB.
This means I can never grow this array to 4 drives?

Is there a way to convert to the v1.0 superblock? I realize I can't
convert to the v1.1 or v1.2 without recreating the array. Is there any
advantages over the v1.1 or v1.2 formats with their placement of the
metadata not at the start of the device?

I read that the kernel autodetect will not work with v1 superblocks. I
have my mdadm.conf correctly configured. When booting this should be
all I need for the array to be assembled? Out of curiosity can v1
superblocks work on the /boot or / array? I would assume not because
it would need to be auto configured before the mdadm.conf could be
read.

Also "v1 supports restarting driver recovery that was interrupted by a
clean shutdown.". Does this mean that a initial resync or recovery
will continue and not restart when rebooting?

Thanks,
Ryan
