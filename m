From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: Inject I/O latency for RAID5/6 read and writes
Date: Fri, 13 Mar 2015 11:29:32 +0100
Message-ID: <5502BC0C.1060004@profitbricks.com>
References: <CAB-428=gcsgxa1k83h0QWmijhe_kXaLMQZqs+m=Zb0OWX06geA@mail.gmail.com> <CAB-428=f7eL3iD=0g9MsYV78KUng_dysEs+=70taPP9wh_UkbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428=f7eL3iD=0g9MsYV78KUng_dysEs+=70taPP9wh_UkbQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>, Linux RAID <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 12.03.2015 22:31, Alireza Haghdoost wrote:
> On Mon, Feb 23, 2015 at 12:32 PM, Alireza Haghdoost <alireza@cs.umn.edu> wrote:
>> I needed to inject I/O completion latency in the RAID5/6 codes for
>> test purpose. I was wondering where would be the good place in
>> md/raid5.c code to add delay ?
>>
>> So far I have tried adding mdelay/udelay in raid5_end_write_request()
>> and it seems it works to increase I/O completion of writes. However,
>> adding delay in raid5_end_read_request() does not really change the
>> read I/O latency. Any idea ?
>>
>> --Alireza
> 
> Can Some one help me on this issue ?

Everything comes through md_make_request() in drivers/md/md.c but there
are multiple different bio->bi_end_io functions. We have implemented
custom I/O latency measurement. I've posted the patch to this list some
time ago. So feel free to look how it works as an inspiration.

http://www.spinics.net/lists/raid/msg46525.html

It introduces its own struct md_bio_private containing the original
bi_end_io function pointer and introduces the md_bio_endio() function as
a generic bi_end_io to be always called before calling the original
bi_end_io function.

I hope this helps! We've reworked this stuff since then a bit more but
it's really beneficial to detect disks which became slow.

Cheers,
Sebastian
