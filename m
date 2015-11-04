From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested re: hard drive setup for RAID arrays
Date: Wed, 4 Nov 2015 10:05:00 -0500
Message-ID: <563A1E9C.4060003@turmel.org>
References: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
 <563A0462.9000200@turmel.org>
 <CAPpdf59BqCABOw=gHw=y8zO-xVzFDn30FLbgqFDjmiBzrgAaHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf59BqCABOw=gHw=y8zO-xVzFDn30FLbgqFDjmiBzrgAaHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/04/2015 09:30 AM, o1bigtenor wrote:

> I used to have to mount my raid array on every reboot so I can handle running
> the script every reboot. They happen at most weekly and for sure biweekly
> because Firefox doesn't know how to use AND release RAM.

Put an entry in fstab to mount your array at boot.  Put Brad's script in
/etc/rc.local.  Try "man fstab".

You don't need to reboot to clean up after Firefox.  At most, logout and
re-login will do.  Or just "killall firefox".

> Those are the drives Brad uses.

No. The script is generic.  It attempts to fix anyone's drives.  Clearly
falls down on your USB drives.  Oh, well.  Specify the drives you want
instead of using a wildcard.

> I read the files listed.
> There wasn't anything specific as to what to look for.

The following was in your reading list.  The options A-D at the end
couldn't be more clear.

http://marc.info/?l=linux-raid&m=135811522817345&w=1

> There is a lot of traffic which isn't really of interest as I hope that I don't
> have to develop kernel skills. Was hoping to just occasionally browse
> something that would be of interest.

This list is mostly administration skills.  You need those if you are
going to be running raid arrays.  I'm sorry if *reading* inconveniences
you, but the whining won't change anything.  Except to make me less
enthusiastic about helping you.

Phil
