From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Stress testing system?
Date: Fri, 8 Oct 2004 23:07:44 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0410082303330.26162@lion.drogon.net>
References: <4167078A.3030609@robinbowes.com> <41670DF3.5040807@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41670DF3.5040807@h3c.com>
To: Mike Hardy <mhardy@h3c.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 8 Oct 2004, Mike Hardy wrote:

> Slightly more on-topic, one thing that I have do to frequently is boot
> with noapic or acpi=off due to interrupt handling problems with various
> motherboards.

I've seen this (and made mention of it here in the past) it basically
boils down to cheap motherboards with buggy chipsets )-: Some BIOSes let
you select PIC or APIC - on these buggy ones, I stick to PIC.

> Additionally, I think there have been reports of problems with raid and
> LVM, and there have also been problems with SATA and possibly with
> Maxtor drives, so you have may have some tweaking to do. Mentioning
> versions of things (distribution, kernel, hardware parts and part
> numbers etc) would help

I had problems some 2 years ago when I first dabbled with LVM. Quickly
found problems with performance and random crashes and not having time to
persue it further, left it alone and haven't ventured back since!

> I'm interested to hear what other people do to burn their machines in
> though...

Looks like we do someting similar... So that can't be bad! I'm sure there
is plenty cpu left over for me to do stuff like compiles, etc.

Many years ago I used to write diagnostics for compter systems - memory,
cpu, IO, etc. there were cases where the systems would pass all the diags
faultlessly for days on end, then crash 2 minutes into the application, so
theres no substitute for real life testing...

Gordon
