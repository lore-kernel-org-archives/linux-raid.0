From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Suspected corruption on ACID databases due to no barrier support in ext3 on software raid-5 and hard resets
Date: Sun, 29 Jun 2008 21:44:26 +0200
Message-ID: <c384c5ea0806291244n4721d97et37f16286af80f368@mail.gmail.com>
References: <c384c5ea0806280153j426585f1q212c44f983a641e1@mail.gmail.com>
	 <cccedfc60806280540j4ff2635cu494eaeb685459e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60806280540j4ff2635cu494eaeb685459e6@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, sandeen@sandeen.net
List-Id: linux-raid.ids

Hello Jon,

On Sat, Jun 28, 2008 at 2:40 PM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
> database, the data is not being written to new files but existing
> files are being modified. If it were new files, then data=ordered
> would be fine but since it is existing files being modified (in-place)
> data=journal is more appropriate.
>
data=ordered should be fine in any case. Data is written directly to
disk (either modified data or newly allocated data, this does not
matter) and meta data goes through the journal log, written after the
data.

The problem lies in the fact that the driver can re-order the writes,
if write caching is enabled and barriers are not used (as in my case,
as md raid 5 does not support barriers).

> Of course, I might be wrong and would appreciate (polite) correction
> but this is what I've been led to believe.
>
I hope I was polite enough.

> Now, due to the hardware reset, write caching on drives is a problem.
>
Only because they re-order, not because of anything else.

> That you may have to disable - I've not found substantial performance
> differences on when write caching is enabled anyway, but surely that
> depends on a great many factors.
>
Indeed, we will be doing tests with that.

Regards,
-- 
Leon
