From: "Jeff Breidenbach" <breidenbach@gmail.com>
Subject: Re: Random Seek on Array as slow as on single disk
Date: Sun, 16 Jul 2006 11:25:32 -0700
Message-ID: <e03b90ae0607161125u71e1a339re29a5d9659ac365b@mail.gmail.com>
References: <20060716153736.E36C5200967@smtp.funpic.de>
	 <20060716163931.D95FE200970@smtp.funpic.de>
	 <20060716164930.5DBFF200973@smtp.funpic.de>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060716164930.5DBFF200973@smtp.funpic.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "A. Liemen" <maillist@liemen.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The linux-raid mailing list is predominantly covers linux software
RAID, so you may get a lot of software raid centric comments.
Like this one.

Have you tried setting the Areca to JBOD then using mdadm to
set up a software? That might help isolate where the problem is.
Just pick any configuration and try it. As a sanity comparison, I'm
seeing good seek performance with a 5 disk RAID1 (e.g. 5X
redundancy) with resiserfs on Linux software RAID. That's on a
production system, so I can't run bonnie++, but I''m definitely seeing
significantly better seek performance than you are reporting.

-Jeff
