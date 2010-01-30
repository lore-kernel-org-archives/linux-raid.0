From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: raid10 How do I tell what side of the mirror a disk is on?
Date: Fri, 29 Jan 2010 23:22:33 -0800
Message-ID: <4877c76c1001292322u2f01d47auaa6041cd701e4176@mail.gmail.com>
References: <1264777247.29409.64.camel@thor>
	 <87k4v0wjx1.fsf@frosties.localdomain>
	 <1264810392.1880.5.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264810392.1880.5.camel@michal-laptop.sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82_Sawicz?= <michal@sawicz.net>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/29 Micha=B3 Sawicz <michal@sawicz.net>:
> Dnia 2010-01-30, sob o godzinie 00:50 +0100, Goswin von Brederlow pis=
ze:
>> Does it matter? If one disk fails you know the next disk failure has=
 a
>> 33+% chance of data loss and knowing which disk will be critical
>> doesn't
>> change that.
>
> For me it was important when I needed to have the array running (root
> fs) with only 2 disks out of 4 (not enough controllers). It would be
> nice to be able to tell which are mirrors, which are striped.
>
> --
> Cheers
> Micha=B3 (Saviq) Sawicz
>

As was noted in another reply recently; write down drive serial
numbers.  Drive serial numbers can be obtained online via tools like
smartctl or hdparm (read their manuals, they're useful tools).

In your case you have a 50% chance of finding a working combination
the first time, and swapping only one cable from a disk that is
connected to one that's not would resolve the issue.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
