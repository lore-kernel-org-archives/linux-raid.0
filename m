From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:10:28 +0200
Message-ID: <38899f11-c6d2-cab7-eb25-093cfa802b40@thelounge.net>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 29.06.2017 um 11:52 schrieb Gandalf Corvotempesta:
> Linux kernels detect something bad only by accessing to the failed
> sector. If that sector is not used,
> kernel knows nothing. HW RAID like LSI are able to read the whole
> disks, block by block, even the unused part,
> detecting failures before something is trying to write to that sector
> 
> If you have a bad sector on an unused part of the array, when you have
> to rebuild due to another disk failure, you'll
> hit a URE and the whole array is failed

there is nothing like "unused part of the array" since the 
linux-raid-layer knows nothing about the filesystem on top and hence a 
raid-check (scrub) reads every block as said hardware controller
