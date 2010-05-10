From: Mark Knecht <markknecht@gmail.com>
Subject: Re: What RAID type and why?
Date: Mon, 10 May 2010 08:34:25 -0700
Message-ID: <AANLkTinxPL3HpkJf8Uzgnnl-B3jLkF_CKHWnRNSwSxkn@mail.gmail.com>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
	 <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
	 <5bdc1c8b1003061505g6b310f6ct6795b9180c2e6adf@mail.gmail.com>
	 <20100510152048.GA12411@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100510152048.GA12411@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 10, 2010 at 8:20 AM, Matt Garman <matthew.garman@gmail.com>=
 wrote:
> On Sat, Mar 06, 2010 at 03:05:46PM -0800, Mark Knecht wrote:
>> On Sat, Mar 6, 2010 at 2:33 PM, Greg Freemyer <greg.freemyer@gmail.c=
om> wrote:
>> > You haven't said what kind of i/o rates you expect, nor how much
>> > storage you need.
>>
>> Good points. I guess I was assuming I'd want 1TB storage and I'd
>> buy 3/5/6 1TB drives to get it. Honestly I probably don't need
>> anything close to that. My weekly backups of stock data run about
>> 1GB to 1TB should hold me for quite awhile I think.
>
> Where are you sourcing the stock data? =C2=A01GB/week seems awful low=
=2E
> You must be getting top of book only?
>
> We get real-time full depth stock data. =C2=A0NYSE and Nasdaq data ar=
e
> each about 100 GB/month, compressed.
>
> Just something to keep in mind if you ever start working with
> full-depth feeds.
>
> Also: for backups, you might want to consider par2. =C2=A0You can use=
 it
> to create a specified amount of parity data for each file or group
> of files. =C2=A0Useful in the case of media errors.
>

Yeah, my description was a bit lacking. Sorry.

Currently I only auto-trade index futures so I get only the indexes
(tick & 1 minute) and then a few other general things (VIX, A/D, Gold,
Oil, 3 month T bill, etc.) for correlation purposes. I don't mess much
with individual stocks at all although I have it in my mind to start
creating some private out of individual stock data so if I do that
storage requirements will certainly go up.

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
