From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Sat, 25 Feb 2017 01:06:22 +0800
Message-ID: <ef194546-a825-7eab-f8cb-e5ee147d065b@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <87shnevcpr.fsf@notabene.neil.brown.name>
 <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
 <87shn9spsy.fsf@notabene.neil.brown.name>
 <87k28lshg5.fsf@notabene.neil.brown.name>
 <20170220070430.4mca7clpaw7kpj4j@kernel.org>
 <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
 <878tp0s7w8.fsf@notabene.neil.brown.name>
 <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de>
 <20170221174542.rer73ywil3oq26gj@kernel.org>
 <c04d68cd-96e8-dff9-c54e-54248394119f@suse.de>
 <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
 <87lgswqz3w.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgswqz3w.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/24 上午7:14, NeilBrown wrote:
> On Thu, Feb 23 2017, Coly Li wrote:
> 
>> 
>> I tried to set up a 4 layer stacked md raid1, and reduce I/O
>> barrier bucket size to 8MB, running for 10 hours, there is no
>> deadlock observed,
> 
> Try setting BARRIER_BUCKETS_NR to '1' and BARRIER_UNIT_SECTOR_BITS
> to 3 and make sure the write requests are larger than 1 page (and
> have resync happen at the same time as writes).

Hi Neil,

Yes, the above method triggers deadlock easily. After come to
understand how bios are handled in stacked raid1 and the relationship
between current->bio_list, plug->pending and conf->pending_bio_list, I
think I come to understand what you worried and the meaning of your fix.

I totally agree and understand there will be hash conflict sooner or
later now. Yes we need this fix.

Thanks to you and Shaohua, explaining the details to me, and help me
to catch up your mind :-)

Coly

