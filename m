From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Linux RAID migration
Date: Tue, 07 Aug 2007 12:37:39 +0200
Message-ID: <46B84B73.6090803@wpkg.org>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>	<5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>	<c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com> <18104.18410.623573.929770@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18104.18410.623573.929770@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: saeed bishara <saeed.bishara@gmail.com>, Tuomas Leikola <tuomas.leikola@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:

(...)

>>>> - can I really assume that RAID 5 on 2 hdds (degraded mode) will
>>>> function as raid 5?
>>> You should test by using loopback devices and files. But why degraded?
>>> raid5 of two disks should look like raid1.
>> I meant to ask whether raid 5 on 2 disks will function as raid1 :(
> 
> A 2-disk raid5 and a 2-disk raid1 put the data in exactly the same
> place - is that what you wanted to know?

Is the same valid for RAID-10?

Let's say, you degraded a 4-disk RAID-10 to just 2 (proper) disks.

Then, you want to migrate it to 2-disk, 3, 4, and eventually, 5-disk 
RAID-5 array.


Would the RAID-10 -> RAID-5 migration be as easy as in RAID-1 -> RAID-5 
case?



-- 
Tomasz Chmielewski
http://wpkg.org
