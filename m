From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: RAID5 on different sized disks on low-end machine
Date: Fri, 14 Jan 2005 10:07:03 +0000
Message-ID: <cs85j1$uuf$2@sea.gmane.org>
References: <eaa6dfe050111104772af6240@mail.gmail.com>	 <eaa6dfe050111111465c7e5b1@mail.gmail.com>	 <cs1qqb$98l$1@sea.gmane.org> <eaa6dfe05011206366059173a@mail.gmail.com> <41E78C6C.2080701@chemie.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E78C6C.2080701@chemie.uni-erlangen.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Norman Schmidt wrote:
> Hi Derek!
> 
> What worries me a little bit about your setup is that you seem to want 
> to put the drives as master and slave on each of the two busses of the 
> ata controller.

Ah, I missed that. Yes, that's definitely not a good idea. Get yourself 
another controller card and stick to one disk per ATA channel.

R.
-- 
http://robinbowes.com

