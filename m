From: Peter Kay <syllopsium@syllopsium.co.uk>
Subject: Re: Two disk RAID10 inactive on boot if partition is missing
Date: Wed, 18 May 2016 05:16:46 +0100
Message-ID: <CAN4OnojftdMiFDSJMh_G=OHPQsXGZ0W18ubjG8P_2BDFXDF9Mg@mail.gmail.com>
References: <CAN4OnogXN45Z3UUJyFzGgACPXuQMm1Gfw18kY9bjATrt5tvNqg@mail.gmail.com>
	<alpine.DEB.2.02.1605171038490.28372@uplift.swm.pp.se>
	<CAN4OnoguQMvnuUr7mGYpTi7_SonZ42Z5TSigKaJ0ZfZuiup0Og@mail.gmail.com>
	<alpine.DEB.2.02.1605171209470.28372@uplift.swm.pp.se>
	<573B1D49.6090301@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <573B1D49.6090301@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17 May 2016 at 14:31, Phil Turmel <philip@turmel.org> wrote:
> See the "Unclean Shutdown" section of "man md".
>
> The kernel parameter you need is "md_mod.start_dirty_degraded=1".
>
> Doing this is a really good way to end up with split brain.  Why do you
> need to regularly boot without the devices that were present at shutdown?
Thanks for the md reference.

I don't need to regularly boot with devices that were present at
shutdown, but this is RAID! Given that it's not a boot device, and
frankly even if it was, I would expect the default to be to start up
anyway and then to be able to replace the missing device to be an
option. Otherwise it removes a lot of the point of resilience.

I'll have a look at this further later tonight. The reason it is
failing from '-v' is because /dev/sda12 is 'busy'. Looks like I need
to read the docs further, I got it to come back up by using stop and
assemble, but yes looks like split brain is a thing when I do that.
Fortunately I'm not using this for anything important yet - I'm doing
this precisely so that I know what to do when a device does fail. Once
it's all working I'm going to leave it alone.
