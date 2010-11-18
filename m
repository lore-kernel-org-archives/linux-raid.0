From: Tim Small <tim@buttersideup.com>
Subject: Re: faulty array member
Date: Thu, 18 Nov 2010 19:29:18 +0000
Message-ID: <4CE57E8E.2040902@buttersideup.com>
References: <4CE55D9E.4070406@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE55D9E.4070406@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/11/10 17:08, Roberto Nunnari wrote:
>
> md0 : active raid1 sdb1[1] sda2[2](F)
>       40957568 blocks [2/1] [_U]
>
> The question is:
> Is there a way and is it safe to put back /dev/sda2 into
> /dev/md0 so that I'm sure I can backup even the blocks

If there have been writes to md0 since sda2 was failed, then no.  Your
best best is probably to find out which sectors are bad in sdb1, and
then copy those individual blocks (only) over from sda2 (e.g. using
dd).  Once sdb1 has no pending sectors left, you should then be able to
re-add sda2 back into md0.

I don't know what the bad-block remapping is like on the CentOS4 kernel,
so you may want to use a more recent boot CD etc. to carry out the
rebuild, if it doesn't work using the native kernel.  Maybe.

Tim.


