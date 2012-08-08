From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: What happened to TRIM support for raid linear/0/1/10?
Date: Wed, 08 Aug 2012 19:58:56 +0200
Message-ID: <jvu9cv$epn$1@dough.gmane.org>
References: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1208081308380.30954@praktifix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/08/2012 03:10 PM, Holger Kiehl wrote:
> Personally, I would think that TRIM support MD would be a very good thing.

That's one thing I am waiting for, too.

We had to implement a somewhat clumsy user-space application which does
the trick for us - but that is an ugly work-around, as it has to allocate
most of the free space on a filesystem for at least a little while (to know
what blocks it can discard).

Without periodic discard runs, our SSD-equipped servers suffer a ~50% write
performance penalty, so this feature is not just a cosmetic issue to us.

Regards,

Lutz Vieweg
