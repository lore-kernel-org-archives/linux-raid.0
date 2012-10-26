From: Emmanuel Noobadmin <centos.admin@gmail.com>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Sat, 27 Oct 2012 00:53:27 +0800
Message-ID: <CAAYorBJq9Jf4j3jV=EjK3FJBx6Rf1NNV6kM7Kwv6+M=F2O0Kxg@mail.gmail.com>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
	<20121001125510.6cc0c2be@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121001125510.6cc0c2be@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/1/12, NeilBrown <neilb@suse.de> wrote:
> Should work.... what kernel are you running?  There was a bug between
> 2.6.30
> and 2.6.37 which would have the effect.
> A quick good search suggest that Centos 6 uses 2.6.32, which would be
> affected until 2.6.32.27 which contains the fix.
>
> If you reboot (or just stop the array and re-assemble it), md should get
> itself sorted out and the --grow will work.

I found this thread on the list while trying to figure out almost the
exact same problem on CentOS 6.3 where --grow doesn't increase the
array size inside a VM guest after I've lvextended the underlying LV
on the host machine.

You mentioned this bug was fixed in 2.6.32.27, does this mean my
kernel version 2.6.32-279.11.1.el6.x86_64 should not be seeing this
bug and I should be looking at some other cause? This is because fdisk
-l doesn't seem to be seeing the new size either.

p.s. replying to the list appears to default to include your personal
email in the reply, apologies if that is not right.
