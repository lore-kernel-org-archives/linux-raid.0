From: "T. Ermlich" <pelegrine@gmx.net>
Subject: Re: Broken harddisk
Date: Sat, 29 Jan 2005 19:18:06 +0100
Message-ID: <41FBD35E.2020404@gmx.net>
References: <41FAD73F.1070504@gmx.net> <Pine.LNX.4.56.0501291218200.25299@lion.drogon.net> <41FBAD0B.2080408@gmx.net> <Pine.LNX.4.56.0501291538270.25299@lion.drogon.net> <41FBBE1B.7060406@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <41FBBE1B.7060406@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some more info

T. Ermlich scribbled on 29.01.2005 17:47:
[...]

>>   badblocks -s -c 256 /dev/sdb6
>>   badblocks -s -c 256 /dev/sdb7
>>   badblocks -s -c 256 /dev/sdb8

suse92:/ # badblocks -s -c 256 /dev/sda6
Suche nach defekten Bl=C3=B6cken (Nur-Lesen-Modus):done
suse92:/ # badblocks -s -c 256 /dev/sda7
Suche nach defekten Bl=C3=B6cken (Nur-Lesen-Modus):done
suse92:/ # badblocks -s -c 256 /dev/sda8
Suche nach defekten Bl=C3=B6cken (Nur-Lesen-Modus):done
suse92:/ # badblocks -s -c 256 /dev/sda5
Suche nach defekten Bl=C3=B6cken (Nur-Lesen-Modus): 26188800/ 52436097

Then the system hungs .. I did it twice, and twice it hung.

The last messages in /var/log/messages are:
Jan 29 19:06:11 suse92 kernel: Current sda: sense key Medium Error
Jan 29 19:06:11 suse92 kernel: Additional sense: Unrecovered read error=20
- auto reallocate failed
Jan 29 19:06:11 suse92 kernel: end_request: I/O error, dev sda, sector=20
52460485
Jan 29 19:06:12 suse92 kernel: ata2: status=3D0x51 { DriveReady=20
SeekComplete Error }
Jan 29 19:06:12 suse92 kernel: ata2: error=3D0x40 { UncorrectableError }
Jan 29 19:06:12 suse92 kernel: scsi1: ERROR on channel 0, id 0, lun 0,=20
CDB: Read (10) 00 03 20 7b c6 00 00 b8 00
Jan 29 19:06:12 suse92 kernel: Current sda: sense key Medium Error
Jan 29 19:06:12 suse92 kernel: Additional sense: Unrecovered read error=20
- auto reallocate failed
Jan 29 19:06:12 suse92 kernel: end_request: I/O error, dev sda, sector=20
52460486
Jan 29 19:06:13 suse92 kernel: ata2: status=3D0x51 { DriveReady=20
SeekComplete Error }
Jan 29 19:06:13 suse92 kernel: ata2: error=3D0x40 { UncorrectableError }
Jan 29 19:06:13 suse92 kernel: scsi1: ERROR on channel 0, id 0, lun 0,=20
CDB: Read (10) 00 03 20 7b c7 00 00 b7 00
Jan 29 19:06:13 suse92 kernel: Current sda: sense key Medium Error
Jan 29 19:06:13 suse92 kernel: Additional sense: Unrecovered read error=20
- auto reallocate failed
Jan 29 19:06:13 suse92 kernel: end_request: I/O error, dev sda, sector=20
52460487
Jan 29 19:06:14 suse92 kernel: ata2: status=3D0x51 { DriveReady=20
SeekComplete Error }
Jan 29 19:06:14 suse92 kernel: ata2: error=3D0x40 { UncorrectableError }
Jan 29 19:06:14 suse92 kernel: scsi1: ERROR on channel 0, id 0, lun 0,=20
CDB: Read (10) 00 03 20 7b c8 00 00 b6 00
Jan 29 19:06:14 suse92 kernel: Current sda: sense key Medium Error
Jan 29 19:06:14 suse92 kernel: Additional sense: Unrecovered read error=20
- auto reallocate failed
Jan 29 19:06:14 suse92 kernel: end_request: I/O error, dev sda, sector=20
52460488

Well, now I think, as only sda5 is involved, I'll re-format it, check it=20
for badblocks, and copy the previciously copied data back on it ...

c y
Torsten

