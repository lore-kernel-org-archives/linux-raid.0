From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: stride / stripe alignment on LVM ?
Date: Fri, 2 Nov 2007 23:16:05 +0100
Message-ID: <20071102231605.7add5154@absurd>
References: <20071101101037.63b523f8@absurd>
	<18218.24819.569744.141171@notabene.brown>
	<472B1F91.8000208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472B1F91.8000208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen said:     (by the date of Fri, 02 Nov 2007 09:01:05 -0400)

> So I would expect this to make a very large performance difference, so 
> even if it work it would do so slowly.

I was trying to find out the stripe layout for few hours, using
hexedit and dd. And I'm baffled:

md1 : active raid5 hda3[0] sda3[1]
      969907968 blocks super 1.1 level 5, 128k chunk, algorithm 2 [3/2] [UU_]
      bitmap: 8/8 pages [32KB], 32768KB chunk

I fill md1 with random data:

# dd bs=128k count=64 if=/dev/urandom of=/dev/md1

# hexedit /dev/md1

I copy/paste (and remove formmatting) the first 32 bytes of /dev/md1,
now I search for those 32 bytes in /dev/hda3 and in /dev/sda3:

# hexedit /dev/hda3
# hexedit /dev/sda3

And no luck! I'd expect the first bytes of /dev/md1 to be on
beginning of the first drive (hda3).

I pick next 20 bytes from /dev/md1 and I can find them on /dev/hda3
starting just after address 0x10000. The bytes before and after those
20 bytes are similar to those on /dev/md1. So now I hexedit /dev/md1
and write by hand 32 bytes of 0xAA. Then I look at address 0x10000
on /dev/hda3 - and there is no 0xAA at all.

Well.. it's not critical for me, so you can just ignore my mumbling,
I was just wondering what obvious did I miss. There seems to be more
XORing (or sth. else) involved than I expected.

Maybe the disc did not flush writes, and what I see on /dev/md1 is
not yet present on /dev/hda3 (how's that possible?)

Nevertheless, I think that I will resign from LVM, and just put ext3
on /dev/md1, to avoid this stripe misalignment. I wanted LVM here
only because I might wanted to use lvm-snapshot, but I can live
without that. I can already grow /dev/md1 without LVM, but using
mdadm grow.

best regards
-- 
Janek Kozicki                                                         |
