From: sama@inf.ufsc.br
Subject: Re: Help ! Kernel panic: VFS: Unable to mount root fs on 09:01 - Part II
Date: Fri,  2 May 2003 08:26:43 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1051874803.3eb255f37597d@webmail.inf.ufsc.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Paul.Clements@steeleye.com
List-Id: linux-raid.ids

Hi,

      I used linux root=/dev/hda2 on lilo prompt. The system returned me:

            VFS: Mounted root /ext2 filesystem readonly
             Warning: unable to open an initial console
             Kernel Panic: No init found. Try passing init= open to kernel.

      I used linux init=/bin/sh on lilo prompt but, the system returned me
the same error. Any suggestion ?

            Thanks,

         Roberto Samarone Araujo

> /dev/hda2 should be /boot directory ? I've tried /dev/hda3 / directory and
> the same error appeared.
>
>           Thanks,
>
>       Roberto Samarone Araujo
>
>
> > "Roberto Samarone Araujo (RSA)" wrote:
> >
> > > RAMDISK: Compressed image found at block 0
> > > invalid compressed format (err=1),6. Freeing initrd memory: 484 freed
> >
> > Looks like your initrd image got fried...I believe that's where raid1
> > should have gotten loaded and your array autostarted (if this is United
> > Linux 1.0/Conectiva)...
> >
> > try booting with "linux root=/dev/hda2" at the lilo prompt
> >
> > it still might not work though...
> >
> > good luck...
> >
> > --
> > Paul
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html





