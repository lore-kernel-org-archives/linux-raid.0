From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Thu, 29 Jul 2004 21:50:43 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091163043.12588.334.camel@tinny.home.foo>
References: <b476569a04072920533b757574@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b476569a04072920533b757574@mail.gmail.com>
To: Adam Hunt <kinema@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2004-07-29 at 20:53, Adam Hunt wrote:
> I'm looking at building what I guess you could call a budget NAS
> array.  I'm looking to start with four 250MB SATA drives on 3ware
> 8506-4LP controller.  I eventually want to move to eight drives in the
> box.  Is there any reason to expect that the performance of eight
> drives spread across two 8506-4LP controllers is going to be any worse
> then the same eight drives all on one 8506-8?

are they on the same PCI bus or not?

I've had issues where removing a drive (without notifying the 3ware
card) causes all access to that controller to lock up about 20 seconds
later.  It only locks up though for about 10-15 seconds and then
continues normally, so depending on your demands, that may be just fine
for you.

	Scott


