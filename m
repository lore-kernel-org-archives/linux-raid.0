From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: stride / stripe alignment on LVM ?
Date: Fri, 02 Nov 2007 09:01:05 -0400
Message-ID: <472B1F91.8000208@tmr.com>
References: <20071101101037.63b523f8@absurd> <18218.24819.569744.141171@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18218.24819.569744.141171@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 1, janek_listy@wp.pl wrote:
>   
>> Hello,
>>
>> I have raid5 /dev/md1, --chunk=128 --metadata=1.1. On it I have
>> created LVM volume called 'raid5', and finally a logical volume
>> 'backup'.
>>
>> Then I formatted it with command:
>>
>>    mkfs.ext3 -b 4096 -E stride=32 -E resize=550292480 /dev/raid5/backup
>>
>> And because LVM is putting its own metadata on /dev/md1, the ext3
>> partition is shifted by some (unknown for me) amount of bytes from
>> the beginning of /dev/md1.
>>
>> I was wondering, how big is the shift, and would it hurt the
>> performance/safety if the `ext3 stride=32` didn't align perfectly
>> with the physical stripes on HDD?
>>     
>
> It is probably better to ask this question on an ext3 list as people
> there might know exactly what 'stride' does.
>
> I *think* it causes the inode tables to be offset in different
> block-groups so that they are not all on the same drive.  If that is
> the case, then an offset causes by LVM isn't going to make any
> difference at all.
>   

Actually, I think that all of the performance evil Doug was mentioning 
will apply to LVM as well. So if things are poorly aligned, they will be 
poorly handled, a stripe-sized write will not go in a stripe, but will 
overlap chunks and cause all the data from all chunks to be read back 
for a new raid-5 calculation.

So I would expect this to make a very large performance difference, so 
even if it work it would do so slowly.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

