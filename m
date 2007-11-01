From: Janek Kozicki <janek_listy@wp.pl>
Subject: stride / stripe alignment on LVM ?
Date: Thu, 1 Nov 2007 10:10:37 +0100
Message-ID: <20071101101037.63b523f8@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have raid5 /dev/md1, --chunk=128 --metadata=1.1. On it I have
created LVM volume called 'raid5', and finally a logical volume
'backup'.

Then I formatted it with command:

   mkfs.ext3 -b 4096 -E stride=32 -E resize=550292480 /dev/raid5/backup

And because LVM is putting its own metadata on /dev/md1, the ext3
partition is shifted by some (unknown for me) amount of bytes from
the beginning of /dev/md1.

I was wondering, how big is the shift, and would it hurt the
performance/safety if the `ext3 stride=32` didn't align perfectly
with the physical stripes on HDD?

PS: the resize option is to make sure that I can grow this fs
in the future.

PSS: I looked in the archive but didn't find this question asked
before. I'm sorry if it really was asked.

-- 
Janek Kozicki                                                         |
