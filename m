From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Thu, 24 Nov 2005 16:25:01 +1100
Message-ID: <17285.20141.12518.264787@cse.unsw.edu.au>
References: <437E2CB6.2030903@xss.co.at>
	<17282.22120.327672.720044@cse.unsw.edu.au>
	<62b0912f0511220741v4a926cc4w9bb18e72ad457ff5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Tuesday November 22
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 22, molle.bestefich@gmail.com wrote:
> Neil Brown wrote:
> > I would like it to take an argument in contexts where --bitmap was
> > meaningful (Create, Assemble, Grow) and not where --brief is
> > meaningful (Examine, Detail).  but I don't know if getopt_long will
> > allow the 'short_opt' string to be changed half way through
> > processing...
> 
> Here's an honest opinion from a regular user.

Honest is always nice!

> 
> mdadm's command line arguments seem arcane and cryptic and unintuitive.
> It's difficult to grasp what combinations will actually do something
> worthwhile and what combinations will just yield a 'you cannot do
> that' output.
> 
> I find myself spending 20 minutes with mdadm --help and experimenting
> with different commands (which shouldn't be the case when doing RAID
> stuff) just to do simple things like create an array or make MD
> assemble the devices that compose an array.

Thanks strange.  They seem very regular and intuitive to me (but I
find it very hard to be objective).  Maybe you have a mental model of
what the task involves that differs from how md actually does things.

To create an array, you need:
  the array to create,
  the list of devices to hold the data
  the level
  the number of devices (consistency check)
  and maybe some other parameters like chunksize or parity mode.
So that is what you give 'mdadm --create'
Providing you give the array to be created first, the rest can come in
any order.

 mdadm --create /dev/md0  /dev/sda /dev/sdb --level=5 --raid-disks=3 /dev/sdc

Can you say anything more about the sort of mistakes you find yourself
making.  That might help either improve the help pages or the error
messages (revamping all the diagnostic messages to make the more
helpful is slowly climbing to the top of my todo list).

> 
> I know.  Not very constructive, but a POV anyway.  Maybe I just do not
> use MD enough, and so I shouldn't complain, because the interface is
> really not designed for the absolute newbie.  If so, then I apologize.
> 
> I don't have any constructive suggestions, except to say that the way
> the classic Cisco interface does things works very nicely.
> 
> A lot of other manufacturers has also started doing things the Cisco
> way.  If you don't have a Cisco router available, you can fx. use a
> Windows XP box.  Type 'netsh' in a command prompt, then 'help'.  Or
> alternatively 'netsh help'.  You get the idea :-).

Is this and interactive interface where you have hit 'tab' at anytime
and it either completes the current word, or lists options? (For me,
that is the 'kermit' interface, as kermit was the first program I used
which had it).
This is certainly a nice interface when learning a system, but I don't
think it belongs in a tool like mdadm.  Rather it might make sense to
create an 'mdassist' tool which works like this and build mdadm
commands for you...

NeilBrown
