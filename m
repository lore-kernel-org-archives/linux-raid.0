From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: hadware raid [_U] issue.
Date: 24 Dec 2003 23:03:54 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bse24q$vhj$1@cesium.transmeta.com>
References: <20031224192810.1e79f5a3.ietf@2c9d1f3141b658e37c53395b25a04078.nosense.org> <1072261391.21554.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <1072261391.21554.125.camel@localhost.localdomain>
By author:    Vijay Kumar <vijay@calsoftinc.com>
In newsgroup: linux.dev.raid
>
> Hello, 
> 
> I have a redhat box with Hardware Raid. Below ar ethe outputs of various
> files/commands. Please let me know whether there is anything wrong.
> I think there might be some problem in md0, but I am not very sure. 
> Somone told me that since the box runs hardware the md-status does not
> matter. What does the "[UU]" mean in mdstat ? In md0, one U is missing. 
> What should I do next ?
> 

U = working drive
_ = broken drive

You need to replace the broken drive and use "mdadm -a" to replace it
into the array.

If you believe the hardware is actually OK you can test it out
(e.g. using badblocks) and then add it back into the array.

	-hpa
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
