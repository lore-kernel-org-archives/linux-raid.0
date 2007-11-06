From: Wolfgang Denk <wd@denx.de>
Subject: Re: Software raid - controller options
Date: Tue, 06 Nov 2007 07:27:01 +0100
Message-ID: <20071106062701.A4543249E7@gemini.denx.de>
References: <472FD6A4.5030907@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Tue, 06 Nov 2007 15:51:16 +1300."
             <472FD6A4.5030907@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <472FD6A4.5030907@sauce.co.nz> you wrote:
> 
> The other possibility is the Marvell based 8 port "dumb" SATA controller 
> from Supermicro.
> 
> http://www.supermicro.com/products/accessories/addon/AoC-SAT2-MV8.cfm
...
> Enquiries here previously have not found anyone using this card.

I dropped it into a Fedora 7 system and ran a couple of tests with it
(mostly bonnie++ and iozone). It worked out of the box (no manual
configuration or drivers needed); I didn't observer any problems yet,
and performance is OK, too.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Always try to do things in chronological order; it's  less  confusing
that way.
