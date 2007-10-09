From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 07:56:24 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710090752570.11772@filesrv1.baby-dragons.com>
References: <20071008211313.6cd8bbb5@absurd> <470A846B.9090805@sauce.co.nz>
 <20071009002550.12b9b26d@absurd> <20071009004636.112c886e@absurd>
 <18186.63033.185101.385806@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18186.63033.185101.385806@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,

On Tue, 9 Oct 2007, Neil Brown wrote:
> On Tuesday October 9, janek_listy@wp.pl wrote:
>>
>> Problems at step 4.: 'man mdadm' doesn't tell if it's possible to
>> grow an array to a degraded array (non existant disc). Is it possible?
>
> Why not experiment with loop devices on files and find out?
>
> But yes:  you can grow to a degraded array providing you specify a
> --backup-file.
 	Is there an estimate of how large this file can get ?
 	It's probably a calculation based on disk & array parameters .
 	But I was unable to find a reference on it from the manpage .

 		Tia ,  JimL

> However I don't recommend it.  I would never recommend having a
> degraded array by design.  It should only ever happen due to a
> failure, and should last only until you can get a replacement
> rebuilt.
>
> Remember that a degraded raid5 has a greater risk of data loss than a
> single drive.
>
>>
>>
>> PS: the fact, that degraded array will be unsafe for the data is an
>> intented motivating factor for buying next drive ;)
>
> :-)
>
> NeilBrown
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
