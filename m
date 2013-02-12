From: Arun Khan <knura9@gmail.com>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Tue, 12 Feb 2013 17:00:19 +0530
Message-ID: <CAHhM8gDh4-hv4USoHOB_R7owNXBPpu=Vyq97osKnYL-RXpZzLw@mail.gmail.com>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
	<5119FE06.5070300@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5119FE06.5070300@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 12, 2013 at 2:02 PM, Adam Goryachev  wrote:
>
> Within the last month or thereabouts, I saw a patch go past the list
> which indicated that this might happen. Perhaps you need either a newer,
> or older version of md (linux kernel) or mdadm.
>
> The issue was failing to start an array which had enough members to
> start while a member was marked failed or something like that....

Thanks.  I will try a Live distro with a newer  mdadm + kernel.


> You didn't mention the kernel version (or I've missed it) but that is my
> suggestion, certainly before you try anything destructive....

It was mentioned right at the beginning of my OP - Stock Debian Squeeze 2.6.32-5

>
> Or someone else may have a more sensible solution for you (hopefully).

I hope so.   I can start afresh from the backups of the critical files
but I stand to loose at least a day's worth of work :(

Thanks,
--  Arun Khan
