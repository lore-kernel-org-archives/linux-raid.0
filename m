From: Phil Turmel <philip@turmel.org>
Subject: Re: Looking to pick PCIe x4/x8 4+ SATA expansion card recommendation.
Date: Mon, 28 Mar 2016 15:41:49 -0400
Message-ID: <56F988FD.6010208@turmel.org>
References: <56F97B91.4070302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56F97B91.4070302@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ram,

On 03/28/2016 02:44 PM, Ram Ramesh wrote:
> The recommendations typically go for PCIe x1-2port type cards like
> this one
>> http://www.ebay.com/itm/PCI-E-Express-SATA3-SATA3-0-6Gb-s-eSATA-SATA-III-Card-ASMEDIA1061-/231378681315

Marvell
>> 
chipsets have a mixed history  on this list.  The SATA models
have been nothing but trouble.  But I haven't heard much about them
lately.  Maybe someone else can comment on recent performance.

The marvell SAS models were also trouble until the kernel drivers got
some love in the past couple years.  They're fine with current kernels.
I ran one of them as a short-term boost for an old server until I built
my most recent media server.  It was 4.1 kernel I believe.  I don't have
a link to that card handy, sorry.  (I gave it to a family member.)

> However, I am looking for something along PCIe x4/x8 with 4+ ports
> like this one
> 
>> http://www.amazon.com/SAS9211-8I-8PORT-Int-Sata-Pcie/dp/B002RL8I7M
> or (similar, but cheaper)
>> ww.ebay.com/itm/like/252048579357?lpid=82&chn=ps&ul_noapp=true

LSI has a very good reputation on this list.  The above is likely to be
a very good choice.  I have a similar unit in my media server:

https://smile.amazon.com/gp/product/B0034DMSO6/ref=oh_aui_detailpage_o05_s00?ie=UTF8&psc=1

Runs great.  I did replace the firmware with the "IT" version so it
would boot faster (no attempt to enable soft raid).

Phil
