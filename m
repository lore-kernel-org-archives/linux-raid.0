From: "Roberto Samarone Araujo \(RSA\)" <sama@inf.ufsc.br>
Subject: Re: Help ! Kernel panic: VFS: Unable to mount root fs on 09:01
Date: Thu, 1 May 2003 17:42:43 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000901c31022$3faf6e60$b3d7d9c8@inpa.gov.br>
References: <002301c31015$8c75e4c0$9affff0a@inpa.gov.br> <3EB18094.41F84BAA@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/dev/hda2 should be /boot directory ? I've tried /dev/hda3 / directory and
the same error appeared.

          Thanks,

      Roberto Samarone Araujo


> "Roberto Samarone Araujo (RSA)" wrote:
>
> > RAMDISK: Compressed image found at block 0
> > invalid compressed format (err=1),6. Freeing initrd memory: 484 freed
>
> Looks like your initrd image got fried...I believe that's where raid1
> should have gotten loaded and your array autostarted (if this is United
> Linux 1.0/Conectiva)...
>
> try booting with "linux root=/dev/hda2" at the lilo prompt
>
> it still might not work though...
>
> good luck...
>
> --
> Paul

