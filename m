From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm - comments on command layout
Date: Sat, 14 Aug 2004 22:33:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16670.1701.954970.773800@cse.unsw.edu.au>
References: <16669.9163.392465.637229@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Stoffel on Friday August 13
To: John Stoffel <stoffel@lucent.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 13, stoffel@lucent.com wrote:
> 
> Hi Neil,
> 
> I've been using mdadm recently to work with some arrays and I really
> have to say I dislike how the commands are laid out and used.  First
> off, they're not consistent from one usage to another.  Of course, I'm
> going to be jerk and not give good examples since my personal box at
> home is down and I'm at work.  But the idea is that when you assemble
> a RAID device, it should look similiar to how you manage that raid
> device.

Examples would really help.  In my mind it is very regular.  There is
some room for flexibility, but generally, the usage is 

   mdadm --mode --option...  /dev/md-device  [ component devices  ... ]


> 
> I'd also love it if there was an mdadm shell, so I could just type
> 'mdadm' and get back a shell prompt like:
> 	
> 	mdadm>
> 
> which I could then use to manage my arrays.  
> 
> For example, I think all the commands should be of the format:
> 
>     mdadm <comand> [options] <array> [devices...]

Except that I follow the Unix norms of --command, that is (to me)
exactly what usage is like.

> 
> as much as possible.  I'm basing my thoughts on both the Vertias VxVM
> command set, as well as the ClearCase 'cleartool' command shell.  So
> ideally I could do either:
> 
>   > mdadm assemble md0 /dev/hda1 /dev/hda2 ...
> 
> or
> 
>   > mdadm
>   madam> assemble md0 /dev/hda1 /dev/hda2 ...
> 
> depending on my mood.  Currently, the mdadm commands use various
> formats for their arguement layouts and it's a pain to figure out what
> to use.  

Well, if you really want a shell mode, I recommend writing one using a
popular shell, such as bash.  I have included a code fragment below.
If you store it in a file named, e.g., 'mdsh', then it will do
essentially what you seem to be asking.

> 
> So before I get all worked up on this issue, and spend a bunch of time
> mapping out how I think the commands should work, do people agree with
> my observation?  

I don't, but I'm obviously biased.  Maybe if you could (as I said
above) show me where the irregularities are, that would help.
Possibly  it's just a case of needing improved documentation.


Anyway, here is a code fragment which implements a command called
"mdsh".  If you type "mdsh" with no args, you get a shell prompt.  All
normal shell commands work as well as a new command "assemble" which
adds "/dev/" to it's first argument and passes the whole lot to "mdadm
--assemble".  Alternately, you can run
   mdsh assemble md0 ....

and get a similar effect.  Extensions are left as an exercise for the
reader. :-)

NeilBrown

#!/bin/bash

if [ $# -eq 0 -a " $mdsh_running" != " yes" ]
then
 export mdsh_running=yes
 exec bash --rcfile `which $0`
 exit 1
fi

assemble()
{
  mdev=$1; shift
  if [ ! -b "$mdev" -a -b /dev/"$mdev" ]
  then mdev=/dev/"$mdev"
  fi
  mdadm --assemble $mdev "$@"
}

case $# in
  0 )
    PS1='mdsh > '  PS2='mdsh.. '
    ;;
  * ) eval "$@"
esac
