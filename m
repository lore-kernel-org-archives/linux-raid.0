From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: I/O Blocking
Date: Thu, 22 Jul 2004 09:51:56 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0407220943170.7498@umi.cfht.hawaii.edu>
References: <40FFEB55.2000905@ocis.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40FFEB55.2000905@ocis.net>
To: "Jason C. Leach" <jleach@ocis.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Jason,

There is a technical answer to your question which I cannot properly
relate to you. The practical answer is yes, an SMP system will
generally perform better under heavy interrupt conditions and would
probably help with the situation you are having.

That said, the problem you are having is not lack of CPU
performance. I don't know what it is but you need to look into it
before throwing another mega-cpu at it. You might have too many I/O
devices sharing the same IRQ, it could be something weird like a
haywire parallel port device. Take a careful look at how your
equipment is set up and do some experiments turning things off and on,
etc. You can probably get to the bottom of it without upgrading
anything.

-Kanoa

On Thu, 22 Jul 2004, Jason C. Leach wrote:

> Hi,
>
> Both the RAID (Promise SuperTrak 6000) or the USB subsystems really
> drive the system load up. I'm using a AMD 3200+ system that is only a
> few months old with the 2.4.25 kernel.  When the I/O systems are
> blocking the system is very unresponsive. Some times samba will timeout,
> or I'll wait several seconds for commands like df, top, w and so on.
>
> I am wondering if I were to use a dual CPU system, would this solve my
> I/O blocking problem?  Would one CPU tend to the I/O subsystem and the
> second would deal with other system requests I (samba, DB, LDAP, ...)?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
