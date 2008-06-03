From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Tue, 03 Jun 2008 23:46:43 +0200
Message-ID: <4845BBC3.5080406@rabbit.us>
References: <4844E994.8020808@jellybean.co.uk> <4845B573.7090801@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4845B573.7090801@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jules Bean <jules@jellybean.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jules Bean wrote:

> Is there any good way to 'search for' somethign which looks like a RAID 
> superblock?
> 

The superblock itself starts with the "magic number" 0xA92B4EFC

HTH

Peter
