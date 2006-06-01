From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Thu, 1 Jun 2006 09:11:34 +0200
Message-ID: <20060601071133.GE2064@percy.comedia.it>
References: <20060531171801.56459.qmail@web50208.mail.yahoo.com> <447E1574.60908@eyal.emu.id.au> <17534.16705.903525.672433@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17534.16705.903525.672433@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 01, 2006 at 11:22:09AM +1000, Neil Brown wrote:
>On Thursday June 1, eyal@eyal.emu.id.au wrote:
>> Alex Davis wrote:
>> >>short swap16(short in)
>> >>{
>> >>       int i;
>> >>       short out=0;
>> >>       for (i=0; i<4; i++) {
>> >>               out = out<<8 | (in&255);
>> >>               in = in >> 8;
>> >>       }
>> >>       return out;
>> >>}
>> > 
>> > Shouldn't that be "for (i=0; i<2; i++) {..." ? 
>
>Well, yes... if you want the code to actually work, I guess that might
>be an improvement....
most important,
shouldn't that be:
__u16 swap16(__u16 in)

?

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
