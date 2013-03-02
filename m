From: Phil Turmel <philip@turmel.org>
Subject: Re: Expanding array with multiple devices
Date: Sat, 02 Mar 2013 12:11:16 -0500
Message-ID: <513232B4.7030404@turmel.org>
References: <1801783.8.1362233235807.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1801783.8.1362233235807.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/02/2013 09:07 AM, Roy Sigurd Karlsbakk wrote:
>> While expanding an existing raid is as simple as mdadm --add, followed
>> by an mdadm --grow, How would you go about this when expanding it with
>> multiple devices.
> 
> Given a RAID-5 on /dev/sd[bcde], I'd do
> 
> # mdadm --add /dev/md0 /dev/sd[fghi]
> # mdadm --grow --level=6 --raid-devices=8
> 
> No need to create a new RAID and then move the data.

You missed the bit where he states he needs to use mkfs to switch
filesystem features.

Phil

