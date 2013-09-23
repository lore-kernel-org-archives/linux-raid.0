From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Mon, 23 Sep 2013 08:32:18 -0400
Message-ID: <524034D2.4010407@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com> <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com> <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com> <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZke
 K-A@mail.gmail.com> <523FBFAA.3050705@turmel.org> <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Dave,

On 09/23/2013 12:55 AM, Dave Gomboc wrote:

[trim /]

Good news.

> [Actually, I mounted these rw first, then realized that I shouldn't
> have, unmounted them, and re-mounted them read-only.]
> 
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-root /mnt/root
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-home /mnt/home
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-tmp /mnt/tmp
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-usr /mnt/usr
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-var /mnt/var
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-opt /mnt/opt
> 
> These mount attempts returned without error, and ls within the
> directories is possible.
> 
> However, the large, important one doesn't mount:
> 
> root@sysresccd /mnt % mount -o ro -t ext3 /dev/mapper/teramooch-srv /mnt/srv
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/teramooch-srv,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so
> 
> root@sysresccd /mnt % mount -o ro /dev/mapper/teramooch-srv /mnt/srv
> NTFS signature is missing.
> Failed to mount '/dev/mapper/teramooch-srv': Invalid argument
> The device '/dev/mapper/teramooch-srv' doesn't seem to have a valid NTFS.
> Maybe the wrong device is used? Or the whole disk instead of a
> partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?
> 
> It should be ext3, not NTFS.

Since you are sure it is ext3, then you should use "fsck.ext3 -y" to fix
it.  I usually try that operation first with "-n" instead of "-y", but
your mount attempts show that the "-n" would be superfluous.  If fsck
scrambles that volume worse, then you'll have to recopy from your
backups and redo the forced assembly.  Or try with the other two disks.

Phil

