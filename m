From: Wolfgang Denk <wd@denx.de>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 07 Feb 2008 09:49:32 +0100
Message-ID: <20080207084932.1AE1A246C5@gemini.denx.de>
References: <18346.39756.292908.58065@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Thu, 07 Feb 2008 16:46:52 +1100."
             <18346.39756.292908.58065@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Nail,

in message <18346.39756.292908.58065@notabene.brown> you wrote:
> 
> <quote>
> The second improvement is to remove a memory copy that is internal to the MD driver. The MD
> driver stages strip data ready to be written next to the I/O controller in a page size pre-
> allocated buffer. It is possible to bypass this memory copy for sequential writes thereby saving
> SDRAM access cycles.
> </quote>
> 
> I sure hope you've checked that the filesystem never (ever) changes a
> buffer while it is being written out.  Otherwise the data written to
> disk might be different from the data used in the parity calculation
> :-)

Sure. Note that usage szenarios of this implementation are  not  only
(actually  not  even  primarily)  focussed  on  using such a setup as
normal RAID server - instead processors like the 440SPe  will  likely
be  used  on  RAID  controller  cards itself - and data may come from
iSCSI or over one of the PCIe busses, but  not  from  a  normal  file
system.

> And what are the "Second memcpy" and "First memcpy" in the graph?
> I assume one is the memcpy mentioned above, but what is the other?

Avoiding the 1st memcpy means to skip the system block level caching,
i. e. try to use DIRECT_IO capability  ("-dio"  option  to  xdd  tool
which was used for these benchmarks).

The 2nd memcpy is the optimization for large  sequential  writes  you
quoted above.

Please keep  in  mind  that  these  optimizations  are  probably  not
directly  useful  for  general purpose use of a normal file system on
top of the RAID array; they have other goals: provide benchmarks  for
the  special  case  of  large synchrounous I/O operations (as used by
RAID controller manufacturers to show off their competitors), and  to
provide a base for the firmware of such controllers.

Nevertheless, they clearly show  where  optimizations  are  possible,
assuming you understand exactly your usuage szenario.

In real life, your  optimization  may  require  completely  different
strategies  -  for  example,  on  our  main file server we see such a
distribution of file sizes:

Out of a sample of 14.2e6 files,

	 65%    are smaller than  4 kB
	 80% 	are smaller than  8 kB
	 90% 	are smaller than 16 kB
	 96% 	are smaller than 32 kB
	 98.4% 	are smaller than 64 kB
	
You don't want - for example - huge stripe sizes in such a system.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Egotist: A person of low taste, more interested in  himself  than  in
me.                                                  - Ambrose Bierce
