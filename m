From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: slow 'check'
Date: Wed, 14 Feb 2007 11:41:09 -0500
Message-ID: <45D33BA5.9070109@tmr.com>
References: <45CD5B26.5030707@eyal.emu.id.au>	 <Pine.LNX.4.64.0702100425150.8446@p34.internal.lan>	 <45CD9B32.20202@eyal.emu.id.au>	 <Pine.LNX.4.64.0702100522270.8446@p34.internal.lan>	 <45CE2C7A.2060106@tmr.com> <5d96567b0702110130u5b404af2y37d27c794d6ddfcc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0702110130u5b404af2y37d27c794d6ddfcc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Raz Ben-Jehuda(caro) wrote:
> I suggest you test all drives concurrently with dd.
> load dd on sda , then sdb slowly one after the other and
> see whether the throughput degrades. use iostat.
> furtheremore, dd is not the measure for random access.
AFAIK 'check' does no do random access, which was the original question. 
My figures are related only to that.

For random access, read should access only one drive unless there's an 
error, and write two, data and updated parity. I don't have the tool I 
want to measure this properly, perhaps later this week I'll generate one.
>
> On 2/10/07, Bill Davidsen <davidsen@tmr.com> wrote:
>>
>> Wait, let's say that we have three drives and 1m chunk size. So we read
>> 1M here, 1M there, and 1M somewhere else, and get 2M data and 1M parity
>> which we check. With five we would read 4M data and 1M parity, but have
>> 4M checked. The end case is that for each stripe we read N*chunk bytes
>> and verify (N-1)*chunk. In fact the data is (N-1)/N of the stripe, and
>> the percentage gets higher (not lower) as you add drives. I see no
>> reason why more drives would be slower, a higher percentage of the bytes
>> read are data.
>>
>> That doesn't mean that you can't run out of Bus bandwidth, but number of
>> drives is not obviously the issue. 


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

