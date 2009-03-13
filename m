From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 13:29:53 -0500
Message-ID: <7d86ddb90903131129k2fa7d98ah636320c9a3b78259@mail.gmail.com>
References: <407601c9a405$d3d76b6a$e90df40a@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <407601c9a405$d3d76b6a$e90df40a@exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Alain Williams <addw@phcomp.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The card has the latest non RAID firmware loaded on it. The LSI 1068
model comes default from Supermicro with the non RAID firmware. It
only has an ARM processor capable of RAID 0 or 1 if you load the RAID
firmware.

The other system with the onboard ICH controller exhibits the same
symptoms so I think my card is configured correctly. The interesting
part of this is I can kick off a resync on all three RAID volumes and
the system load and io wait is low. The rebuild rate is 85M/s for the
RAID 5 volume and 65M/s for the RAID 1 volumes, which is the max each
individual drive can do.

Ryan

On Fri, Mar 13, 2009 at 1:02 PM, David Lethe <david@santools.com> wrote=
:
> -----Original Message-----
>
> From: =A0"Ryan Wagoner" <rswagoner@gmail.com>
> Subj: =A0Re: High IO Wait with RAID 1
> Date: =A0Fri Mar 13, 2009 12:45 pm
> Size: =A02K
> To: =A0"Bill Davidsen" <davidsen@tmr.com>
> cc: =A0"Alain Williams" <addw@phcomp.co.uk>; "linux-raid@vger.kernel.=
org" <linux-raid@vger.kernel.org>
>
> Yeah I understand the basics to RAID and the effect cache has on
> performance. It just seems that RAID 1 should offer better write
> performance than a 3 drive RAID 5 array. However I haven't run the
> numbers so I could be wrong.
>
> It could be just that I expect too much from RAID 1. I'm debating
> about reloading the box with RAID 10 across 160GB of the 4 drives
> (160GB and 320GB) and a mirror on the remaining space. In theory this
> should gain me write performance.
>
> Thanks,
> Ryan
>
> On Fri, Mar 13, 2009 at 11:22 AM, Bill Davidsen <davidsen@tmr.com> wr=
ote:
>> Ryan Wagoner wrote:
>>>
>>> I'm glad I'm not the only one experiencing the issue. Luckily the
>>> issues on both my systems aren't as bad. I don't have any errors
>>> showing in /var/log/messages on either system. I've been trying to
>>> track down this issue for about a year now. I just recently my the
>>> connection with RAID 1 and mdadm when copying data on the second
>>> system.
>>>
>>> Unfortunately it looks like the fix is to avoid software RAID 1. I
>>> prefer software RAID over hardware RAID on my home systems for the
>>> flexibility it offers, especially since I can easily move the disks
>>> between systems in the case of hardware failure.
>>>
>>> If I can find time to migrate the VMs, which run my web sites and
>>> email to another machine, I'll reinstall the one system utilizing R=
AID
>>> 1 on the LSI controller. It doesn't support RAID 5 so I'm hoping I =
can
>>> just pass the remaining disks through.
>>>
>
> FYi - you can potentially get =A0a big performance penalty when runni=
ng a LSI raid card in jbod mode. =A0The impact varies depending on a lo=
t of things .. =A0 Try loading the jbod fimware on the card if it suppo=
rts this and re run benchmarks
>
> david
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
