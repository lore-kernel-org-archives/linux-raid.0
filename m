From: Scott Long <scott_long@adaptec.com>
Subject: Re: Adaptec 39160 RAID ?!
Date: Tue, 10 Feb 2004 13:33:26 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40294016.8080408@adaptec.com>
References: <40293C80.7020906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40293C80.7020906@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>, Thomas Graham <lkthomas@sml.dyndns.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Rechenberg, Andrew wrote:
> 
>>The Adaptec 39160 is just a plain SCSI card - the card does not have
> 
> any
> 
>>RAID capabilities.
>>
>>You can use Linux software RAID to create a RAID array with disks
>>attached to the 39160 (we have 4 our these cards in one of our
> 
> servers),
> 
>>but the card does not have any RAID capabilities native.
> 
> 
> 
> Yes, but doesn't the card ship with "fake RAID"?  i.e. no RAID hardware,
> 
> but BIOS has a RAID array setup utility and thus fools the user into 
> thinking he has h/w RAID :)
> 
> 	Jeff
> 
> 

The Adaptec Ultra160 products do not ship with software/BIOS raid.

Scott

