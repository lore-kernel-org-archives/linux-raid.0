From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: debian software raid1
Date: Wed, 20 Apr 2011 10:59:18 -0400
Message-ID: <4DAEF4C6.8010902@cdf.toronto.edu>
References: <1303215166.2809.8.camel@valio>	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>	<4DADB24F.2030300@cdf.toronto.edu>	<20110420085148.12ac0002@notabene.brown>	<4DAE29EA.4040306@gmail.com> <20110420111239.734ae4c1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110420111239.734ae4c1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Landman <joe.landman@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 04/19/11 21:12, NeilBrown wrote:
> I seem to remember that I had to do something special to grub to get it to
> boot initially, but I also vaguely remember that after some series of updates
> (this is Debian) it seemed to get a lot easier.  My "grub.cfg" contains:
>
> menuentry 'Debian GNU/Linux, with Linux 2.6.32-5-686' --class debian --class gnu-linux --class gnu --class os {
>          insmod raid
>          insmod mdraid
>          insmod part_msdos
>          insmod ext2
>          set root='(md0,1)'
>          search --no-floppy --fs-uuid --set 03e9951f-d174-4d88-9b4c-dd7a31c0de61
>          echo    'Loading Linux 2.6.32-5-686 ...'
>          linux   /vmlinuz-2.6.32-5-686 root=UUID=6e8a3564-5588-476e-bbe5-a68c967c6c8e ro  quiet
>          echo    'Loading initial ramdisk ...'
>          initrd  /initrd.img-2.6.32-5-686
> }
>
> which was all automatically created, and it seems to "just work".

Yes, I am also reminded now that grub and md was a bit strange, mostly 
because I was converting a single drive system to a RAID1 system, and I 
had dd-d /dev/sda onto /dev/sdb. Grub seemed to struggle with the fact 
that the UUID was the same on /dev/sda1, /dev/sdb1, and naturally 
/dev/md0p1, which was initially created on top of /dev/sda. It refused 
to boot a couple of times complaining about the UUID, which was easily 
resolved by editing the grub entry on the fly in the grub prompt, and 
changing root=UUID=6e8a3564-5588-476e-bbe5-a68c967c6c8e to 
root=/dev/md0p1 (note that the UUID is just an example UUID), and 
booting that way. Afterward, doing:

grub-install --modules="raid" /dev/md0

seemed to eventually placate grub. Also, I did not really see any change 
in grub.cfg, but then again, I didn't actually do a "diff" of grub.cfg 
before and after. The point is that it still uses UUID, the UUID is 
still the same among all these devices (naturally, since this is RAID1), 
and it *no longer complains*. It's a bit disconcerting, but I will learn 
to live with it :D.

I hope this helps!
Iordan
