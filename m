From: Mark Bellon <mbellon@mvista.com>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Mon, 27 Oct 2003 16:19:44 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9DA810.1010409@mvista.com>
References: <3F9D82F0.4000307@mvista.com>	 <20031027210054.GR24286@marowsky-bree.de> <1067296529.4612.234.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1067296529.4612.234.camel@persist.az.mvista.com>
To: sdake@mvista.com
Cc: Lars Marowsky-Bree <lmb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
>Device mapper and the md layer generates hotplug events which are
>managed by the framework.  There is no specific policy for these
>subsystems, but they could be implemented...  With today's code, they
>fall through and are exported as disks.  One good policy method that
>could be implemented is to scan the lvm lv list and map the major/minor
>to the real lv, and use that to name the device (instead of lvm naming
>the device).  This hasn't been done but if your up for it, Mark can
>probably help you.
>
Cool idea! I would be most open to having someone contribute this or, if 
they could help work out a set of simple requirements I could womp up an 
initial policy for this in a short time.

mark

