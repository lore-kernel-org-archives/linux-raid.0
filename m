From: "NeilBrown" <neilb@suse.de>
Subject: Re: How to un-degrade an array after a totally spurious failure?
Date: Thu, 21 May 2009 12:49:04 +1000 (EST)
Message-ID: <97f847c1f487636ed40b8c1db1b98105.squirrel@neil.brown.name>
References: <87skiztloo.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87skiztloo.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 21, 2009 9:10 am, Nix wrote:

> So, anyone got a command that would help? I'm not even sure if this is
> assembly or growth: it doesn't quite fit into either of those
> categories. There must be a way to do this, surely?

It is neither.  It is management.

 mdadm --manage /dev/mdX --remove /dev/sdb6
 mdadm --manage /dev/mdX --add /dev/sdb6

(The --manage is not actually needed, but it doesn't hurt).

NeilBrown

