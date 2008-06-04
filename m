From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 04 Jun 2008 08:36:06 +0200
Message-ID: <484637D6.1020501@rabbit.us>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484636B9.20700@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jules Bean <jules@jellybean.co.uk>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jules Bean wrote:
> The lesson here is always reboot after changing partition sizes, unless 
> you have a tool which reliably flushes the kernel partition table cache 
> (partprobe?)
> 

hdparm -z ?
