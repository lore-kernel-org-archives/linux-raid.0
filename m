From: Phil Turmel <philip@turmel.org>
Subject: Re: All drive in Raid 5 are in 'spare' mode
Date: Mon, 16 Feb 2015 15:03:28 -0500
Message-ID: <54E24D10.7030901@turmel.org>
References: <CAL7hTOctZ4tAoPSbO3iFEohRyXuvcY4=6yQj8U-FpoAhV6sT0w@mail.gmail.com> <54DC04C1.4010107@turmel.org> <CAL7hTOfhWiCmKVVCtpmHuB-OJkZjQsuaKZMN8oFKAArh=NuSHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL7hTOfhWiCmKVVCtpmHuB-OJkZjQsuaKZMN8oFKAArh=NuSHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dush <tomdush@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dush,

{Convention on kernel.org is to trim replies and either bottom post or
interleave.  Please don't top-post.}

On 02/16/2015 02:38 PM, Dush wrote:
> Hi Phil,
> 
> Thanks for your answer!
> 
> Unfortunately, I think I just loosed a disk (sde)... I don't see it
> anymore in /dev , I have in dmesg:
> d
> [   12.280021] ata7: softreset failed (1st FIS failed)
> [   22.280019] ata7: softreset failed (1st FIS failed)
> [   57.280015] ata7: softreset failed (1st FIS failed)
> [   57.280222] ata7: limiting SATA link speed to 1.5 Gbps
> [   62.453345] ata7: softreset failed (device not ready)
> [   62.453558] ata7: reset failed, giving up

Where are the forensics I asked for as "Step one"?  Did you read about
and fix any timeout mismatch issue?

[trim /]

> You was right, I already tried to start the raid and it succeed to do
> it with 3 drives: b, c and e. Then I added the d because I thought it
> was de-synchronized.
> Now I think my drive e was out of this raid for a while and I started
> to had trouble because d started to had some issues.
> 
> Is it possible to force raid to start with b, c and d (forcing d to be
> 'normal')? Time for me to copy everything to another drive...

No.  sdd3 was converted to a spare.

Also, your device names have changed.  You *must* keep track of which
one is which "RaidDevice".  Specifically, what was "sde" now appears to
be "sdd".  Did you reboot?  You know that device names are not
guaranteed to be consistent from one boot to the next, I hope.  Show an
excerpt from "ls -l /dev/disk/by-id/" with your next report so we know
which drive serial number has which name.

Phil
