From: dean gaudet <dean@arctic.org>
Subject: Re: Ubuntu - RAID Array not "assembling" on boot.
Date: Tue, 21 Nov 2006 12:25:32 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611211223430.7622@twinlark.arctic.org>
References: <1164139592.12278.276853539@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1164139592.12278.276853539@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Reeves <john.reeves@mailc.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 21 Nov 2006, John Reeves wrote:

> Hey,
> 
> Having a great deal of difficulty getting my 3 disk RAID 5 array to
> reappear on restart, Ubuntu 6.10.  Here's the contents of my
> /etc/mdadm/mdadm.conf file:
> 
> ARRAY /dev/md0 level=raid5 num-devices=3
> UUID=6a9a102a:101addd2:f95758f6:11ac6d3c 

just to be sure... that's one line in your config file and your mailer 
wrapped it?

also -- do you have a "DEVICE partitions" line in the config file?

-dean
