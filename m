From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: NCQ general question
Date: Thu, 02 Mar 2006 06:20:00 -0500
Message-ID: <4406D4E0.3010800@pobox.com>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <4405C41F.5060504@yahoo.de> <20060301160554.GD4816@suse.de> <4405C9CA.9020500@pobox.com> <20060301185312.GI4816@suse.de> <5d96567b0603020014p62d73dc3uc3e67c300110f373@mail.gmail.com> <20060302081834.GY4816@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060302081834.GY4816@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Gentoopower <gentoopower@yahoo.de>, Mark Lord <liml@rtr.ca>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Jens Axboe wrote:
> (don't top post)
> 
> On Thu, Mar 02 2006, Raz Ben-Jehuda(caro) wrote:
> 
>>i can see the NCQ realy bother people.
>>
>>i am using a promise card sata TX4 150.
>>does any of you has a patch for the driver
>>so it would support NCQ ?
> 
> 
> I don't know of any documentation for the promise cards (or whether they
> support NCQ). Does the binary promise driver support NCQ?
> 
> Jeff likely knows a lot more.

The "sata2 tx4 150" supports NCQ, and I have docs.  "sata tx4 150" does 
not support NCQ.

	Jeff



