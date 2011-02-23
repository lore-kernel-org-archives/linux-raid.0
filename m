From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Feb 2011 16:15:50 +0100
Message-ID: <ik38ch$amr$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6518ED.1080908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6518ED.1080908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/02/2011 15:25, John Robinson wrote:
> On 23/02/2011 13:56, David Brown wrote:
> [...]
>> Incidentally, what's your opinion on a RAID1+5 or RAID1+6 setup, where
>> you have a RAID5 or RAID6 build from RAID1 pairs? You get all the
>> rebuild benefits of RAID1 or RAID10, such as simple and fast direct
>> copies for rebuilds, and little performance degradation. But you also
>> get multiple failure redundancy from the RAID5 or RAID6. It could be
>> that it is excessive - that the extra redundancy is not worth the
>> performance cost (you still have poor small write performance).
>
> I'd also be interested to hear what Stan and other experienced
> large-array people think of RAID60. For example, elsewhere in this
> thread Stan suggested using a 40-drive RAID-10 (i.e. a 20-way RAID-0
> stripe over RAID-1 pairs), and I wondered how a 40-drive RAID-60 (i.e. a
> 10-way RAID-0 stripe over 4-way RAID-6 arrays) would perform, both in
> normal and degraded situations, and whether it might be preferable since
> it would avoid the single-disk-failure issue that the RAID-1 mirrors
> potentially expose. My guess is that it ought to have similar random
> read performance and about half the random write performance, which
> might be a trade-off worth making.
>

Basically you are comparing a 4-drive RAID-6 to a 4-drive RAID-10.  I 
think the RAID-10 will be faster for streamed reads, and a lot faster 
for small writes.  You get improved safety in that you still have a 
one-drive redundancy after a drive has failed, but you pay for it in 
longer and more demanding rebuilds.  But certainly RAID60 (or at least 
RAID50) seems to be a choice many raid controllers support, so it must 
be popular.


