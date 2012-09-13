From: Daniel Frey <djqfrey@gmail.com>
Subject: Re: Stop IMSM verify?
Date: Wed, 12 Sep 2012 18:34:41 -0700
Message-ID: <CA+ZgY1FMZm-g3-ODPLaRnN14+da+8QBcWhSX-p08kx70pGz97g@mail.gmail.com>
References: <CA+ZgY1E2T6C+Db1eb8_GFnXm7nzo4ecgGbMiPPf18C9-p5X5WQ@mail.gmail.com>
	<20120913112246.77b3041e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120913112246.77b3041e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 12, 2012 at 6:22 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 12 Sep 2012 18:00:21 -0700 Daniel Frey <djqfrey@gmail.com> wrote:
>
>> Is there any way to stop the verify of an IMSM raid through mdadm?
>
> No.

Darn.

>> I found https://raid.wiki.kernel.org/index.php/RAID_Administration,
>> but the imsm raid does not seem to have sync_action anywhere in the
>> /sys/block tree.
>
> It certainly should be there.
>   find /sys/block -name sync_action
> ??

I'm using mdadm exclusively for my imsm raid, and:

 ~ # find /sys/block -name sync_action
 ~ #

I take it the imsm raid should have that? I used that exact same
command (and found nothing) before I posted to the list.

>> I've been having issues with suspend which I'm trying to troubleshoot,
>> and I know I can stop it if I boot into Windows. Just wondering if
>> that functionality is in mdadm.
>
> I suspect your problem is that mdmon is being killed at an awkward time
> during shutdown.
> What distro?  Is 'systemd' being used?

The distro is gentoo (no systemd) - suspend works (as in it goes into
suspend properly) but 8 out of 10 times it fails to wake out of
suspend by either the keyboard or power button. The only way to "wake"
it is to yank the power plug from the PSU for a few seconds and plug
it in. As you can imagine, the imsm raid isn't too happy about that...
it boots in Verify mode. I've found I can stop the raid verify in
Windows, so I thought perhaps mdadm could do the same.

I haven't quite figured the suspend issue out yet. It could be
hardware (thinking maybe PSU?) but I'm trying to troubleshoot this
issue methodologically. It started after an upgrade to a kernel >
3.0.2, I have yet to try a 2.6.x to see if it goes back to normal.
When it does resume properly, everything is fine (mdadm doesn't
resync.) It's related to the sleep of death (or eternal sleep?) issue.

Dan
