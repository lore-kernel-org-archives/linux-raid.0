From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: PROBLEM: raid5 hangs
Date: Wed, 14 Nov 2007 17:18:29 -0700
Message-ID: <e9c3a7c20711141618r5b71e850n1abf01c070c7c3b4@mail.gmail.com>
References: <Pine.LNX.4.64.0711140607160.16327@sysbabe.flashdance.cx>
	 <Pine.LNX.4.64.0711140407190.22735@p34.internal.lan>
	 <473B8BC6.4070109@tmr.com>
	 <Pine.LNX.4.64.0711141904220.26370@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711141904220.26370@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Peter Magnusson <iocc@linux-raid.lists.flashdance.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Nov 14, 2007 5:05 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> On Wed, 14 Nov 2007, Bill Davidsen wrote:
> > Justin Piszcz wrote:
> >> This is a known bug in 2.6.23 and should be fixed in 2.6.23.2 if the RAID5
> >> bio* patches are applied.
> >
> > Note below he's running 2.6.22.3 which doesn't have the bug unless -STABLE
> > added it. So should not really be in 2.6.22.anything. I assume you're talking
> > the endless write or bio issue?
> The bio issue is the root cause of the bug yes?

Not if this is a 2.6.22 issue.  Neither of the bugs fixed by "raid5:
fix clearing of biofill operations" or "raid5: fix unending write
sequence" existed prior to 2.6.23.
