From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Suspected corruption on ACID databases due to no barrier support in ext3 on software raid-5 and hard resets
Date: Sat, 28 Jun 2008 07:40:40 -0500
Message-ID: <cccedfc60806280540j4ff2635cu494eaeb685459e6@mail.gmail.com>
References: <c384c5ea0806280153j426585f1q212c44f983a641e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c384c5ea0806280153j426585f1q212c44f983a641e1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, sandeen@sandeen.net
List-Id: linux-raid.ids

Because you are dealing with a database, data=ordered is not the right
mode to be using if you want the least chance of corruption.  Use
data=journal.

The problem as I understand it is that many databases use a small
number of very large files. When you are updating data in the
database, the data is not being written to new files but existing
files are being modified. If it were new files, then data=ordered
would be fine but since it is existing files being modified (in-place)
data=journal is more appropriate.

Of course, I might be wrong and would appreciate (polite) correction
but this is what I've been led to believe.


Now, due to the hardware reset, write caching on drives is a problem.
That you may have to disable - I've not found substantial performance
differences on when write caching is enabled anyway, but surely that
depends on a great many factors.


On Sat, Jun 28, 2008 at 3:53 AM, Leon Woestenberg
<leon.woestenberg@gmail.com> wrote:
> Hello all,
>
> we are quite sure we are hitting data corruption on a few % of cases
> on ACID* databases due to write caching enabled on drives in a
> software RAID-5 configuration with ext3 in default data=ordered mode.
>
> The machines are hard reset by a hardware watchdog when some esoteric
> PCI device misbehaves.
>
> We understand Linux software raid 5 does not pass-down barriers, is
> that correct, and is this being implemented?
>
> Also, our near-term direction of solution would be
> 0) disable write caches altogether, probably not feasible due to the
> performance regression involved.
> 1) solve the misbehave (cause of reset).
> 2) use a shorter timed software watchdog to trigger the drives into
> disabling their write caches, so that an imminent reboot has its
> commits ordered.

-- 
Jon
