From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 14:20:50 +0100
Message-ID: <1156425650.3007.140.camel@localhost.localdomain>
References: <20060824090741.J30362@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751303AbWHXNBU@vger.kernel.org>
In-Reply-To: <20060824090741.J30362@mail.kroptech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

Ar Iau, 2006-08-24 am 09:07 -0400, ysgrifennodd Adam Kropelin:
> Jeff Garzik <jeff@garzik.org> wrote:
> with sw RAID of course if the builder is careful to use multiple PCI 
> cards, etc. Sw RAID over your motherboard's onboard controllers leaves
> you vulnerable.

Generally speaking the channels on onboard ATA are independant with any
vaguely modern card. And for newer systems well the motherboard tends to
be festooned with random SATA controllers, all separate!
