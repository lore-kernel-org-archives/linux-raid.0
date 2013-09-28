From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Sat, 28 Sep 2013 15:47:35 +0000
Message-ID: <CA+dwz-3DwwQ5_aCB8f8HJvKWqLGHF7-4BShe1QACnuzmXyo3KA@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
 <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
 <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
 <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
 <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com>
 <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZkeK-A@mail.gmail.com>
 <523FBFAA.3050705@turmel.org> <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
 <524034D2.4010407@turmel.org> <CA+dwz-0Y6+778sPHKn90B6dPNUyC7E__vhzR3BpeKaUgJQumqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-0Y6+778sPHKn90B6dPNUyC7E__vhzR3BpeKaUgJQumqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>
List-Id: linux-raid.ids

> fsck.ext3 -n /dev/mapper/teramooch-srv
> e2fsck 1.42.7 (21-Jan-2013)
> ext2fs_open2: Bad magic number in super-block
> fsck.ext3: Superblock invalid, trying backup blocks...
> fsck.ext3: Bad magic number in super-block while trying to open
> /dev/mapper/teramooch-srv

So, I am now restoring the content of the two drives that I altered
(by running ddrescue again) , so that I have all four drives copied as
before.

If each pair of two drives genuinely have the same information on
them, then I only seem to have that one method of array assembly
available to me, in which case I suppose I will need to try to scan at
a lower level, searching for parts of the ext3 filesystem of the
logical volume that I cannot mount.  I could certainly use some advice
on what might be worth trying in this scenario.  Even if I can't get
everything back, I should try to get anything back that I can.

However, if there is some variation between what two drives that
report place '0' (or the two drives that report place '3') are
actually holding, then I have more array assembly options to try
before dealing with the above issue.

Is there already some software out there (or do you think it would not
be particularly difficult for an experienced software developer who
does not have extensive knowledge of linux internals -- such as myself
:-) that could be used to treat the physical drives as read-only, and
do any "writes" to them to a layer in RAM instead?  That is, it would
read from RAM first, then from the disk only if nothing was present in
RAM, and always leave the contents of the disks unchanged when writing
back to RAM (never writing through to disk)?  If I had something like
that, I could make various attempts, then discard the changes easily
after failed tries, without having to restore the hard drive contents
from the actual original drive afterwards  Of course, I don't have
several terabytes of RAM, but I think there is really only a small
portion of the disk that is being edited when I am doing various
operations such as mdadm --assemble and vgchange.

Dave
