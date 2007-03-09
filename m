From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt questions
Date: Fri, 09 Mar 2007 00:20:11 -0500
Message-ID: <45F0EE8B.2020004@tmr.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<45EB3867.8050907@eyal.emu.id.au>	<17899.18568.523543.478792@notabene.brown>	<45EBCA83.40106@eyal.emu.id.au>	<17900.43653.510415.553440@notabene.brown>	<45EFAFB8.3070703@zytor.com> <yq1tzwvj0xp.fsf@sermon.lab.mkp.net> <45F0BFBA.5010201@tmr.com> <45F0E094.4060809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45F0E094.4060809@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Bill Davidsen wrote:
>>
>> When last I looked at Hamming code, and that would be 1989 or 1990, I 
>> believe that I learned that the number of Hamming bits needed to 
>> cover N data bits was 1+log2(N), which for 512 bytes would be 1+12, 
>> and fit into a 16 bit field nicely. I don't know that I would go that 
>> way, fix any one bit error, detect any two bit error, rather than a 
>> CRC which gives me only one chance in 64k of an undetected data 
>> error, but I find it interesting.
>>
>
> A Hamming code across the bytes of a sector is pretty darn pointless, 
> since that's not a typical failure pattern.
I just thought it was perhaps one of those little known facts that 
meaningful ECC could fit in 16 bits. I mentioned that I wouldn't go that 
way, mainly because it would be less effective catching multibit errors. 
This was a "fun fact" for all those folks who missed Hamming codes in 
their education, because they are old tech.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

