From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Sun, 18 Sep 2011 12:18:23 -0400
Message-ID: <4E7619CF.6060707@turmel.org>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com> <CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com> <CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com> <20110918011749.98312581F7A@mail.futurelabusa.com> <CAB=7dh=PymkpqRLTWiNzD-+n=XwEWnPN8nQwXg1=UmiJmZ1b1w@mail.gmail.com> <20110918025839.85C86581F7C@mail.futurelabusa.com> <CAB=7dhmBDRFYnmoUJjEB2SfyQe8sB+WjC7AkK080iSRwA4RTzg@mail.gmail.com> <CAB=7dh=9UcEWJjLbOvPLu1Ubij0X4i6+SQ-6L9VE5gHLvcJVcw@mail.gmail.com> <CAB=7dh=xshrAfZzSaekPL0kJe0M2mKbOaupaFyeWVC6SnkT6=g@mail.gmail.com> <4E75F0DC.3010206@turmel.org> <CAB=7dh=9cx2sVAAZMhU_fFcDkzUFJS+cR6YLsT-Jjfg=oeZaRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB=7dh=9cx2sVAAZMhU_fFcDkzUFJS+cR6YLsT-Jjfg=oeZaRQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/18/2011 12:07 PM, Mike Hartman wrote:
> Thanks Phil. --assemble --force is all it took - glad I held off. That
> was my first instinct to try, but I was worried it would still leave
> the drives as spare AND somehow mess up the metadata enough that it
> wouldn't be recoverable, so I was afraid to touch it until someone
> could confirm the approach. Seems like a silly reason to have the
> array down for multiple days, but better safe than sorry with that
> much data.

Good to hear!  This list's archives have a number of cases where premature use of "--create" pushed a recoverable array over the edge, with resulting grief for the owner.  Not that it can't or shouldn't ever be done, but the pitfalls have sharp stakes.

> Thanks again to both you and Jim!

You're welcome.

Phil
