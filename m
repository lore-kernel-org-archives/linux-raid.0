From: Mark Bellon <mbellon@mvista.com>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Mon, 27 Oct 2003 14:14:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9D8AAA.7010308@mvista.com>
References: <3F9D82F0.4000307@mvista.com> <20031027210054.GR24286@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031027210054.GR24286@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
>How does it relate to udev?
>
The uSDE and udev are simlar in some respects. The uSDE allows for 
complete control of the policy handling a device - not just its naming. 
It can perform complex policies on behalf of its devices including 
multiple concurrent policies for each device. It is also very aggressive 
about handing the system start up issues when many devices must be dealt 
with.

>How does this integrate with DM, md, EVMS, LVM...?
>
As devices appear in sysfs the uSDE reacts to them via their hotplug 
events. The policy for each device handles any device issues including 
dealing with any device nodes.  It is possible to track and maintain 
multiported devices and automatically provide multipath devices nodes 
for instance.

mark




