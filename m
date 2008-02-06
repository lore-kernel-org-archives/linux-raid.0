From: Wolfgang Denk <wd@denx.de>
Subject: Re: recommendations for stripe/chunk size
Date: Wed, 06 Feb 2008 21:25:36 +0100
Message-ID: <20080206202536.3316124D1D@gemini.denx.de>
References: <47AA08E7.5000801@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Wed, 06 Feb 2008 14:22:15 EST."
             <47AA08E7.5000801@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <47AA08E7.5000801@tmr.com> you wrote:
>
> > I actually  think the kernel should operate with block sizes
> > like this and not wth 4 kiB blocks. It is the readahead and the elevator
> > algorithms that save us from randomly reading 4 kb a time.
> >
> >   
> Exactly, and nothing save a R-A-RW cycle if the write is a partial chunk.

Indeed kernel page size is an important factor in such optimizations.
But you have to keep in mind that this is mostly efficient for (very)
large strictly sequential I/O operations only -  actual  file  system
traffic may be *very* different.

We implemented the option to select kernel page sizes of  4,  16,  64
and  256  kB for some PowerPC systems (440SPe, to be precise). A nice
graphics of the effect can be found here:

https://www.amcc.com/MyAMCC/retrieveDocument/PowerPC/440SPe/RAIDinLinux_PB_0529a.pdf

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
You got to learn three things. What's  real,  what's  not  real,  and
what's the difference."           - Terry Pratchett, _Witches Abroad_
