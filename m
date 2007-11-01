From: Neil Brown <neilb@suse.de>
Subject: Re: stride / stripe alignment on LVM ?
Date: Fri, 2 Nov 2007 10:27:47 +1100
Message-ID: <18218.24819.569744.141171@notabene.brown>
References: <20071101101037.63b523f8@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Thursday November 1
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 1, janek_listy@wp.pl wrote:
> Hello,
> 
> I have raid5 /dev/md1, --chunk=128 --metadata=1.1. On it I have
> created LVM volume called 'raid5', and finally a logical volume
> 'backup'.
> 
> Then I formatted it with command:
> 
>    mkfs.ext3 -b 4096 -E stride=32 -E resize=550292480 /dev/raid5/backup
> 
> And because LVM is putting its own metadata on /dev/md1, the ext3
> partition is shifted by some (unknown for me) amount of bytes from
> the beginning of /dev/md1.
> 
> I was wondering, how big is the shift, and would it hurt the
> performance/safety if the `ext3 stride=32` didn't align perfectly
> with the physical stripes on HDD?

It is probably better to ask this question on an ext3 list as people
there might know exactly what 'stride' does.

I *think* it causes the inode tables to be offset in different
block-groups so that they are not all on the same drive.  If that is
the case, then an offset causes by LVM isn't going to make any
difference at all.

NeilBrown


> 
> PS: the resize option is to make sure that I can grow this fs
> in the future.
> 
> PSS: I looked in the archive but didn't find this question asked
> before. I'm sorry if it really was asked.

Thanks for trying!
