From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: [PATCH] relax checks to support 3disk raid6 arrays
Date: Fri, 20 Mar 2009 10:20:20 +0100
Message-ID: <49C35FD4.1010102@rabbit.us>
References: <20090318125324.GL17185@skl-net.de> <18882.57018.465098.201167@notabene.brown> <20090320091436.GM17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090320091436.GM17185@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> On 11:09, Neil Brown wrote:
> 
>> Have you tried a 3-disk raid6 yet?  Any conclusions?
> 
> Yes, I played around a bit and used the two attached patches that
> relax some checks in the kernel and in mdadm. It appears to work fine,
> but I did only minimal testing with small loop devices, so I would
> not recommend it for production use yet :)
> 
> Regards
> Andre
> 

In the last lines of the patch:
Name ": at least 4 raid-devices needed for level 6\n");

Cheers
