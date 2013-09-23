From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 22:54:57 -0400
Message-ID: <523FAD81.9070005@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/22/2013 08:29 PM, Dave Gomboc wrote:
> I now have the 4TB Hitachis in again.  I'll leave them in unless you
> ask me to switch back to the 2TB Seagates.

Ok.

>> dd if=/dev/sdX1 bs=4096 skip=1 count=1 2>/dev/null |hexdump -C
>> dd if=/dev/sdX1 bs=4096 skip=2048 count=16 2>/dev/null |hexdump -C
>>
>> And reverify which drive name in linux corresponds to which serial number.
> 
> ls -l /dev/disk/by-id output includes:
> 
> lrwxrwxrwx 1 root root  9 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1310PAG5ZY0J -> ../../sdb
> lrwxrwxrwx 1 root root 10 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1310PAG5ZY0J-part1 -> ../../sdb1
> lrwxrwxrwx 1 root root  9 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1310PAG62REJ -> ../../sdc
> lrwxrwxrwx 1 root root 10 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1310PAG62REJ-part1 -> ../../sdc1
> lrwxrwxrwx 1 root root  9 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1310PAG62T2J -> ../../sdd
> lrwxrwxrwx 1 root root 10 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1310PAG62T2J-part1 -> ../../sdd1
> lrwxrwxrwx 1 root root  9 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1311PAG4W5TS -> ../../sda
> lrwxrwxrwx 1 root root 10 Sep 22 17:20
> ata-Hitachi_HDS724040ALE640_PK1311PAG4W5TS-part1 -> ../../sda1

Ok.

> root@sysresccd /root % dd if=/dev/sda1 bs=4096 skip=1 count=1
> 2>/dev/null |hexdump -C
> 00000000  fc 4e 2b a9 01 00 00 00  00 00 00 00 00 00 00 00  |.N+.............|
> 00000010  3c 76 af 95 fa 16 ca 54  33 0b 75 47 b9 04 0b 8a  |<v.....T3.uG....|
> 00000020  63 68 65 61 70 3a 74 65  72 61 6d 6f 6f 63 68 00  |cheap:teramooch.|
> 00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000040  df 62 21 4d 00 00 00 00  0a 00 00 00 02 01 00 00  |.b!M............|
> 00000050  00 68 e0 e8 00 00 00 00  00 04 00 00 04 00 00 00  |.h..............|
> 00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000080  00 08 00 00 00 00 00 00  82 6c e0 e8 00 00 00 00  |.........l......|
> 00000090  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 000000a0  00 00 00 00 00 00 00 00  66 80 69 13 40 2f 8c fb  |........f.i.@/..|
> 000000b0  a7 4e 11 fd 5c a1 7f ee  00 00 00 00 00 00 00 00  |.N..\...........|
> 000000c0  b5 fe 33 52 00 00 00 00  08 02 00 00 00 00 00 00  |..3R............|
> 000000d0  ff ff ff ff ff ff ff ff  7f 39 b7 06 80 01 00 00  |.........9......|
> 000000e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00000100  00 00 01 00 02 00 03 00  fe ff fe ff fe ff fe ff  |................|
> 00000110  fe ff fe ff fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
> *
> 00000400  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00001000



> root@sysresccd /root % dd if=/dev/sda1 bs=4096 skip=2048 count=16
> 2>/dev/null |hexdump -C
> 00000000  73 65 74 0d 0a 20 20 20  62 20 20 20 20 20 20 20  |set..   b       |

Oops.  Should have dropped the "bs=4096" on that one.  The default
"bs=512" is what I was trying for there.

However, based on the data you've reported, sda1 and sdc1 are identical,
down to the superblock bytes.  And sdb1 and sdd1 are also identical,
down to the superblock bytes.

Are you sure there were no misdirected "dd" operations?

Phil
