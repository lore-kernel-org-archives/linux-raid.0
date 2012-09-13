From: Daniel Frey <djqfrey@gmail.com>
Subject: Re: mdadm forces resync every boot
Date: Wed, 12 Sep 2012 18:11:37 -0700
Message-ID: <CA+ZgY1Exb8y4V2Vwyr+W5EDZKOJHhpWYUffOEPT4sAw4DP56oQ@mail.gmail.com>
References: <4E3C06D1.6030301@gmail.com>
	<20110809093437.299036be@notabene.brown>
	<4E41D9EC.1070706@gmail.com>
	<20110810113146.3667affb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110810113146.3667affb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 9, 2011 at 6:31 PM, NeilBrown <neilb@suse.de> wrote:
>
> It need /proc, /sys, and /dev (assuming udev).
> There is really no point in unmounting any of these as they are virtual.
> Unmount everything else, remount root readonly, then "mdadm --wait-clean".
>
> However I would expect missing filesystems to cause an early failure rather
> than a hang.  If mdmon had been killed already that might cause a bit of a
> hang, but it should be limited to 5 seconds.
>
> Maybe run 'mdadm --wait-clean --scan' under 'strace' and see what it is
> doing??
>
> NeilBrown
>

I actually forgot I posted to this list so long ago. I hesitated about
posting here and resurrecting it, but I figured it'd be for the
benefit of others searching about this problem with gentoo.

I eventually traced the problem to a script while shutting down, it
killed all running processes (including mdmon.) I had an almost
working solution, and with a collaboration with someone else on the
gentoo forums, there's a full solution now.

The forum thread is @
http://forums.gentoo.org/viewtopic-t-888520.html

I've reported it as a bug on the bugtracker, I've also got a
workaround for it on that bug report:
https://bugs.gentoo.org/show_bug.cgi?id=395203

The workaround still hasn't made it into the main repository.

Hopefully this will get threaded properly...
