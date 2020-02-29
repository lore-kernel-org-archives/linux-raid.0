From: Hans Malissa <hmalissa76@gmail.com>
Subject: Choosing a SATA HD for RAID1
Date: Fri, 28 Feb 2020 19:47:37 -0700
Message-ID: <CAG6BYRzw4i6mtTfEVnMpwGAVW0r=BwODiN+0o-UggiaEyo4VSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to select suitable SATA HD for RAID1 via mdadm. I've been
reading through
https://raid.wiki.kernel.org/index.php/Choosing_your_hardware,_and_what_is_a_device%3Fand
https://raid.wiki.kernel.org/index.php/Timeout_Mismatch but I'm still
confused. I understand that I can use smartctl in order to determine
whether a drive is suitable, but what can I do to figure this out
before I purchase the drives? I've looked at
https://raid.wiki.kernel.org/index.php/Drive_Data_Sheets but I'm not
sure which information I'm looking for.
My planned mdadm RAID1 should serve to accommodate the /home
directory, so I will not need to boot from the array, and the workload
is going to be moderate. I just need to keep the data in /home secure
- I'm doing regular backups anyway, but I want to make sure that the
/home directory remains useable at all times.
The drives will be used on an openSUSE 12.3 x86_64 system with kernel
version 3.7.10 and mdadm version 3.2.6 on an Intel Desktop Board
DH67BL with SATA 6.0 Gb/s or 3.0 Gb/s. I am aware that these are
somewhat dated, but I have some specialized hardware and software
installed, and I'm therefore hesitant to update the system with newer
versions of the OS.
I'm considering Western Digital WD Gold, either 2TB (WD2005FBYZ) or
4TB (WD4003FRYZ). It says 'Enterprise Class', but I cannot find a
definitive confirmation that the drive does not suffer from the TLER
or SCT/ERC issue. Is it known whether these drives are suitable for
mdadm RAID1? Are there drives that are more suitable for my
application?
Thanks a lot,

Hans
