From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: avoiding the initial resync on --create
Date: Mon, 9 Oct 2006 15:49:46 +0200
Message-ID: <20061009134946.GA26122@harddisk-recovery.com>
References: <20061009125700.GA10191@piper.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061009125700.GA10191@piper.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 09, 2006 at 02:57:00PM +0200, martin f krafft wrote:
> I am looking at http://bugs.debian.org/251898 and wondering whether
> it is save to use --assume-clean (which prevents the initial resync)
> when creating RAID arrays from the Debian installer.
> 
> Please also see the following discussion on IRC:
> 
> < madduck> yeah, i am not sure --assume-clean is a good idea.
> < peterS> madduck: why not?  I've tried to think of a reason it
>   would fail for months, and so far I'm too stupid to think of one
> < madduck> even then
> < madduck> peterS: because it then assumes that it
> < madduck> it's clean, period.
> < peterS> yeah, so?
> < peterS> the blocks you have not written will have unreliable
>   contents
> < madduck> in reality, the three components are not properly XORed
> < peterS> but why would you care about that?
> < madduck> hm. kinda true.
> < peterS> the blocks you _do_ write will be correct
> < peterS> even an uninitialised raid5 or raid6 seems like it would
>   work perfectly well with --assume-clean

There is no way to figure out what exactly is correct data and what is
not. It might work right after creation and during the initial install,
but after the next reboot there is no way to figure out what blocks to
believe.

> Do you have any thoughts on the issue? If Debian were to --create
> its arrays with --assume-clean just before slapping a filesystem on
> them and installing the system, do you see any potential problems?

If you want to speed up the initial install, I'd say it's better to
create the array with one missing drive, install the system and let it
resync upon the next boot. Be sure to tell the user about that, though.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
