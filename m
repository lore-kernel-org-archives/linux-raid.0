From: Mike Hardy <mhardy@h3c.com>
Subject: Re: RAID5 drive failure, please verify my commands
Date: Sun, 16 Jan 2005 16:39:08 -0800
Message-ID: <41EB092C.7080305@h3c.com>
References: <7C8198B3-67EA-11D9-9A87-00039363AEBE@bitart.com> <41EADBAE.6070400@h3c.com> <F856C764-680B-11D9-9A87-00039363AEBE@bitart.com> <41EAF526.2000707@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EAF526.2000707@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Mike Hardy wrote:

> At that point, do a dd if=/dev/zero of=/dev/sda bs=4096 skip=(sector 
> address divided by 8) count=1

I messed this command up, if you didn't catch it. You use skip to skip 
on the input, you use that for reading in. When you're writing the zeros 
out, you use "seek=..." to seek into the output to the right spot.

Its all in the bad block howto though - that's the definitive guide

-Mike
