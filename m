From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Mon, 23 Sep 2013 03:19:15 +0000
Message-ID: <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
 <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
 <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
 <523FAD81.9070005@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523FAD81.9070005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[snipped]
> However, based on the data you've reported, sda1 and sdc1 are identical,
> down to the superblock bytes.  And sdb1 and sdd1 are also identical,
> down to the superblock bytes.
>
> Are you sure there were no misdirected "dd" operations?
>
> Phil

I did not start using ddrescue until after I was no longer able to
boot the raid array.  When I did the ddrescuing, I specifically used
the /dev/disk/by-id symlinks, not the sdX names, precisely in order to
avoid accidents.  I was extremely alarmed by the inability to boot the
raid10, and took extra care to make sure I was doing it properly.

Here are my ddrescue log files:

# Rescue Logfile. Created by GNU ddrescue version 1.16
# Command line: ddrescue --cluster-size=65536 --no-split --force
/dev/disk/by-id/ata-ST32000542AS_5XW1P852
/dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK1310PAG62REJ
/mnt/windows/5XW1P852_to_PK1310PAG62REJ.txt
# current_pos  current_status
0x1D1C0000000     +
#      pos        size  status
0x00000000  0x1D1C1116000  +


# Rescue Logfile. Created by GNU ddrescue version 1.16
# Command line: ddrescue --cluster-size=65536 --no-split --force
/dev/disk/by-id/ata-ST32000542AS_6XW1T1CG
/dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK1310PAG62T2J
/mnt/windows/6XW1T1CG_to_PK1310PAG62T2J.txt
# current_pos  current_status
0x1D1C0000000     +
#      pos        size  status
0x00000000  0x1D1C1116000  +


# Rescue Logfile. Created by GNU ddrescue version 1.16
# Command line: ddrescue --cluster-size=65536 --no-split --force
/dev/disk/by-id/ata-ST32000542AS_6XW1T14N
/dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK1311PAG4W5TS
/mnt/windows/6XW1T14N_to_PK1311PAG4W5TS.txt
# current_pos  current_status
0x1D1C0000000     +
#      pos        size  status
0x00000000  0x1D1C1116000  +


# Rescue Logfile. Created by GNU ddrescue version 1.16
# Command line: ddrescue --cluster-size=65536 --no-split --force
/dev/disk/by-id/ata-ST32000542AS_5XW1P41K
/dev/disk/by-id/ata-Hitachi_HDS724040ALE640_PK1310PAG5ZY0J
/mnt/windows/5XW1P41K_to_PK1310PAG5ZY0J.txt
# current_pos  current_status
0x1D1C0000000     +
#      pos        size  status
0x00000000  0x1D1C1116000  +

(/mnt/windows is just where I mounted a spare 64Gb fat32 partition
that is an extra, previously empty partition on the boot drive that
also holds /boot and a linux swap partition).

Dave
