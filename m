From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: Supermicro AOC-SAT2-MV8
Date: Fri, 19 Dec 2008 22:15:43 +0000
Message-ID: <C571CD8F.BA37%groups@email.iain.rauch.co.uk>
References: <494C1B09.3000403@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <494C1B09.3000403@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman@fastmail.co.uk>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> OK, so it sounds like my suspicions were correct - I have PCI/PCIe.
> 
> You say I would be better to use PCIe, but the card is PCI-X. Can I use
> PCI-X in a PCIe slot?

No, but if you would like better performance (and can afford it), a PCIe
card is the better option. Depending on your usage and requirements, PCI-X
will be fine, but as mentioned it may not physically fit in your particular
motherboard. You need to check what slots you do have as PCIe come in a
variety of sizes also.


Regards,

Iain


