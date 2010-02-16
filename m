From: Bodo Eggert <7eggert@web.de>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 22:10:07 +0100
Message-ID: <E1NhUgJ-0004Tn-Qv@be1.7eggert.dyndns.org>
References: <edBWa-K7-9@gated-at.bofh.it> <edDXX-3XC-7@gated-at.bofh.it> <edRHA-7bL-13@gated-at.bofh.it> <eezfA-4N7-11@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> wrote:
> Volker Armin Hemmann wrote:
>> On Sonntag 14 Februar 2010, you wrote:

>>> In other words, 'auto-detection' for 1.x format devices is using an
>>> initrd/initramfs.
>>>     
>>
>> which makes 1.x format useless for everybody who does not want to deal with
>> initrd/initramfs.
>>   
> 
> You make this sound like some major big deal. are you running your own
> distribution? In most cases mkinitrd does the right thing when you "make
> install" the kernel,

I don't know what "make install" will do, so I'll have to expect random
results.

I don't expect it to copy bzimage to /boot/linux-version-commentfrommymind,
point the "ln" or "lt" entry (depending on if I want to upgrade or to test
a new kernel) in lilo.conf to the new kernel and to run lilo -R ln.

I don't expect it to sftp the kernel from my build machine to my server, either.

I expect it to move ~/bin/umount (a wrapper around /bin/umount fusermount -u
and smbumount) to initrd:/bin/umount. It might also create an initrd with a
passwordless rescue mode. Or it will use a minimal shell, and in case of
trouble, I have to fight the shell, too. In short: I expect it to backstab me.
(As a bonus, you can't read about rdinit= if you encounter your first initrd-ed
 system and init=/bin/sh does not work.)

> and if you are doing something in the build so 
> complex that it needs options, you really should understand the options
> and be sure you're doing what you want.

What I do is the most simple thing you can do. No initrd no cry. That's why I
have to use the 0.9 format. This - and the fact that my distribution defaults
to using the 1.0 format - is what I discovered after upgrading my system last
time.
