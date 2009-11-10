From: Asdo <asdo@shiftmail.org>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 16:48:28 +0100
Message-ID: <4AF98B4C.6080805@shiftmail.org>
References: <4AF7066C.1040507@tmr.com>
 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
 <1257846132.22155.155.camel@localhost>
 <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chris Worley wrote:
> I'm not sure if you're agreeing or disagreeing here...
> 280MB/s<300MB/s, due to the "compatibility" based design of SSD's,
> while SSS, w/o a legacy controller, can do 800MB/s out of a single
> drive.
>   
I have not heard about these SSS you mention.
Do you have a link?

Also are you sure that the SATA/SCSI layer is the problem? Some hardware 
raids can do 800 MB/s sequential, single stream, and indeed with a 
SATA/SAS interface to the kernel. If what you say was true, that would 
be impossible...
