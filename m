From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: "md_raid5: page allocation failure" when resyncing on 3.2
Date: Tue, 10 Jan 2012 02:03:57 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201100200440.30451@uplift.swm.pp.se>
References: <4F0B2303.4080109@gmail.com> <20120110003107.432e4542@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120110003107.432e4542@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Konstantinos Skarlatos <k.skarlatos@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 10 Jan 2012, Roman Mamedov wrote:

> In your backtrace I see the system was also handling a network transfer with the r8169 driver; do you use jumbo frames there (MTU over 1500)?

I've had page allocation failures for years. I've reported them, I don't 
receive any comments on them from the mm devs.

My solution:

vm.min_free_kbytes=524288

and I also had to have less aggressive tcp window setup, because my 
problems occured when I had a lot of tcp session setups and activity on 
them.

My interpretation is that the memory handling in linux when it comes to 
allocation failures isn't very robust, if some part is too aggressive in 
wanting memory, things die.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
