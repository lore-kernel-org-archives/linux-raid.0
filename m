From: Neil Brown <neilb@suse.de>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 7 Feb 2008 16:46:52 +1100
Message-ID: <18346.39756.292908.58065@notabene.brown>
References: <47AA08E7.5000801@tmr.com>
	<20080206202536.3316124D1D@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wolfgang Denk on Wednesday February 6
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Bill Davidsen <davidsen@tmr.com>, =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 6, wd@denx.de wrote:
> 
> We implemented the option to select kernel page sizes of  4,  16,  64
> and  256  kB for some PowerPC systems (440SPe, to be precise). A nice
> graphics of the effect can be found here:
> 
> https://www.amcc.com/MyAMCC/retrieveDocument/PowerPC/440SPe/RAIDinLinux_PB_0529a.pdf

Thanks for the link!

<quote>
The second improvement is to remove a memory copy that is internal to the MD driver. The MD
driver stages strip data ready to be written next to the I/O controller in a page size pre-
allocated buffer. It is possible to bypass this memory copy for sequential writes thereby saving
SDRAM access cycles.
</quote>

I sure hope you've checked that the filesystem never (ever) changes a
buffer while it is being written out.  Otherwise the data written to
disk might be different from the data used in the parity calculation
:-)

And what are the "Second memcpy" and "First memcpy" in the graph?
I assume one is the memcpy mentioned above, but what is the other?

NeilBrown
