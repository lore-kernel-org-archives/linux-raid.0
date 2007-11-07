From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: stride / stripe alignment on LVM ?
Date: Wed, 07 Nov 2007 10:00:39 +0100
Message-ID: <87sl3ijuq0.fsf@informatik.uni-tuebingen.de>
References: <20071101101037.63b523f8@absurd>
	<18218.24819.569744.141171@notabene.brown> <472B1F91.8000208@tmr.com>
	<20071102231605.7add5154@absurd>
	<1194115248.25553.59.camel@firewall.xsintricity.com>
	<20071103212118.5fd4c770@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071103212118.5fd4c770@absurd> (Janek Kozicki's message of
	"Sat, 3 Nov 2007 21:21:18 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki <janek_listy@wp.pl> writes:

> Doug Ledford said:     (by the date of Sat, 03 Nov 2007 14:40:48 -0400)
>
>> so you really only need to align the
>> lvm superblock so that data starts at 128K offset into the raid array.
>
> Sorry, I thought that it will be easier to figure this out
> experimentally - put LVM here or there, write 128k of data to the
> disc (inside LVM partition), then see (with hexedit) if this data is
> really split across several discs or not.
>
> In fact I even managed to find where LVM superblock starts inside
> RAID, the problem for me was that I wasn't sure where it ends, and
> where the actual data, starts, and *THAT* data has to be aligned on
> 128K offset. Now I know that I should simply look more carefully at
> LVM manuals, to see exactly what is the size of LVM superblock.

I would just check with "dmsetup table dev" to which byte offsets the
logical volume gets mapped to.

MfG
        Goswin
