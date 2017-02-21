From: Roger Roglans <rroglans@gmail.com>
Subject: Re: Trouble reassembling RAID10
Date: Tue, 21 Feb 2017 12:38:14 -0600
Message-ID: <CAPXQETk=0j+2P-dex4GpPTmEyBpkUcqHt4WSKJnuNGZvuwY97g@mail.gmail.com>
References: <CAPXQET=6v3NTeujqtq69KfzAv1gpeG8vGQPfwMxxOaECvFR4sg@mail.gmail.com>
 <f01c3494-1191-fdf5-c32e-c60abcdc989e@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f01c3494-1191-fdf5-c32e-c60abcdc989e@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

seems very useful to know in the future. I ended up just assuming
clean and using "--create". Since I was able to discern the exact
configurations, I was able to mount it and am currently transferring
data. I know it was not the ideal solution but I believe that it
worked out with only minimal corruption. I might have problems with
another array soon. If so, I will certainly contact this mailing list
again.

thanks for your help,

Roger


On Feb 21, 2017 9:16 AM, "Phil Turmel" <philip@turmel.org> wrote:

Hi Roger,

On 02/20/2017 04:42 PM, Roger Roglans wrote:
> Hey new to the mailing list and fairly new to RAIDs in general. I
> ran into an issue and was hoping someone could help.

We probably can.

> Our server that runs a 14 drive RAID10 through a rocketraid 2470
> controller refused to assemble. Our goal is not necessarily to
> recover a working RAID, but to get as much data back as possible.

Amounts to the same thing.

> Maybe as a consequence of the assembly failure, upon shutting down
> the server, it would get stuck in boot loops. So I'm currently
> running Ubuntu 16.04.1 from a USB. I've determined that 2 of 14
> disks are faulty and have determined which ones they are.

Three.  Two have been faulty for a very long time.  No-one noticed
the degraded status.

> Here is the output of a mdadm --examine call.

Please re-do this, combined with smartctl, and without grep.  This
will tell us everything about your array.  Like so:

for x in /dev/sd[a-p] do mdadm -E ${x}1 ; smartctl -iA -l scterc $x ; done

Paste the output *inline* in your plain-text reply with line
wrapping disabled.  If your draft email is larger than 100k, split
into multiple emails.

You are likely to need an alternate bootable USB stick -- your
report sounds like one of the versions of mdadm that had a bug
in forced assembly.  I usually use the latest one from
https://www.system-rescue-cd.org/

Please also read the recent thread and its references starting
here: https://marc.info/?l=linux-raid&m=148755536616025&w=2

Phil
