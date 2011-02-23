From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: high throughput storage server?
Date: Wed, 23 Feb 2011 23:43:22 +0000
Message-ID: <4D659B9A.2090406@anonymous.org.uk>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6518ED.1080908@anonymous.org.uk> <4D658335.3040401@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D658335.3040401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/02/2011 21:59, Stan Hoeppner wrote:
> John Robinson put forth on 2/23/2011 8:25 AM:
>> On 23/02/2011 13:56, David Brown wrote:
>> [...]
>>> Incidentally, what's your opinion on a RAID1+5 or RAID1+6 setup, where
>>> you have a RAID5 or RAID6 build from RAID1 pairs? You get all the
>>> rebuild benefits of RAID1 or RAID10, such as simple and fast direct
>>> copies for rebuilds, and little performance degradation. But you also
>>> get multiple failure redundancy from the RAID5 or RAID6. It could be
>>> that it is excessive - that the extra redundancy is not worth the
>>> performance cost (you still have poor small write performance).
>>
>> I'd also be interested to hear what Stan and other experienced
>> large-array people think of RAID60. For example, elsewhere in this
>> thread Stan suggested using a 40-drive RAID-10 (i.e. a 20-way RAID-0
>> stripe over RAID-1 pairs),
>
> Actually, that's not what I mentioned.

Yes, it's precisely what you mentioned in this post: 
http://marc.info/?l=linux-raid&m=129777295601681&w=2

[...]
>> and I wondered how a 40-drive RAID-60 (i.e. a
>> 10-way RAID-0 stripe over 4-way RAID-6 arrays) would perform
[...]
> First off what you describe here is not a RAID60.  RAID60 is defined as
> a stripe across _two_ RAID6 arrays--not 10 arrays.  RAID50 is the same
> but with RAID5 arrays.  What you're describing is simply a custom nested
> RAID, much like what I mentioned above.

In the same way that RAID10 is not specified as a stripe across two 
RAID1 arrays, RAID60 is not specified as a stripe across two arrays. But 
yes, it's a nested RAID, in the same way that you have repeatedly 
insisted that RAID10 is nested RAID0 over RAID1.

> Anyway, you'd be better off striping 13 three-disk mirror sets with a
> spare drive making up the 40.  This covers the double drive failure
> during rebuild (a non issue in my book for RAID1/10), and suffers zero
> read or write performance, except possibly LVM striping overhead in the
> event you have to use LVM to create the stripe.  I'm not familiar enough
> with mdadm to know if you can do this nested setup all in mdadm.

Yes of course you can. (You can use md RAID10 with layout n3 or do it 
the long way round with multiple RAID1s and a RAID0.) But in order to 
get the 20TB of storage you'd need 60 drives. That's why for the sake of 
slightly better storage and energy efficiency I'd be interested in how a 
RAID 6+0 (if you prefer) in the arrangement I suggested would perform 
compared to a RAID 10.

I'm positing this arrangement specifically to cope with the almost 
inevitable URE when trying to recover an array. You dismissed it above 
as a non-issue but in another post you linked to the zdnet article on 
"why RAID5 stops working in 2009", and as far as I'm concerned much the 
same applies to RAID1 pairs. UREs are now a fact of life. When they do 
occur the drives aren't necessarily even operating outside their specs: 
it's 1 in 10^14 or 10^15 bits, so read a lot more than that (as you will 
on a busy drive) and they're going to happen.

Cheers,

John.
