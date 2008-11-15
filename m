From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: md.txt, preread_bypass_threshold and raid5: corrected error
Date: Fri, 14 Nov 2008 18:00:09 -0700
Message-ID: <e9c3a7c20811141700v736d7a3ep4362a96fc5afe90b@mail.gmail.com>
References: <alpine.DEB.1.10.0811121144250.12675@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811121144250.12675@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 12, 2008 at 9:49 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Read through md.txt from 2.6.27.5, noticed this at the end:
>
>  preread_bypass_threshold (currently raid5 only)
>      number of times a stripe requiring preread will be bypassed by
>      a stripe that does not require preread.  For fairness defaults
>      to 1.  Setting this to 0 disables bypass accounting and
>      requires preread stripes to wait until all full-width stripe-
>      writes are complete.  Valid values are 0 to stripe_cache_size.
>
> In terms of performance for raid5/raid6 - what does this mean?
>

When writes are streaming do a raid5/6 array the best performance is
achieved when the code can do a full-stripe-write.  In other words, a
write that does not require reading old data to generate new parity.
By default MD tries to be fair and allow partially written stripes the
same access to the disk as fully written stripes to prevent starvation
for little writers.  However, you can sometimes eek out more streaming
performance at the cost of fairness by increasing this value (where 0
== never let a preread pass a full-stripe-write).

--
Dan
