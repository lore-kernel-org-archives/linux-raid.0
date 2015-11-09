From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Mon, 9 Nov 2015 08:50:41 -0500
Message-ID: <5640A4B1.4050207@turmel.org>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
 <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Mathias Mueller <raidfail@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/09/2015 06:56 AM, Mikael Abrahamsson wrote:
> On Mon, 9 Nov 2015, Mathias Mueller wrote:
> 
>> Please help me, I know I'm stupid and don't deserve it. I really hope,
>> there is a chance for reovering the array.
> 
> It's possible. There are numerous threads in the mailing list archives
> with people who have been in the same situation as you are in now.
> Without having a backup of the original superblocks, you're going to
> have to guess offsets. It might make sense to investigate what the
> defaults were for the mdadm you originally created the array with.

Chunks size defaults have varied, too.

I would search the known first drive for an ext4 filesystem signature
and work backwards from there.  Show the output of this search:

dd if=/dev/sdd1 bs=1M count=1M |hexdump -C |grep '  53 ef ' |head -n 1000

Phil

