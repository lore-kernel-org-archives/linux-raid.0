From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 13:59:27 -0700
Message-ID: <5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAD18A5.1080905@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 1:27 PM, Peter Kieser <peter@kieser.ca> wrote:
<SNIP>
> Hello,
>
> The 4096-byte sector drives work fine with mdadm. The main problem you are
> going to run into with the WDC Green drives is their 8 second "idle"
> setting. After 8 seconds, by default, the drive parks its heads. This can
> lead to an amazingly high Load Cycle Count (LLC) after just a month of
> operation due to the fact that most disk access happens around that time
> causing the drive to park and unpark in repeated cycles.
>
> To fix this, find a utility called wdidle3 (I have it, if you are unable to
> locate it) and set the idle timeout on the drives to 300 seconds. These
> drives do not support TLER, there is no ability to set it via firmware
> anymore - WDC removed this ability sometime last year.
>
> -Peter

This seems to be a windows program? I don't see a Linux version in
Gentoo portage.

I could run Windows once to set it if the settings are then
maintained, or do you have a Linux solution?

- Mark
