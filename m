From: "Tomas France" <tomfra@centrum.cz>
Subject: Re: SWAP file on a RAID-10 array possible?
Date: Wed, 15 Aug 2007 12:28:04 +0200
Message-ID: <02db01c7df27$04321c60$332317ac@Cortex>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com><5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com><c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com><18104.18410.623573.929770@notabene.brown><c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com><c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com><18104.21737.341407.654022@notabene.brown><c70ff3ad0708070431v3ba47ab0j533197d92aea884c@mail.gmail.com> <18104.23111.369229.891505@notabene.brown> <02a201c7df1b$07dec720$332317ac@Cortex> <46C2D101.8050205@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

