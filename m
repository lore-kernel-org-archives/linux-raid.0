From: Steve Kwee <skwee@itw.de>
Subject: Re: raid1 boots with one disk only
Date: Tue, 8 Mar 2005 09:32:48 +0000 (UTC)
Message-ID: <loom.20050308T094858-940@post.gmane.org>
References: <2263802DEDF02046B82EB18DE91725ED17A3F2@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bailey, Scott <scott.bailey <at> eds.com> writes:

> I don't think this is a problem - my root device is on an md device also.
> From my Alphaserver (which is conveniently close to hand and alive) I have
> this entry in /etc/aboot.conf:
> 
> 0:1/vmlinuz-2.4.27-hamster.8 md=1,/dev/sda2,/dev/sdg2 ro root=/dev/md1
> console=ttyS0
> 
> In English  I am booting from partition 1 of my boot disk, which happens
> to be /dev/sda1 (which with /dev/sdg1 forms /dev/md0, which is mounted as
> /boot). I am loading a locally-built kernel which has md and lvm and scsi
> support built-in (thus no initrd is used). I don't know if that makes a
> difference.
> 
> >[...]
> 
> This doesn't look quite right to me, or maybe the messages have just changed
> between 2.4 and 2.6. I think that also you have had some possibly
> interesting messages roll off the beginning of your dmesg buffer. One,
> thought, which I am not confident about, is whether md is built as a module
> and loaded from your initrd and therefore does not see the boot command line

Hi Scott,

thanks a lot for your answers.
I posted another message yesterday with my solution to just compile the md and
raid1 drivers into the kernel which helped me.
It seems that my kernel is a bit more quiet about what it is doing on startup
but anyway it is working now, so the rest is pure curiosity.

I have tried to put a 

  options md=1,/dev/hda2,/dev/hdc2

to my /etc/modules.conf and boot with old kernel using md and raid1 as modules
again. But these options seem to have no effect.



