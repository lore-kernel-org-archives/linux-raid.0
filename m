From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 12:22:14 +0900
Message-ID: <87aadq5q1l.fsf@gmail.com>
References: <isp2g2$rf$1@dough.gmane.org>
	<20110609114954.243e9e22@notabene.brown>
	<isqb2o$g0s$1@dough.gmane.org>
	<20110609220438.26336b27@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609220438.26336b27@notabene.brown> (NeilBrown's message of
	"Thu, 9 Jun 2011 22:04:38 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Thu, 09 Jun 2011 13:32:59 +0200 David Brown <david@westcontrol.com> wrote:
>
> You can see the current kernel code at:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=lib/raid6;h=970c541a452d3b9983223d74b10866902f1a47c7;hb=HEAD
>
>
> int.uc is the generic C code which 'unroll.awk' processes to make various
> versions that unroll the loops different amounts to work with CPUs with
> different numbers of registers.
> Then there is sse1, sse2, altivec which provide the same functionality in
> assembler which is optimised for various processors.
>
> And 'recov' has the smarts for doing the reverse calculation when 2 data
> blocks, or 1 data and P are missing.
>
> Even if you don't feel up to implementing everything, a start might be
> useful.  You never know when someone might jump up and offer to help.
>

Maybe I could help David to some extent. :)

I'm gonna read the raid6 code next week and hope that there is a room I
can help with, FWIW.

Thanks.


-- 
Regards,
Namhyung Kim
