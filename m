From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 08:49:08 +1200
Message-ID: <4AAFFDC4.5090806@sauce.co.nz>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com> <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com> <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com> <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com> <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com> <87f94c370909151328j1f88ab4fi452fcbeb5f1e9172@mail.gmail.com> <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FE87C12A-00E6-4DF6-80CF-56850AFFE656@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, "Majed B." <majedb@gmail.com>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:

> I agree with this sentiment 100%.  I don't have a good answer for why  
> it topped out where it did, and that's one of the things I'm still  
> trying to get an answer to.

I can also confirm this sub par performance on the Sil 3124 - max 
throughput of around 120MB/s.

If your motherboard is able to set the "PCIe Max Payload Size" you may 
be able to improve things.

See Note 3 here:

http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Silicon_Image_3124

Regards,

Richard
