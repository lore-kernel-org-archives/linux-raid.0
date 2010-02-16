From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 15:30:04 -0800
Message-ID: <4B7B2A7C.5000405@zytor.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>	<4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown> <4B79F3CE.5030907@zytor.com> <4B7AD041.4060305@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7AD041.4060305@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Michael Evans <mjevans1983@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2010 09:05 AM, Bill Davidsen wrote:
> 
> I'm not really sure what you're getting at here, I use grub in MBR and 
> then add chain loader stanzas to grub.conf for many things, usually an 
> alternate Linux release, or to have 32/64 of the same release handy for 
> testing, and always memtest from the boot menu. Even Win98SP2 on one 
> machine, since that works very poorly under KVM. (ask Avi if you care 
> why, something about what it does in real mode). In any case, I don't 
> see the chain loader issue, unless you mean to reboot out of some other 
> OS into Linux.
> 

That's one of many uses, yes

Presumably the reason you don't have problems is because the partitions
you chainload aren't RAID partitions with 1.1 superblocks, or you're
specifying an explicit offset for your chainloads (Grub syntax allows that.)

Either which way, it's a good example of the usage model.  Chainloading
is important for a lot of people.

	-hpa
