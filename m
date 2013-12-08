From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 8 Dec 2013 11:57:47 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se>
References: <52A44778.8040502@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A44778.8040502@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 8 Dec 2013, David C. Rankin wrote:

> Guys,
>
>  I have an older box that is a fax server where the Event Count for /dev/md1 is
> off by 1, but the array cannot be reassembled with --assemble --force /dev/dm1
> /dev/sda5 /dev/sdb5.

What are the messages displayed in "dmesg" when you try to use this 
command?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
