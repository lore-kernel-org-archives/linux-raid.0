From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 11:33:52 +0200
Message-ID: <ir5ci1$uc6$1@dough.gmane.org>
References: <9067914580344941270@unknownmsgid>	<ir58vs$9qp$1@dough.gmane.org> <20110520145623.749b4781@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520145623.749b4781@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op 20-05-11 10:56, Roman Mamedov schreef:
> On Fri, 20 May 2011 10:33:00 +0200
> Paul van der Vlis <paul@vandervlis.nl> wrote:
> 
>> You can select the "boot device priority" where you can choose about
>> devices types (DVD, harddisk, USB, network) but you can choose only one
>> SATA disk. Study it, and you will see I am right. I've asked it to my
>> rackserver-vendor, they say: "that's always the case".
> 
> How about just not buying crappy hardware from this lying vendor anymore.
> http://ompldr.org/vOHB6Zw/bios4.jpg <- this is present in majority of
> motherboard BIOSes since forever.

Interesting. From what brand server is this?

>> But I think I have had systems in the past, what could do it. An
>> interesting question is then: how well is it tested?  What when e.g. a
>> disk boots, and then gives an I/O error? I am looking for a well-tested
>> way to solve this, and I am willing to pay for it or choose another
>> hardware vendor for it.
> 
> Yes, I think it is conceivable that if a disk fails in a 'bad' way, i.e. by
> locking up on reads, or reading the first sector but not the next ones it can
> prevent the system from booting even with this priority system. I don't know
> if chances of that are high, considering that quite often disks fail by also
> ceasing to be detectable in BIOS, in which case your boot-up would proceed
> normally.

The problem is about detected disks with a defect in the MBR.

With regards,
Paul van der Vlis.


