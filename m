From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Tue, 28 Feb 2017 11:42:32 -0800
Message-ID: <20170228194232.ubkw6s3bxnl6nfyt@kernel.org>
References: <20170220070430.4mca7clpaw7kpj4j@kernel.org>
 <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
 <878tp0s7w8.fsf@notabene.neil.brown.name>
 <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de>
 <20170221174542.rer73ywil3oq26gj@kernel.org>
 <c04d68cd-96e8-dff9-c54e-54248394119f@suse.de>
 <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
 <20170223173418.qrgjpj6utgceg5f4@kernel.org>
 <b6134a31-6cf6-3ea4-a3e5-0073c38c3a51@suse.de>
 <CAD9gYJ+FqnFbJp3sY9k5j=ZtJiN6qPivJ665hJPX94eWaAMkJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAD9gYJ+FqnFbJp3sY9k5j=ZtJiN6qPivJ665hJPX94eWaAMkJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Cc: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:19:05AM +0100, 王金浦 wrote:
> Hi Coly, Hi Shaohua,
> 
> 
> >
> > Hi Shaohua,
> >
> > I try to catch up with you, let me try to follow your mind by the
> > split-in-while-loop condition (this is my new I/O barrier patch). I
> > assume the original BIO is a write bio, and original bio is split and
> > handled in a while loop in raid1_make_request().
> 
> It's still possible for read bio. We hit a deadlock in the past.
> See https://patchwork.kernel.org/patch/9498949/
> 
> Also:
> http://www.spinics.net/lists/raid/msg52792.html

Thanks Jinpu. So this is for the read side, where we don't have plug stuff.
Yep, that finally makes sense. It's my fault I didn't look at the read side
code carefully. Looks we need the patch Neil suggested.

Thanks,
Shaohua
