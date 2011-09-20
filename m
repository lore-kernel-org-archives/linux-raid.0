From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Tue, 20 Sep 2011 00:33:05 -0400
Message-ID: <4E781781.8060106@turmel.org>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com> <CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com> <CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com> <20110918011749.98312581F7A@mail.futurelabusa.com> <CAB=7dh=PymkpqRLTWiNzD-+n=XwEWnPN8nQwXg1=UmiJmZ1b1w@mail.gmail.com> <20110918025839.85C86581F7C@mail.futurelabusa.com> <CAB=7dhmBDRFYnmoUJjEB2SfyQe8sB+WjC7AkK080iSRwA4RTzg@mail.gmail.com> <CAB=7dh=9UcEWJjLbOvPLu1Ubij0X4i6+SQ-6L9VE5gHLvcJVcw@mail.gmail.com> <CAB=7dh=xshrAfZzSaekPL0kJe0M2mKbOaupaFyeWVC6SnkT6=g@mail.gmail.com> <4E75F0DC.3010206@turmel.org> <CAB=7dh=9cx2sVAAZMhU_fFcDkzUFJS+cR6YLsT-Jjfg=oeZaRQ@mail.gmail.com> <4E7619CF.6060707@turmel.org> <20110920010054.8DFFE581F7A@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110920010054.8DFFE581F7A@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[added the list CC: back.  Please use reply-to-all on kernel.org lists.]

On 09/19/2011 09:00 PM, Jim Schatzman wrote:
> Thanks to all. Some notes
> 
> 1) I have never gotten "mdadm --assemble --force" to work as desired.
> Having tried this on the 6-8 occasions when I have temporarily
> disconnected some drives, all that I have seen is that the
> temporarily-disconnect drives/partitions get added as spares and
> that's not helpful, as far as I can see. I'll have to try it the next
> time and see if it works.

Seems to be dependent on dirty status of the array (write in progress).  Also, you should ensure the array is stopped before assembling after reconnecting.

> 2) Thanks for reminding me about the --assume-clean with "mdadm
> --create" option. Very important.  My bad for forgetting it.
> 
> 3) This is the first time I have heard that it is possible to get
> mdadm/md to ignore the event counts in the metadata via environmental
> variable. Can someone please provide the details?

I was mistaken...  The variable I was thinking of only applies to interrupted --grow operations: "MDADM_GROW_ALLOW_OLD".

> I freely acknowledge that forcing mdadm to do something abnormal
> risks losing data. My situation, like Mike's, has always (knock on
> wood) been when the array was up but idle. Two slightly different
> cases are (1) drives are disconnected when the system is up; (2)
> drives are disconnected when the system is powered down and then
> rebooted. Both situations have always occurred when enough drives are
> offlined that the array cannot function and gets stopped
> automatically. Both situations have always resulted in
> drives/partitions being marked as "spare" if the subsequent assembly
> is done without "--no-degraded".

Neil has already responded that this needs looking at.  The key will be the recognition of multiple simultaneous failures as not really a drive problem, triggering some form of alternate recovery.

> Following Mike's procedure of removing the arrays from
> /etc/mdadm.conf and always assembling with "--no-degraded", the
> problem is eliminated in the case that drives are unplugged during
> power-off. However, if the drives are unplugged while the system is
> up, then I still have to jump through hoops (i.e., mdadm --create
> --assume-clean) to get the arrays back up. I haven't tried "mdadm
> --assemble --force" for several versions of md/mdadm, so maybe things
> have changed?

--assemble --force will always be at least as safe as --create --assume-clean.  Since it honors the recorded role numbers, it reduces the chance of a typo letting a create happen with devices in the wrong order.  Device naming on boot can vary, especially with recent kernels that are capable of simultaneous probing.  Using the original metadata really helps in this case.  It also helps when the mdadm version has changed substantially since the array was created.

> For me, the fundamental problem has been the very insecure nature of
> eSata connectors. Poor design, in my opinion. The same kind of thing
> could occur, though, with an external enclosure if the power to the
> enclosure is lost.

Indeed.  I haven't experienced the issue, though, as my arrays are all internal.  (so far...)

Phil.
