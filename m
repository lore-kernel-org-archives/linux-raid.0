From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 09:04:05 -0700
Message-ID: <f3177b9e0911100804y5f358194q422c9196ac14ec70@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <1257846132.22155.155.camel@localhost>
	 <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
	 <4AF98B4C.6080805@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF98B4C.6080805@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 8:48 AM, Asdo <asdo@shiftmail.org> wrote:
> Chris Worley wrote:
>>
>> I'm not sure if you're agreeing or disagreeing here...
>> 280MB/s<300MB/s, due to the "compatibility" based design of SSD's,
>> while SSS, w/o a legacy controller, can do 800MB/s out of a single
>> drive.
>>
>
> I have not heard about these SSS you mention.
> Do you have a link?

All the Fusion-io products (fusionio.com) and TMS's (ramsan.com) RS20
are two examples (not their RAM-based products).  Sun has their
"Sunfire", but I haven't seen that yet.
>
> Also are you sure that the SATA/SCSI layer is the problem? Some hardware
> raids can do 800 MB/s sequential, single stream, and indeed with a SATA/SAS
> interface to the kernel. If what you say was true, that would be
> impossible...

Sequential/streaming performance is a corner case.  There are many
high speed solutions to that (even using rotating media).  I'm talking
random I/O at 128KB blocks at 800MB/s per drive.

Chris
>
