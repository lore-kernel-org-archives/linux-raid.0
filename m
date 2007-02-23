From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 2.6.20: stripe_cache_size goes boom with 32mb
Date: Fri, 23 Feb 2007 12:11:44 -0700
Message-ID: <e9c3a7c20702231111l1cb8767ar7f670c5e3c2338b4@mail.gmail.com>
References: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
	 <1172234460.4419.7.camel@merlin>
	 <Pine.LNX.4.64.0702230741540.3781@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702230741540.3781@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jason Rainforest <l3mming@iinet.net.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/23/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I have 2GB On this machine.  For me, 8192 seems to be the sweet spot, I
> will probably keep it at 8mb.
>
Just a note stripe_cache_size = 8192 = 192MB with six disks.

The calculation is:
stripe_cache_size * num_disks * PAGE_SIZE = stripe_cache_size_bytes

--
Dan
