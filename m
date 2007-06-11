From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Paranoid read mode for raid5/6
Date: Mon, 11 Jun 2007 09:39:37 -0700
Message-ID: <e9c3a7c20706110939m733c03b6s3071c752f783f60d@mail.gmail.com>
References: <Pine.GSO.4.64.0706111644550.9116@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0706111644550.9116@montezuma.acc.umu.se>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/11/07, Mattias Wadenstein <maswan@acc.umu.se> wrote:
> Hi *,
>
> Is there way to tell md to be paranoid and verify the parity for raid5/6
> on every read? I guess this would come with a (significant) performance
> hit, but sometimes that's not a big deal (unlike disks scrambling your
> data).
>
> Also, regarding data paranoia, for check/repair of a raid6, is the effort
> made to figure out which is the misbehaving participant device, or is
> parity just blindly recalculated?
>
This is something that is not available today, but is something I am
looking to implement.  Especially for the raid6 case where hpa showed
that not only can corruption be detected, it can be corrected.

> /Mattias Wadenstein

Dan
