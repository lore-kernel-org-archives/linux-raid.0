From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under    
       Linux
Date: Fri, 4 Jun 2004 16:00:44 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <27831.194.60.85.4.1086361244.squirrel@194.60.85.4>
References: <16576.5818.189830.563396@cse.unsw.edu.au>
    <40287.194.60.85.4.1086343951.squirrel@194.60.85.4>
    <16576.26485.323313.378671@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16576.26485.323313.378671@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, June 4, 2004 13:13, Neil Brown said:
> On Friday June 4, robin@robinbowes.com wrote:
>> Where can I read more about this?
>
> Uhm.... Good question.  The are brief hints in
>    man mdadm
> and
>    man mdadm.conf
> but I guess I should put something in:
>    man 4 md

Ok, I've d/l and built the man pages for mdadm. I can't access my linux box at the
moment so I've done this on my WinXP laptop under cygwin. mdadm wouldn't build under
cygwin so I just built and installed the manpages. Here's a patch for the Makefile to
allow the manpages to be built/installed separately with "make man" and "make
install.man":

*** Makefile    Fri Jun  4 07:18:28 2004
--- Makefile.man        Fri Jun  4 15:11:27 2004
***************
*** 60,63 ****
--- 60,64 ----

  all : mdadm mdadm.man md.man mdadm.conf.man
+ man : mdadm.man md.man mdadm.conf.man

  everything: all mdadm.static mdadm.tcc mdadm.uclibc
***************
*** 106,109 ****
--- 107,115 ----
        $(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5

+ install.man : mdadm.8 md.4 mdadm.conf.5
+       $(INSTALL) -D -m 644 mdadm.8 $(DESTDIR)$(MAN8DIR)/mdadm.8
+       $(INSTALL) -D -m 644 md.4 $(DESTDIR)$(MAN4DIR)/md.4
+       $(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
+
  clean :
        rm -f mdadm $(OBJS) core *.man mdadm.tcc mdadm.uclibc mdadm.static *.orig
*.porig *.rej *.alt

Also I noticed a typo in the mdadm man page:

CREATE MODE
       Usage: mdadm --create device --chunk=X --level=Y
                   --raid-devices=Z devices

       This  usage will initialise a new md array, associate some devices with
       it, and activate the array.

       This the --auto option is given (as described in  more  detail  in  the ...

The second "This" should be "If" (I'm soooo anal sometimes!)

Anyway, back to the subject in hand...

I have a linux box into which I shall be installed 6 x 250GB SATA drives on a couple of
Promise controllers (3 per controller). I guess these will be named
/dev/sd{a,b,c,d,e,f}.

I then intend to create a couple of mirrored partitions, one to boot from and one for
swap, plus a large RAID5 array with several partitions for /usr,/home, /data, etc.

So, would I do something like:

# cfdisk /dev/sd{a,b,c,d,e,f}
(On each disk create one small partition for the RAID1 array + swap, plus one large
partition for the RAID5)

# grep mdp < /proc/devices
(Get the major numbers of the md devices - will I have more than one, eg XX1, XX2?)

# mdadm --create /dev/md/XX1 --auto=partition2 --level=1 --raid-devices=6 /dev/sd[abcdef]1
(create a RAID1 array from all six drives containing two partitions )

# mdadm --create /dev/md/XX2 --auto=partition6 --level=5 --raid-devices=6 /dev/sd[abcdef]2
(create a RAID5 array from all six drives containing 6 partitions)

# cfdisk /dev/md/XX1
(create /boot and swap partitions)

# cfdisk /dev/md/XX2
(create partitions on RAID5 array)

One issue:

 - Would it be better to create the mirrored arrays as separate, "standard" md arrays of
three drives (2 plus spare). Would I do this by 1) creating the necessary partitions,
2) building the array like this:

# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[ad]1 --spare-devices=1
/dev/sdb1

# mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sd[cf]1 --spare-devices=1
/dev/sde1

Am I somewhere near the mark?

Cheers,

R.
-- 
http://robinbowes.com

