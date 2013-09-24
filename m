From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Tue, 24 Sep 2013 05:55:16 +0000
Message-ID: <CA+dwz-1BWGpkAa+UDi3ZUMBTjgGu56iBMF0PnniV0Eqfjyu5dw@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
 <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
 <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
 <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
 <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com>
 <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZkeK-A@mail.gmail.com>
 <523FBFAA.3050705@turmel.org> <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
 <524034D2.4010407@turmel.org> <CA+dwz-0Y6+778sPHKn90B6dPNUyC7E__vhzR3BpeKaUgJQumqg@mail.gmail.com>
 <5240DCD3.6050802@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5240DCD3.6050802@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I strongly suspect that this is not an ext2/3/4 filesystem....

The recovered /etc/fstab mounts it as an ext3 filesystem:

# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/mapper/teramooch-root /               ext3
relatime,errors=remount-ro 0       1
UUID=20be44f0-4da3-439e-ae4e-cc4e08cc8e37 /boot           ext2
relatime        0       2
UUID=B627-AFF0  /fat32          vfat    utf8,umask=007,gid=46 0       1
/dev/mapper/teramooch-home /home           ext3    relatime        0       2
/dev/mapper/teramooch-opt /opt            ext3    relatime        0       2
/dev/mapper/teramooch-srv /srv            ext3
relatime,acl,user_xattr        0       2
/dev/mapper/teramooch-tmp /tmp            ext3    relatime        0       2
/dev/mapper/teramooch-usr /usr            ext3    relatime        0       2
/dev/mapper/teramooch-var /var            ext3    relatime        0       2
/dev/mapper/teramooch-backupduffycapemay
/srv/samba/mac_backups/duffycapemay            ext3    relatime
0       2
UUID=7fb288ca-400a-415a-97b7-35ceccddeb0f none            swap    sw
           0       0
/dev/scd0       /media/cdrom0   udf,iso9660 user,noauto,exec,utf8 0       0
/dev/fd0        /media/floppy0  auto    rw,user,noauto,exec,utf8 0       0

> It seems strange that this LV would be totally corrupted while the other
> LV's are perfect, but that is another possibility (however unlikely). Again,
> looking at the raw drive should show some file contents (if you look through
> enough of it), and this might also provide some help in working out what the
> problem is. I once assembled my raid0 (striping) in the wrong order, and
> looking at the individual member drives raw contents helped me work out the
> correct order.
>
> I hope the above helps. For now, it sounds like your FS format is not
> ext2/3/4 based. Maybe another one of the popular linux formats?

The /dev/mapper/teramooch-srv logical volume does represent a huge
majority of the disk space.

Dave
