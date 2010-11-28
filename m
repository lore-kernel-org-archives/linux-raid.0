From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Monitor: few bug fixes for spare migration
Date: Mon, 29 Nov 2010 09:54:10 +1100
Message-ID: <20101129095410.6f2f9c24@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C00972F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C00972F@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Thu, 25 Nov 2010 17:28:29 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From bbe35756559c6bee0309ce7ebae668c53d5e1a74 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Thu, 25 Nov 2010 18:25:03 +0100
> Subject: [PATCH] Monitor: few bug fixes for spare migration
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> 1. If array not changed we should still report anydegraded
> - another array may have got a new spare that we can move.
> 2. Array with err=1 can't give a spare.
> 3. Spares can't be migrated between different metadata arrays.

I meant the mention this before - thanks for the reminder.

Why do you want to forbid spare migration between different metadata arrays??

If an admin wanted to impose this restriction they could easily use domains -
a different domain for each metadata type.
But if there a good reason to insist on this in the code in a way that the
sysadmin cannot over-ride it?


> 4. We look for spares in "from" not "st" which is supertype
> and has devname=NULL.

Thanks!  The other 3 changes are all good.  I have applied the patch with the
metadata type check removed for now.

NeilBrown


