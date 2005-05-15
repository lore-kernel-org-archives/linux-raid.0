From: David Greaves <david@dgreaves.com>
Subject: Re: Strange behaviour on "toy array"
Date: Sun, 15 May 2005 21:09:12 +0100
Message-ID: <4287AC68.50301@dgreaves.com>
References: <62b0912f0504220345349335f9@mail.gmail.com>	 <62b0912f050512015585a6ba5@mail.gmail.com>	 <17028.5921.815691.401690@cse.unsw.edu.au> <62b0912f05051511107a0c4e0@mail.gmail.com> <4287937C.3090307@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4287937C.3090307@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patrik Jonsson wrote:

> hi all,
>
> I'm gearing up to setting up a 2tb raid for our research group, and
> just to see how this stuff works I made a loopback array on one of my
> machines. I created 5 loopback devices of 1mb each, created a raid5
> array and formatted. so far so good. I could copy files on and off,
> fail a disk with mdadm -f  and then return it and everything seemed to
> work as i expected. Then I decided to see what happens if things go
> bad, so i fail one disk. fine, array reports "clean, degraded" but I
> can still access files. Then I fail another, now expecting not to be
> able to read anything. But, array reports "clean, degraded" and I can
> still access the files. I then proceeded to fail ALL disks and the
> array was still "clean, degraded" and I could read the files on it
> just as well as before??? Can anyone explain to me what's going on
> here? Was I seeing some cached version (given that the array was so
> small)?

I think you'd need to post the commands you used and the results of 
things like mdadm --detail and cat /proc/mdstat
also kernel version, mdadm version etc.

That way we can ensure you really did fail the right drives etc etc.

Right now it could be anything from (allowed!) user error to a weird ppc
thing...

FYI I run a 1.2Tb array on 6x250Gb SATA drives (1 spare) with lvm2 and xfs

David


