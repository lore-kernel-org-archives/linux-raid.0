From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 07/11] md: rewrite handle_stripe_dirtying6 in asynchronous
	way
Date: Thu, 15 Jan 2009 15:21:18 -0700
Message-ID: <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com>
References: <200812090057.33890.yur@emcraft.com>
	 <e9c3a7c20901151351p5e1b4641h1b4c8ba1ae5dcc73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20901151351p5e1b4641h1b4c8ba1ae5dcc73@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Thu, Jan 15, 2009 at 2:51 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Dec 8, 2008 at 2:57 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
> What's the reasoning behind changing the logic here, i.e. removing
> must_compute and such?  I'd feel more comfortable seeing copy and
> paste where possible with cleanups separated out into their own patch.
>

Ok, I now see why this change was made.  Please make this changelog
more descriptive than "Rewrite handle_stripe_dirtying6 function to
work asynchronously."

Regards,
Dan
