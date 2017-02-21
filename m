From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Tue, 21 Feb 2017 19:30:55 +0800
Message-ID: <e8ff590a-3972-465a-bf05-36f3e8542f0a@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
 <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
 <87shn9spsy.fsf@notabene.neil.brown.name>
 <87k28lshg5.fsf@notabene.neil.brown.name>
 <20170220070430.4mca7clpaw7kpj4j@kernel.org>
 <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
 <58AB320B.1060707@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58AB320B.1060707@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/21 上午2:14, Wols Lists wrote:
> On 20/02/17 08:07, Coly Li wrote:
>> For the function pointer asignment, it is because I see a brach happens in a loop. If I use a function pointer, I can avoid redundant brach inside the loop. raid1_read_request() and raid1_write_request() are not simple functions, I don't know whether gcc may make them inline or not, so I am on the way to check the disassembled code..
> 
> Can you force gcc to inline or compile a function? Isn't it dangerous to
> rely on default behaviour and assume it won't change when the compiler
> is upgraded?

I choose to trust compiler, and trust the people behind gcc.

Coly

