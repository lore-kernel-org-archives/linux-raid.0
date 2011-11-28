From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Ubuntu mdadm Raid and EFI
Date: Mon, 28 Nov 2011 14:07:06 +0000
Message-ID: <4ED3958A.9090909@anonymous.org.uk>
References: <BLU0-SMTP47112CA111EE95226BAE366C9CE0@phx.gbl> <BLU0-SMTP1700793E8A96042A5B235CDC9CE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP1700793E8A96042A5B235CDC9CE0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Dominique <dcouot@hotmail.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/11/2011 16:11, Dominique wrote:
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

I haven't used EFI/GPT at all yet, but I imagine the same as the 
old-fashioned MBR technique: install the boot loader separately on all 
the devices you might need to boot from. The CentOS and Fedora 
installers automatically do this for you with MBR and presumably with 
GPT as well if you configure /boot to be a md RAID-1 i.e. they put grub 
on all the drives making up /boot, and I would have thought the Ubuntu 
installer would as well, but you can do it by hand if you have to. Just 
replicate whatever's on sda to sdb, sdc etc.

Then when your first hard disc fails and you reboot, the BIOS will boot 
the first hard disc it finds, which will be your second hard disc, and 
all will be lovely. This doesn't work if your first hard disc is still 
visible but unreadable, but that's always been the problem, and you need 
BIOS RAID support (e.g. Intel IMSM) to cope with it.

And a quick suggestion: use RAID 10 for your swap partition, it'll be 
faster than RAID 1. Since you want to be able to survive 2 disc 
failures, you probably ought to use layout raid10,f3.

Hope this helps.

Cheers,

John.

-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
