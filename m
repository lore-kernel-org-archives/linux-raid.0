From: Scott Long <scott_long@adaptec.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Mon, 22 Mar 2004 14:59:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <405F61C1.9090907@adaptec.com>
References: <459805408.1079547261@aslan.scsiguy.com> <4058A481.3020505@pobox.com> <4058C089.9060603@adaptec.com> <200403172245.31842.bzolnier@elka.pw.edu.pl> <4058EBEC.8070309@adaptec.com> <1079788027.5225.4.camel@laptop.fenrus.com>  <405E287E.3080706@adaptec.com> <1079946343.5296.5.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1079946343.5296.5.camel@laptop.fenrus.com>
To: arjanv@redhat.com
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, "Gibbs, Justin" <justin_gibbs@adaptec.com>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Arjan van de Ven wrote:
> On Mon, 2004-03-22 at 00:42, Scott Long wrote:
> 
> 
>>Well, code speaks louder than words, as this group loves to say.  I 
>>eagerly await your code.  Barring that, I eagerly await a technical
>>argument, rather than an emotional "you're wrong because I'm right"
>>argument.
> 
> 
> I think that all the arguments for using DM are techinical arguments not
> emotional ones. oh well.. you're free to write your code I'm free to not
> use it in my kernels ;)

Ok, the technical arguments I've heard in favor of the DM approach is 
that it reduces kernel bloat.  That fair, and I certainly agree with not
putting the kitchen sink into the kernel.  Our position on EMD is that
it's a special case because you want to reduce the number of failure
modes, and that it doesn't contribute in a significant way to the kernel
size.  Your response to that our arguments don't matter since your mind
is already made up.  That's the barrier I'm trying to break through and
have a techincal discussion on.

Scott

