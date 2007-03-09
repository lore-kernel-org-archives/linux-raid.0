From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mismatch_cnt questions
Date: Thu, 08 Mar 2007 20:20:36 -0800
Message-ID: <45F0E094.4060809@zytor.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au>	<17899.18568.523543.478792@notabene.brown>	<45EBCA83.40106@eyal.emu.id.au>	<17900.43653.510415.553440@notabene.brown>	<45EFAFB8.3070703@zytor.com> <yq1tzwvj0xp.fsf@sermon.lab.mkp.net> <45F0BFBA.5010201@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45F0BFBA.5010201@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> 
> When last I looked at Hamming code, and that would be 1989 or 1990, I 
> believe that I learned that the number of Hamming bits needed to cover N 
> data bits was 1+log2(N), which for 512 bytes would be 1+12, and fit into 
> a 16 bit field nicely. I don't know that I would go that way, fix any 
> one bit error, detect any two bit error, rather than a CRC which gives 
> me only one chance in 64k of an undetected data error, but I find it 
> interesting.
> 

A Hamming code across the bytes of a sector is pretty darn pointless, 
since that's not a typical failure pattern.

	-hpa
