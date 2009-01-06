From: "NeilBrown" <neilb@suse.de>
Subject: Re: Need urgent help in fixing raid5 array
Date: Tue, 6 Jan 2009 15:00:43 +1100 (EST)
Message-ID: <780997576890f2ccd07a4486c2702e8d.squirrel@neil.brown.name>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com>
    <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan>
    <467705.96388.qm@web30807.mail.mud.yahoo.com>
    <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>
    <344038.60917.qm@web30808.mail.mud.yahoo.com>
    <18786.34165.639790.37753@notabene.brown>
    <546794.45786.qm@web30802.mail.mud.yahoo.com>
    <879ae2ec7c5524fd9fa9841245772ab6.squirrel@neil.brown.name>
    <100979.40008.qm@web30803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <100979.40008.qm@web30803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

On Tue, January 6, 2009 1:46 pm, Mike Myers wrote:
> BTW, don't I need to use the --assume-clean option in the create operation
> to have this work right?

No.  When you create a degraded raid5, it is always assumed to be clean,
because it doesn't make any sense for it to be dirty.
However it wouldn't hurt to use --assume-clean, but it won't make any
difference.

NeilBrown

