From: PFC <lists@peufeu.com>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which? headaches galore!
Date: Mon, 23 Jan 2006 13:20:59 +0100
Message-ID: <op.s3ty89rfcigqcu@apollo13>
References: <200601230336.55220.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601230336.55220.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Jan 2006 09:36:54 +0100, Mitchell Laks <mlaks@verizon.net>  
wrote:

> Dear Experts,
>
> I wanted to ask for any experience with running raid with SATA drives and
> controllers here under linux.
>

	Well, here's mine :

	Maxtor SATA drives series 6V (those with 16 MB cache) are incompatible  
with nforce 3-4 SATA controllers. Maxtor acknowledges this. Symptom is a  
slow death of the drive, ending with command timeouts. When reverting the  
drive to SATA 1.5Gbps with the jumper, it works perfectly again (for a few  
days...). nvidia doesn't care. This is on windows and linux. In windows,  
you have to use fucking PIO mode or you get corruptions. nforce4 sata also  
has problems with plextor sata burners, and possibly others.

	The Maxtor 6L series (with 8 MB cache) work flawlessly.

	I currently have these SATA drives, on a nforce3 MSI mobo :

# hdparm -I /dev/sd? |grep "Model Numb"

         Model Number:       Maxtor 6L200M0
         Model Number:       Maxtor 6L250S0
         Model Number:       ST3250823AS
         Model Number:       ST3250823AS

	All work. I RMA'd the 6V250 drive and exchanged it against a good, old,  
IDE drive, which works perfect.

	It took me a month, 3 maxtor drives, and nights of googling to figure  
this out...

	My gut feeling is that SATA isn't that ready for prime-time after all...
