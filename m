From: Warren Young <warren@etr-usa.com>
Subject: Re: Linux dpti driver in 2.4 kernel with Adaptec 2400A card
Date: Mon, 06 Jan 2003 16:27:12 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E1A10D0.7080603@etr-usa.com>
References: <1041614772.19602.379.camel@linda.lfix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1041614772.19602.379.camel@linda.lfix.co.uk>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Oliver Elphick wrote:
> I'm trying to install Debian Linux with kernel 2.4.20 on a machine with an
> Adaptec 2400A RAID card with 3 40Gb IDE disks attached.  

[snip]

> dpti0: Trying to reset device
> dpti0: Device reset not supported
> dpti0: Bus reset: SCSI Bus 0: tid: 11
> dpti0: Bus reset success.
> scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
> SCSI disk error:  host 0 channel 0 id 0 lun 0 return code = 30002
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 2
>  I/O error: dev 08:00, sector 0
>  unable to read partition table

I don't have your particular controller card (I've used the 2100S 
before, though) or anything else particular to your system, but since no 
one else has answered yet....

These messages say "cable problems" to me.  It appears that you have it 
configured for RAID-5, so try asking the RAID BIOS to do a complete 
rebuild.  This will force it to access all three disks intensely for a 
while.  If it passes on that, forget my diagnosis.  If it yells and 
screams while doing this rebuild, try using shorter cables, or step up 
to Teflon-insulated high-quality ones.  Make sure you're using 80-pin 
cables and not 40-pin ones, too.

