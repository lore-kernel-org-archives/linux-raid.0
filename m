From: Fabian Knorr <knorrfab@fim.uni-passau.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sat, 04 Jan 2014 23:08:18 +0100
Message-ID: <1388873298.7641.22.camel@vessel>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tRwW3m3BrYp1kacDRoSW"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C835C9.3050707@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-tRwW3m3BrYp1kacDRoSW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Phil,

I attached the wrong file in the other reply to your e-mail.

Fabian

--=-tRwW3m3BrYp1kacDRoSW
Content-Disposition: attachment; filename="partitions"
Content-Type: text/plain; name="partitions"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

$ ls /dev/disk/by-id | grep ata | grep sd[a-z]1 
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-SAMSUNG_HD204UI_S2JGJ1BZA02506-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-SAMSUNG_HD204UI_S2JGJ1BZA02507-part1 -> ../../sdh1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-SAMSUNG_HD204UI_S2JGJ1BZA02510-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-SAMSUNG_HD204UI_S2JGJ1BZA02513-part1 -> ../../sdi1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-ST2000DL004_HD204UI_S2H7J90C513540-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-ST2000DL004_HD204UI_S2H7J90C569210-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-ST2000DL004_HD204UI_S2H7JX0CA00102-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Jan  4 21:29 ata-ST2000DL004_HD204UI_S2H7JX0CA00103-part1 -> ../../sdb1

$ blkid /dev/sd* | grep raid
/dev/sda1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000549c5-01" 
/dev/sdb1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="0004ab8d-01" 
/dev/sdc1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="0003ba2a-01" 
/dev/sde1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000f04e8-01" 
/dev/sdf1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="0002f1df-01" 
/dev/sdg1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000d882d-01" 
/dev/sdh1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000658a7-01" 
/dev/sdi1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000d8fc8-01" 

--=-tRwW3m3BrYp1kacDRoSW--

