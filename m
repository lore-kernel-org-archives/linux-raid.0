From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing
 Soft RAID under Linux)
Date: Thu, 01 Jun 2006 08:15:16 +1000
Message-ID: <447E1574.60908@eyal.emu.id.au>
References: <20060531171801.56459.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060531171801.56459.qmail@web50208.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alex Davis wrote:
>>short swap16(short in)
>>{
>>       int i;
>>       short out=0;
>>       for (i=0; i<4; i++) {
>>               out = out<<8 | (in&255);
>>               in = in >> 8;
>>       }
>>       return out;
>>}
> 
> Shouldn't that be "for (i=0; i<2; i++) {..." ? 

In which case, do we really need this complexity rather than
a clear swap, e.g.
	return (short)(((in&0x0ff)<<8) | ((in>>8)&0x0ff))

Simple enough for a macro too.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
