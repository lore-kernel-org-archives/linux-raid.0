From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Software raid, booting and bios
Date: Sun, 22 May 2011 07:31:48 +0100
Message-ID: <4DD8ADD4.1050601@gmail.com>
References: <9A.9E.03893.C8577DD4@cdptpa-omtalb.mail.rr.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9A.9E.03893.C8577DD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: paul@vandervlis.nl
Cc: 'Brad Campbell' <brad@wasp.net.au>, linux-raid@vger.kernel.org, lrhorer@satx.rr.com
List-Id: linux-raid.ids

I think you might want to investigate a SATA DOM (Disk on module).  My 
Thecus 5200 uses on and it seems a neat solution.

eg
http://www.innodisk.com/flashstorage-list.jsp?items_name=satadom

Simon

On 21/05/2011 09:19, Leslie Rhorer wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Brad Campbell
>> Sent: Friday, May 20, 2011 4:52 PM
>> To: linux-raid@vger.kernel.org
>> Subject: Re: Software raid, booting and bios
>>
>> On 21/05/11 03:32, Phil Turmel wrote:
>>
>>> the big deal is the lack of moving parts:  No spindle bearing, no head
>> positioner gear train.
>>
>> Sorry, this just tickled me. "gear train" ? Which decade are we talking
>> about? The last drive I saw
>> that had any form of mechanical power transfer mechanism for head
>> positioning was a 60MB RLL Seagate
>> clunker.
> 	Yeah, the number of moving parts in a hard drive is minimal.  OTOH,
> it's not zero.
>
>> Now, to add some form of use to the thread I've been using commodity CF
>> cards in home-brew CF to ATA
>> adaptors in embedded systems for 10 years. Flash is _the_ way to go for
>> high reliability systems
>> that don't have lots of write cycles.
>>
>> My TV box that has no on-board PXE has been booting from a 10MB USB stick
>> using loadlinux since
>> 2003. Dead reliable after ~69,000 hours power on time. I've not had a hard
>> disk last that long since
>> my old 200MB WD IDE drive (which is still running with over 100,000 hours
>> on it).
> 	Oh, we have quite a number of embedded controllers with SCSI hard
> drives that have been spinning continuously since 1992.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
