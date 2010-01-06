From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: embedding area is unusually small... (GRUB2 on software RAID1)
Date: Wed, 06 Jan 2010 12:02:06 -0400
Message-ID: <4589525.I9CuDL8pqf@rnqqfki.eternal-september.org>
References: <844035.90831.qm@web88203.mail.re2.yahoo.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lapohos Tibor wrote:

[...]
>> grub-install --root-directory=/root/os /dev/md0

> and I got a warning and an error message: "Your embedding area is
> unusually small.  core.img won't fit in it." and "Embedding is not
> possible, but this is required when the root device is on a RAID array or
> LVM volume."
 
> What did I do wrong, and how do I fix it? Thanks ahead,

Grub2 needs a space of about 55 sectors free after the MBR. It ussually is 
63 sectors. What's the output of:
	fdisk -lu /dev/sda
the start of the first partition should be 63 sectors or bigger to leave 
enough space for grub2 to be embedded.

However, the way you are making partitions is quite complex and the needed 
space could be somewhere else.

Please, stop repeating your question everywhere.

-- 
Antonio Perez

