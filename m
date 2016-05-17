From: Phil Turmel <philip@turmel.org>
Subject: Re: Two disk RAID10 inactive on boot if partition is missing
Date: Tue, 17 May 2016 09:31:53 -0400
Message-ID: <573B1D49.6090301@turmel.org>
References: <CAN4OnogXN45Z3UUJyFzGgACPXuQMm1Gfw18kY9bjATrt5tvNqg@mail.gmail.com>
 <alpine.DEB.2.02.1605171038490.28372@uplift.swm.pp.se>
 <CAN4OnoguQMvnuUr7mGYpTi7_SonZ42Z5TSigKaJ0ZfZuiup0Og@mail.gmail.com>
 <alpine.DEB.2.02.1605171209470.28372@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1605171209470.28372@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Peter Kay <syllopsium@syllopsium.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/17/2016 06:13 AM, Mikael Abrahamsson wrote:
> On Tue, 17 May 2016, Peter Kay wrote:
> 
>> I'm not trying to boot from it, and I'm using Salix (Slackware), not a
>> debian based distribution. My boot partitions are not raided.
> 
> The setting would still be valid if your distribution defaults to not
> assembling and using degraded arrays on boot.

See the "Unclean Shutdown" section of "man md".

The kernel parameter you need is "md_mod.start_dirty_degraded=1".

Doing this is a really good way to end up with split brain.  Why do you
need to regularly boot without the devices that were present at shutdown?

Phil

