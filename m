From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Sun, 18 Sep 2011 09:23:40 -0400
Message-ID: <4E75F0DC.3010206@turmel.org>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com> <CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com> <CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com> <20110918011749.98312581F7A@mail.futurelabusa.com> <CAB=7dh=PymkpqRLTWiNzD-+n=XwEWnPN8nQwXg1=UmiJmZ1b1w@mail.gmail.com> <20110918025839.85C86581F7C@mail.futurelabusa.com> <CAB=7dhmBDRFYnmoUJjEB2SfyQe8sB+WjC7AkK080iSRwA4RTzg@mail.gmail.com> <CAB=7dh=9UcEWJjLbOvPLu1Ubij0X4i6+SQ-6L9VE5gHLvcJVcw@mail.gmail.com> <CAB=7dh=xshrAfZzSaekPL0kJe0M2mKbOaupaFyeWVC6SnkT6=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB=7dh=xshrAfZzSaekPL0kJe0M2mKbOaupaFyeWVC6SnkT6=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mike,

On 09/17/2011 11:59 PM, Mike Hartman wrote:
> On Sat, Sep 17, 2011 at 11:07 PM, Mike Hartman
> <mike@hartmanipulation.com> wrote:
>> Yikes. That's a pretty terrifying prospect.

*Don't do it!*

"mdadm --create" in these situations is an absolute last resort.

First, try --assemble --force.

If needed, check the archives for the environment variable setting that'll temporarily allow mdadm to ignore the event counts for more --assemble and --assemble --force tries.

(I can't remember the variable name off the top of my head.)

Only if all of the above fails do you fall back to "--create", and every single "--create" attempt *must* include "--assume-clean", or your data is in grave danger.

Based on the output of the one full mdadm -E report, your array was created with a recent version mdadm, so you shouldn't have trouble with data offsets.  Please post the full "mdadm -E" report for each drive if you want help putting together a --create command.

I'd also like to see the output of lsdrv[1], so there's a good record of drive serial numbers vs. device names.

HTH,

Phil

[1] http://github.com/pturmel/lsdrv


