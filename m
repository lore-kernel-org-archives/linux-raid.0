From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: Booting from a raid1 device ?
Date: Tue, 28 Oct 2003 21:31:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031028203120.GA4121@bluff.diade.it>
References: <20031027152554.7738.qmail@web14507.mail.yahoo.com> <3F9D412A.F68B1461@SteelEye.com> <200310272311.19232.dusty@strike.wu-wien.ac.at> <20031028105644.GF30725@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031028105644.GF30725@marowsky-bree.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 28, 2003 at 11:56:44AM +0100, Lars Marowsky-Bree wrote:
> On 2003-10-27T23:11:19,
>    Hermann Himmelbauer <dusty@strike.wu-wien.ac.at> said:
> 
>>BTW, assuming I have md.o not as module but statically in the kernel, which
>>bootloader would support RAID1? I heard LlLO does this job but does also grub
>>- which I prefer - support Linux SW-RAID1?
> 
> grub doesn't yet afaik.

What does this exactly mean. I always use GRUB for Raid1 setup with boot
partition an md device, and I'm beginning to think I'm using it the wrong
way!

What I do is I 'setup' the partitios from a floppy:

title Install GRUB into (hd0,0) the first disk
root    (hd0,0)
setup   (hd0)
 
title Install GRUB into (hd1,0) the second disk
root    (hd1,0)
setup   (hd1)


Both partitions (hd0,0) and (hd1,0) are part of /dev/md/0

At that point I'm able to start from both devices... BTW I've never been
able to do that w/o passing from a floppy. If I do that from the CD I use to
install everithing seems OK but it doesn't boot.


-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
