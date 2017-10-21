From: Anthony Youngman <antmbox@youngman.org.uk>
Subject: Re: ***UNCHECKED*** Re: 3-disk RAID5 won't assemble
Date: Sat, 21 Oct 2017 10:36:05 +0100
Message-ID: <68dd7a9a-228b-ecc9-dbf9-3c3cb0f251bd@youngman.org.uk>
References: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
 <59EA5DDB.2020400@youngman.org.uk>
 <9323bcbf-17ba-00d8-159a-38563562d472@ieee.org>
 <8a8ffdc8-4bad-4d99-2fc4-5457556f40f7@youngman.org.uk>
 <e1ef35a5-220f-bef5-6bc9-0b2108ebe630@turmel.org>
 <7db1f2fc-3018-5a0a-89a1-74d6762df463@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db1f2fc-3018-5a0a-89a1-74d6762df463@ieee.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alex Elder <elder@ieee.or>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/10/17 04:40, Alex Elder wrote:
> You guys are really great.  I am back running again.  Thank you
> for taking the time to help me out.  It saved me a LOT of time
> trying to chase down what I needed to do, and most importantly
> you gave me the confidence to proceed with only a modest level
> of anxiety...  The hardest thing was creating a new systemd
> service to run the script at boot time (also a first for me).
> 
>> Buy NAS drives in the future, though.

> Hey, they were never going to fail!  RAID solves all problems.

Even the alleged experts (definitely "alleged" in my case :-) don't 
always do the right thing :-) I'm currently running two Seagate 
Barracudas - *without* the timeout script! - in a mirror configuration. 
But over the next few days I'll be building a new pc and I've got two 
raid-capable drives. It'll be a big learning experience because I use 
gentoo ... learning systemd, learning QEMU, learning KVM, learning...
> 
> But yeah, I'll look more closely at that next time.
> 
Cheers,
Wol
