From: "NeilBrown" <neilb@suse.de>
Subject: Re: BUG: Bad page state in process md1_resync  pfn:50ab4
Date: Sun, 3 May 2009 19:53:30 +1000 (EST)
Message-ID: <180f4e6e9dca4be3527469e106c6e6b4.squirrel@neil.brown.name>
References: <20090503074429.GA3436@aketzu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090503074429.GA3436@aketzu.net>
Sender: linux-raid-owner@vger.kernel.org
To: Anssi Kolehmainen <anssi@aketzu.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 3, 2009 5:44 pm, Anssi Kolehmainen wrote:
> Last night one server died apparently while doing resync of 1.5Tb md
> raid1 array. Syslog [1] contained messages about BUG: Bad page state but
> something else killed the system. Too bad the start of the stack trace
> didn't fit in the monitor [2] so I don't know the exact cause for the
> final freeze.
>
> The machine is rather old desktop PC serving disks over NFS and Samba.
> Apart from failing Seagate drives everything has worked fine for few
> weeks and this is the first time this occured. Any thoughts of the BUG
> or is there anything else you would like to know?

This a known problem  it is fixed in 2.6.29.2 released just recently.

My apologies that it wasn't caught before .29 was released.

NeilBrown

