From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: stripe_cache_size, some info
Date: Mon, 20 Mar 2017 16:22:23 +0000
Message-ID: <58D001BF.1030804@youngman.org.uk>
References: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
 <58CFFC47.3000306@youngman.org.uk>
 <CAJH6TXhOokv1sOQL7KLe==rJQZ6J8D0gscQKJ5MPXSm5ZLXg9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhOokv1sOQL7KLe==rJQZ6J8D0gscQKJ5MPXSm5ZLXg9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/03/17 16:13, Gandalf Corvotempesta wrote:
> 2017-03-20 16:59 GMT+01:00 Wols Lists <antlists@youngman.org.uk>:
>> Burst speed, or sustained speed? Big difference ...
> 
> Both :)
> 
>> And I would avoid that entirely if I can - put the new disk in, do a
>> --replace, and then remove the old one. Doing a hotswap like that will
>> increase the stress on the array, and increased stress means another
>> disk is more likely to fail.
> 
> On newer server, i'll tend to avoid using all slots because of this.
> With at least 1 slot available, cool things could be done, like
> replace disks without compromize redundancy and so on.
> 
> But on older server, i don't have enough slot available and the only
> way to replace a disk is.... directly replace a disk :)
> 
Get a cheap PCI(e) SATA card! You should be able to get something for
around GBP20, and if it's only temporary who cares if drives and cables
are left all over the place so long as the data is safe while you're
updating. :-)

Cheers,
Wol
