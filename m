From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Ubuntu mdadm Raid and EFI
Date: Mon, 28 Nov 2011 10:44:20 +0100
Message-ID: <4ED357F4.3050605@redhat.com>
References: <BLU0-SMTP47112CA111EE95226BAE366C9CE0@phx.gbl> <BLU0-SMTP1700793E8A96042A5B235CDC9CE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP1700793E8A96042A5B235CDC9CE0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Dominique <dcouot@hotmail.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/24/11 17:11, Dominique wrote:
> Ok, nothing like writing a mail to get intuition for the next steps..
> 
> First I simplified the initial setup.
> RAID1 for everyone, and only two HDD to start. I'll convert and expand
> at a later stage.
> I also added an EFI partition ('bootgrup' if I remember well). I did
> that on both disk.
> Reboot and voila, it boots.
> 
> But this kind of negates the RAID1 /boot logic. If the first disk fail,
> then what ? No EFI, no boot ?
> How - if possible - do you configure EFI to boot from RAID1 across xHDD
> to allow boot in degraded mode ?

Depends on how you create your raid - if you use IMSM raid, you can put
the EFI partition on the raid1 device as well. Given you have a
motherboard with an i5 processor, I would expect it to have support for
IMSM raid.

Check the BIOS settings for the drives - if you flip them from AHCI to
raid mode you ought to be able to do it this way.

Cheers,
Jes
