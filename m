From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Help: Re-assemble raid-5 with inconsistent events.
Date: Sat, 22 Mar 2008 13:30:28 -0400
Message-ID: <47E54234.3040407@tmr.com>
References: <1206153639.16304.30.camel@loss.redstem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1206153639.16304.30.camel@loss.redstem.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arthur Britto <ahbritto@iat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Arthur Britto wrote:
> Hi,
>
> I have a RAID 5 with 6 components.  The 4-port SATA controller died and
> left the RAID in an inconsistent state.  2 of the 6 components have a
> more recent event stamp than the others. 
>
> What command should I issue to re-assemble the RAID?
>
> In particular, I don't want to force the RAID to be assembled with the
> components in the wrong order.  Especially as the order given
> by /dev/sd?? does not match the component order.
>
> Thanks in advance,
>   
Might I suggest that you
- back up your mdadm.conf file
- replace the list of components in the ARRAY description with the UUID 
of the array
- change configure to use PARTITIONS and try them all
- try the assemble with mdadm figuring out what goes where

Your chances of getting something drastically wrong are lower. You may 
have to use --force to get the assembly, and should run fsck *with the 
-n option* first to see what you have.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


