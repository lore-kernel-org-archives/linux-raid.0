From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Tue, 22 Nov 2005 16:41:44 +0100
Message-ID: <62b0912f0511220741v4a926cc4w9bb18e72ad457ff5@mail.gmail.com>
References: <437E2CB6.2030903@xss.co.at>
	 <17282.22120.327672.720044@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17282.22120.327672.720044@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> I would like it to take an argument in contexts where --bitmap was
> meaningful (Create, Assemble, Grow) and not where --brief is
> meaningful (Examine, Detail).  but I don't know if getopt_long will
> allow the 'short_opt' string to be changed half way through
> processing...

Here's an honest opinion from a regular user.

mdadm's command line arguments seem arcane and cryptic and unintuitive.
It's difficult to grasp what combinations will actually do something
worthwhile and what combinations will just yield a 'you cannot do
that' output.

I find myself spending 20 minutes with mdadm --help and experimenting
with different commands (which shouldn't be the case when doing RAID
stuff) just to do simple things like create an array or make MD
assemble the devices that compose an array.

I know.  Not very constructive, but a POV anyway.  Maybe I just do not
use MD enough, and so I shouldn't complain, because the interface is
really not designed for the absolute newbie.  If so, then I apologize.

I don't have any constructive suggestions, except to say that the way
the classic Cisco interface does things works very nicely.

A lot of other manufacturers has also started doing things the Cisco
way.  If you don't have a Cisco router available, you can fx. use a
Windows XP box.  Type 'netsh' in a command prompt, then 'help'.  Or
alternatively 'netsh help'.  You get the idea :-).
