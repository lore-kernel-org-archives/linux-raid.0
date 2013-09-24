From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: raid10 recovery assistance requested
Date: Tue, 24 Sep 2013 10:29:07 +1000
Message-ID: <5240DCD3.6050802@websitemanagers.com.au>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com> <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com> <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com> <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZkeK-A@mail.gmail.com> <523FBFAA.3050705@turmel.org> <CA+dwz-2CMaoquRso8
 d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com> <524034D2.4010407@turmel.org> <CA+dwz-0Y6+778sPHKn90B6dPNUyC7E__vhzR3BpeKaUgJQumqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-0Y6+778sPHKn90B6dPNUyC7E__vhzR3BpeKaUgJQumqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/09/13 22:57, Dave Gomboc wrote:
> It should be ext3, not NTFS.
>
> I'm pretty darn sure it's ext3.  I guess there is a small chance that
> all of them were upgraded to ext4 from ext3.

I think that wouldn't matter, AFAIK, ext4 is backward compatible...

> I saw Adam's post before yours, so I did first try various
> command-lines using -n:
>
> fsck.ext3 -n /dev/mapper/teramooch-srv
> e2fsck 1.42.7 (21-Jan-2013)
> ext2fs_open2: Bad magic number in super-block
> fsck.ext3: Superblock invalid, trying backup blocks...
> fsck.ext3: Bad magic number in super-block while trying to open
> /dev/mapper/teramooch-srv
>
> The superblock could not be read or does not describe a correct ext2
> filesystem.  If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblock
> is corrupt, and you might try running e2fsck with an alternate superblock:
>      e2fsck -b 8193 <device>
>
> [man fsck.ext3 mentions a backup superblock possibly being located at
> 8193, 16384, or 32768].
I strongly suspect that this is not an ext2/3/4 filesystem....

> [The same commands, except using fsck.ext4 instead of fsck.ext3, also
> gave the same generic output.  Finally, I tried the -y:]
>
> The above output was also returned instantaneously, despite the use of -y.
If -n can't find it, -y won't find it either.
> I have to head to work, but I would be happy to make further attempts
> when I'm home again.

I'd suggest you take a look at the raw LV to try and determine what 
format it should be. You should be able to check /etc/fstab if it was 
auto-mounted previously...

In any case, one method I've used before is:
strings /dev/vg/lv | less

Just look for anything that might be a description of the FS format.

Can also try:
file /dev/vg/lv
which can give some hints sometimes (or might just say "data")

Or even:
dd if=/dev/vg/lv of=/tmp/begin bs=1024 count=512
less /tmp/begin
Again, looking for some text which might describe what format this thing 
is in.

It seems strange that this LV would be totally corrupted while the other 
LV's are perfect, but that is another possibility (however unlikely). 
Again, looking at the raw drive should show some file contents (if you 
look through enough of it), and this might also provide some help in 
working out what the problem is. I once assembled my raid0 (striping) in 
the wrong order, and looking at the individual member drives raw 
contents helped me work out the correct order.

I hope the above helps. For now, it sounds like your FS format is not 
ext2/3/4 based. Maybe another one of the popular linux formats?

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
