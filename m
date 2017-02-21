From: Phil Turmel <philip@turmel.org>
Subject: Re: Trouble reassembling RAID10
Date: Tue, 21 Feb 2017 10:16:38 -0500
Message-ID: <f01c3494-1191-fdf5-c32e-c60abcdc989e@turmel.org>
References: <CAPXQET=6v3NTeujqtq69KfzAv1gpeG8vGQPfwMxxOaECvFR4sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPXQET=6v3NTeujqtq69KfzAv1gpeG8vGQPfwMxxOaECvFR4sg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Roglans <rroglans@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
