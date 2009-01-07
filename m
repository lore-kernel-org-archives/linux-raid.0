From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Tue, 06 Jan 2009 23:38:28 -0600
Message-ID: <49643FD4.9080100@shaw.ca>
References: <200901032104.15242.bs@q-leap.de> <496436C4.4070305@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496436C4.4070305@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bernd Schubert <bs@q-leap.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Tejun Heo wrote:
> Hello,
> 
> Bernd Schubert wrote:
>> But now more than a year has passed again without doing anything
>> about it and actually this is what I strongly criticize. Most people
>> don't know about issues like that and don't run file checksum tests
>> as I now always do before taking a disk into production. So users
>> are exposed to known data corruption problems without even being
>> warned about it. Usually even backups don't help, since one creates
>> a backup of the corrupted data.
> 
> sata_sil being one of the most popular controllers && data corruption
> reports seem to be concentrated on certain chipsets, I don't think
> it's a wide spread problem.  In some cases, the corruption was very
> reproducible too.
> 
> I think it's something related to setting up the PCI side of things.
> There have been hints that incorrect CLS setting was the culprit and I
> tried thte combinations but without any success and unfortunately the
> problem wasn't reproducible with the hardware I have here.  :-(

As far as the cache line size register, the only thing the documentation 
says it controls _directly_ is "With the SiI3114 as a master, initiating 
a read transaction, it issues PCI command Read Multiple in place, when 
empty space in its FIFO is larger than the value programmed in this 
register."

The interesting thing is the commit (log below) that added code to the 
driver to check the PCI cache line size register and set up the FIFO 
thresholds:

   2005/03/24 23:32:42-05:00 Carlos.Pardo
   [PATCH] sata_sil: Fix FIFO PCI Bus Arbitration

   This patch set default values for the FIFO PCI Bus Arbitration to
   avoid data corruption. The root cause is due to our PCI bus master
   handling mismatch with the chipset PCI bridge during DMA xfer (write
   data to the device). The patch is to setup the DMA fifo threshold so
   that there is no chance for the DMA engine to change protocol. We have
   seen this problem only on one motherboard.

   Signed-off-by: Silicon Image Corporation <cpardo@siliconimage.com>
   Signed-off-by: Jeff Garzik <jgarzik@pobox.com>

What the code's doing is setting the FIFO thresholds, used to assign 
priority when requesting a PCI bus read or write operation, based on the 
cache line size somehow. It seems to be trusting that the chip's cache 
line size register has been set properly by the BIOS. The kernel should 
know what the cache line size is but AFAIK normally only sets it when 
the driver requests MWI. This chip doesn't support MWI, but it looks 
like pci_set_mwi would fix up the CLS register as a side effect..

> 
> Anyways, there was an interesting report that updating the BIOS on the
> controller fixed the problem.
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=10480  
> 
> Taking "lspci -nnvvvxxx" output of before and after such BIOS update
> will shed some light on what's really going on.  Can you please try
> that?

Yes, that would be quite interesting.. the output even with the current 
BIOS would be useful to see if the BIOS set some stupid cache line size 
value..

> 
>> So IMHO, the driver should be deactived for sil3114 until a real
>> solution is found. And it only should be possible to force activate
>> it by a kernel flag, which then also would print a huuuge warning
>> about possible data corruption (unfortunately most distributions
>> disables inital kernel messages *grumble*).
> 
> The problem is serious but the scope is quite limited and we can't
> tell where the problem lies, so I'm not too sure about taking such
> drastic measure.  Grumble...
> 
> Yeah, I really want to see this long standing problem fixed.  To my
> knowledge, this is one of two still open data corruption bugs - the
> other one being via putting CDB bytes into burnt CD/DVDs.
> 
> So, if you can try the BIOS update thing, please give it a shot.
> 
> Thanks.
> 
