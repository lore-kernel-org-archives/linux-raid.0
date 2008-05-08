From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Multiple siI SATA cards and data corruption
Date: Thu, 8 May 2008 11:23:37 -0400
Message-ID: <29a863790805080823m296004e7p4f047b608c4d3eb6@mail.gmail.com>
References: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
	 <e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
	 <1f0f1a960805070234o2f9dfe07j42a1bd005b607791@mail.gmail.com>
	 <1af518580805070648r6060ca9ase0d03e9a17ffe0c7@mail.gmail.com>
	 <1f0f1a960805070720y4908b17dqe098d969f03ec37d@mail.gmail.com>
	 <4821C052.6090105@harddata.com>
	 <1f0f1a960805070752k6ed9c4dfj8ff2382d4557b013@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a960805070752k6ed9c4dfj8ff2382d4557b013@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Twigathy <twigathy@gmail.com>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had scary messages in dmesg like yours above. Spent forever
troubleshooting everything. New SATA cables and they disappeared.

Greg

On Wed, May 7, 2008 at 10:52 AM, Twigathy <twigathy@gmail.com> wrote:
> PSU is a relatively reliable, if slightly old now, 380W thing. It has
> enough power on the 12v lines to power the disks and CPU, but you may
> be onto something there - all disks reading/writing at once = power
> levels higher.
>
> The new kit I've ordered for this server includes a 450W PSU, so
> perhaps that'll solve things.
>
> The trouble with debugging a problem like this is that there are so
> many variables!
>
> 2008/5/7 Maurice Hilarius <maurice@harddata.com>:
>>
>>  Twigathy wrote:
>>  It could be cables, although that wouldn't explain the disks working
>> perfectly well (Maxed out, too in the case of doing a badblocks test)
>> when they are by themselves.
>>
>>  Sounds like a current delivery issue.
>>
>>  How is your power supply?
>>
>>
>> --
>>  With our best regards,
>>
>>  Maurice W. Hilarius         Telephone: 01-780-456-9771
>>  Hard Data Ltd.                FAX:          01-780-456-9772
>>  11060 - 166 Avenue         email:maurice@harddata.com
>>  Edmonton, AB, Canada         http://www.harddata.com/
>>       T5X 1Y3
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
