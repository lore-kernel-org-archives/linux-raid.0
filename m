From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Odd (slow) RAID performance
Date: Fri, 8 Dec 2006 09:21:46 +0100
Message-ID: <20061208082146.GF8696@boogie.lpds.sztaki.hu>
References: <456F4872.2090900@tmr.com> <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk> <45710EDC.9050805@tmr.com> <e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com> <4578387D.4010209@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4578387D.4010209@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Roger Lucas <roger@planbit.co.uk>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Dec 07, 2006 at 10:51:25AM -0500, Bill Davidsen wrote:

> I also suspect that write are not being combined, since writing the 2GB 
> test runs at one-drive speed writing 1MB blocks, but floppy speed 
> writing 2k blocks. And no, I'm not running out of CPU to do the 
> overhead, it jumps from 2-4% to 30% of one CPU, but on an unloaded SMP 
> system it's not CPU bound.

You could use blktrace to see the actual requests that the md code sends
down to the device, including request merging actions. That may provide
more insight into what really happens.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
