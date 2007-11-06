From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Software raid - controller options
Date: Tue, 06 Nov 2007 15:51:16 +1300
Message-ID: <472FD6A4.5030907@sauce.co.nz>
References: <1194315635.17361.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194315635.17361.20.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lyle Schlueter wrote:


> Are there any 4+ port PCI-e SATA controllers cards? 

Hi Lyle,

I've been doing a similar exercise here and have been looking at 
portmultiplier options using the Silicon Image 3124.

The other possibility is the Marvell based 8 port "dumb" SATA controller 
from Supermicro.

http://www.supermicro.com/products/accessories/addon/AoC-SAT2-MV8.cfm

It is PCI-X though, but there are plenty of boards around still with 
these slots.

My only concern here is the opening comment in the driver:

" 1) Needs a full errata audit for all chipsets.  I implemented most
   of the errata workarounds found in the Marvell vendor driver, but
   I distinctly remember a couple workarounds (one related to PCI-X)
   are still needed."

Enquiries here previously have not found anyone using this card.

Regards,

Richard
