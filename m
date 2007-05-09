From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery of software RAID5 using FC6 rescue?
Date: Wed, 09 May 2007 07:29:00 +0100
Message-ID: <87vef2wlw3.fsf@hades.wkstn.nix>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan>
	<17984.29974.116526.922404@notabene.brown>
	<7EF2C690-263B-4437-BCE2-42762484CB5B@dartmouth.edu>
	<4640D7E0.9010102@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4640D7E0.9010102@msgid.tls.msk.ru> (Michael Tokarev's message of "8 May 2007 21:05:11 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "Mark A. O'Neil" <mark.a.oneil@Dartmouth.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 May 2007, Michael Tokarev told this:
> BTW, for such recovery purposes, I use initrd (initramfs really, but
> does not matter) with a normal (but tiny) set of commands inside,
> thanks to busybox.  So everything can be done without any help from
> external "recovery CD".  Very handy at times, especially since all
> the network drivers are here on the initramfs too, so I can even
> start a netcat server while in initramfs, and perform recovery from
> remote system... ;)

What you should probably do is drop into the shell that's being used to
run init if mount fails (or, more generally, if after mount runs it
hasn't ended up mounting anything: there's no need to rely on mount's
success/failure status). e.g. from my initramfs's init script (obviously
this is not runnable as is due to all the variables, but it should get
the idea across):

if [ -n $root ]; then
    /bin/mount -o $OPTS -t $TYPE $ROOT /new-root
fi

if /bin/mountpoint /new-root >/dev/null; then :; else
    echo "No root filesystem given to the kernel or found on the root RAID array."
    echo "Append the correct 'root=', 'root-type=', and/or 'root-options='"
    echo "boot options."
    echo
    echo "Dropping to a minimal shell.  Reboot with Ctrl-Alt-Delete."

    exec /bin/sh
fi
