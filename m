From: berk walker <berk.walker@verizon.net>
Subject: Re: I/O Blocking
Date: Thu, 22 Jul 2004 21:47:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41006E30.7050204@verizon.net>
References: <40FFEB55.2000905@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40FFEB55.2000905@ocis.net>
To: "Jason C. Leach" <jleach@ocis.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Jason C. Leach wrote:

> Hi,
>
> Both the RAID (Promise SuperTrak 6000) or the USB subsystems really 
> drive the system load up. I'm using a AMD 3200+ system that is only a 
> few months old with the 2.4.25 kernel.  When the I/O systems are 
> blocking the system is very unresponsive. Some times samba will 
> timeout, or I'll wait several seconds for commands like df, top, w and 
> so on.
>
> I am wondering if I were to use a dual CPU system, would this solve my 
> I/O blocking problem?  Would one CPU tend to the I/O subsystem and the 
> second would deal with other system requests I (samba, DB, LDAP, ...)?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
HMMM I seemed to have lost the 1st of the thread, 2 cents worth .. what 
ya pay for ...

I might be supect of the m/b IDE channels (personally had lots of 
failures) - SMART drives that are not configured as SMART (sorry, I 
always use Intel, AMD...?) enableing in bios and kernel or mod might 
give clues.  I, also, think that there must be an IRQ conflict, IRQ 
unanswered, or same ilk.

You could test by  swapping drives, swapping m/b's.  What sizes are your 
disks?  What RAM do you use,, I do have a plethora of hwde I could loan.

b-


