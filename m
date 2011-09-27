From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: RAID6 issues
Date: Tue, 27 Sep 2011 12:46:10 -0600
Message-ID: <201109271246.10137.thomas@fjellstrom.ca>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andriano <chief000@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 13, 2011, Andriano wrote:
> Hello Linux-RAID mailing list,
> 
> I have an issue with my RAID6 array.
> Here goes a short description of the system:
> 
> opensuse 11.4
> Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2011
> (a432f18) x86_64 x86_64 x86_64 GNU/Linux
> Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
> AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.21
> running mdadm 3.2.2, single array consists of 10 2T disks, 8 of them
> connected to the HBA, 2 - motherboard ports

Hi, this is slightly off topic, but I have an AOC-SASLP-MV8 as well, and I'd 
suggest swapping it out for a different card. The linux mvsas driver has been 
crap for years, and just recently it nearly killed my raid5 array, twice. One 
time it needed to resync, the next it first kicked out one drive, then the rest 
shortly after. I was not amused.

Stan Hoeppner suggested the LSI SAS1068E card, which looks to be very nice. 
Only slightly more expensive than the SASLP and well supported under linux.

I'll hopefully be getting my hands on a LSI 9210-8i soon. Shortly there-after 
I'll be selling my SASLP.

[snip]
> 
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
