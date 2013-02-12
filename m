From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Tue, 12 Feb 2013 23:05:53 +1100
Message-ID: <511A3021.4020300@websitemanagers.com.au>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com> <5119FE06.5070300@websitemanagers.com.au> <CAHhM8gDh4-hv4USoHOB_R7owNXBPpu=Vyq97osKnYL-RXpZzLw@mail.gmail.com> <CAHhM8gBiQNHU+WJ_FRTG9HdZx3CVsVyUse_UBQ4VQLJLie8PjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhM8gBiQNHU+WJ_FRTG9HdZx3CVsVyUse_UBQ4VQLJLie8PjQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Khan <knura9@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/13 22:34, Arun Khan wrote:
> On Tue, Feb 12, 2013 at 5:00 PM, Arun Khan <knura9@gmail.com> wrote:
>> On Tue, Feb 12, 2013 at 2:02 PM, Adam Goryachev  wrote:
>>> You didn't mention the kernel version (or I've missed it) but that is my
>>> suggestion, certainly before you try anything destructive....
>> It was mentioned right at the beginning of my OP - Stock Debian Squeeze 2.6.32-5
>>
> and I missed this one -
> The System Rescue CD has kernel 3.2.19 and mdadm - v3.1.4 - 31st August 2010.
>
> I am using System Rescue CD to recover /dev/md0.
Sorry, I missed those then....

Why don't you try using a debian stable rescue cd? It should have a
similar version of mdadm and kernel to what you are using on the machine.
I think the issue I mentioned was only in the kernel for a limited
period of time, and I'm sure 2.6.x was not affected... I'd suggest you
check the list archives if you need to know exactly which versions are
affected.

Hope this helps...

Regards,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

