From: "NeilBrown" <neilb@suse.de>
Subject: Re: sync_action missing in action in linux-2.6.12 ?
Date: Fri, 11 Sep 2009 14:05:35 +1000 (EST)
Message-ID: <8dd5fbc076f31a8d043d6edf01ae9e03.squirrel@neil.brown.name>
References: <1252617509.4735.19.camel@lgelinas>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1252617509.4735.19.camel@lgelinas>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-Michel Gelinas <coradiant.kernel@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, September 11, 2009 7:18 am, Louis-Michel Gelinas wrote:
> Hi all,
>
> I bought this neat little NAS box (dlink dns-323).
>
> I runs linux-2.6.12.6 and mdadm 2.5.6
>
> There is a nice community and tools to "hack" it and use it as a
> "normal" linux system.
>
> I would like to run raid1 "repair" and "check" sync_action.

This functionality did not appear until 2.6.15. If you want it,
you will need a new kernel.

NeilBrown


