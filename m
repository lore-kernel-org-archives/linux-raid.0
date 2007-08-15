From: "Daniel Korstad" <dan@korstad.net>
Subject: RE:  SWAP file on a RAID-10 array possible?
Date: Wed, 15 Aug 2007 09:32:55 -0500
Message-ID: <1129650425.1187188375685.JavaMail.root@gateway.korstad.net>
References: <02db01c7df27$04321c60$332317ac@Cortex>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02db01c7df27$04321c60$332317ac@Cortex>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tomas France <tomfra@centrum.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I used this site to bring my existing Linux install to a RAID 1.   It worked great for me.
 
http://wiki.clug.org.za/wiki/RAID-1_in_a_hurry_with_grub_and_mdadm
 
 
 
----- Original Message -----
From: linux-raid-owner@vger.kernel.org on behalf of Tomas France 
Sent: Wed, 8/15/2007 5:28am
To: linux-raid@vger.kernel.org
Subject: Re: SWAP file on a RAID-10 array possible? 
 
 
Thanks for the answer, David!

I kind of think RAID-10 is a very good choice for a swap file. For now I 
will need to setup the swap file on a simple RAID-1 array anyway, I just 
need to be prepared when it's time to add more disks and transform the whole 
thing into RAID-10... which will be big fun anyway, for sure ;)

By the way, does anyone know if there is a comprehensive how-to on software 
RAID with mdadm available somewhere? I mean a website where I could get 
answers to questions like "How to convert your system from no RAID to 
RAID-1, from RAID-1 to RAID-5/10, how to setup LILO/GRUB to boot from a 
RAID-1 array" etc. Don't take me wrong, I have "done my homework" and found 
a lot of info on the topic but a lot of it is several years old and many 
things have changed since then. And it's quite scattered too..

Tomas


----- Original Message ----- 
From: "David Greaves" <david@dgreaves.com>
To: "Tomas France" <tomfra@centrum.cz>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, August 15, 2007 12:10 PM
Subject: Re: SWAP file on a RAID-10 array possible?


> Tomas France wrote:
>> Hi everyone,
>>
>> I apologize for asking such a fundamental question on the Linux-RAID list 
>> but the answers I found elsewhere have been contradicting one another.
>>
>> So, is it possible to have a swap file on a RAID-10 array?
> yes.
>
> mkswap /dev/md<X>
> swapon /dev/md<X>
>
> Should you use RAID-10 for swap? That's philosophy :)
>
> David
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
