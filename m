From: Default User <default_user@email.it>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Wed, 11 Nov 2009 19:02:37 +0100
Message-ID: <4AFAFC3D.3000402@email.it>
References: <4AF7066C.1040507@tmr.com>
 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
 <1257846132.22155.155.camel@localhost>
 <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
 <4AF98B4C.6080805@shiftmail.org>
 <f3177b9e0911100804y5f358194q422c9196ac14ec70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <f3177b9e0911100804y5f358194q422c9196ac14ec70@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chris Worley wrote:
> On Tue, Nov 10, 2009 at 8:48 AM, Asdo <asdo@shiftmail.org> wrote:
>   
>> I have not heard about these SSS you mention.
>> Do you have a link?
>>     
>
> All the Fusion-io products (fusionio.com) and TMS's (ramsan.com) RS20
> are two examples (not their RAM-based products).  Sun has their
> "Sunfire", but I haven't seen that yet.
>   
I don't know TMS, I know Fusion-io a bit: it is indeed 10x faster than a 
SSD but it is also 10 times more expensive!
If you make a raid-0 of ten SSDs in a good hardware-raid controller, 
exported to the OS as a single SCSI disk, I bet you obtain about the 
same performances.
Look at this:
http://www.tomshardware.com/reviews/x25-e-ssd-performance,2365.html
by looking at this page
http://www.tomshardware.com/reviews/x25-e-ssd-performance,2365-7.html
it seems the "streaming writes" is apparently similar to the benchmark 
you want (see the specs), do you agree? Yes it's 0% random it's 4 
workers... and the blocksize is the one you want.
You find the result in the following page. That's 2.2GB/sec with 16 
disks. If you imagine it with 8 disks and only 1 controller (the 
benchmark uses 2 controllers with a software raid-0 above) it's more 
than the speed you want (800MB/sec) and it's with a SCSI interface.

What do you think?

>> Also are you sure that the SATA/SCSI layer is the problem? Some hardware
>> raids can do 800 MB/s sequential, single stream, and indeed with a SATA/SAS
>> interface to the kernel. If what you say was true, that would be
>> impossible...
>>     
>
> Sequential/streaming performance is a corner case.  There are many
> high speed solutions to that (even using rotating media).  I'm talking
> random I/O at 128KB blocks at 800MB/s per drive.
>   

