From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: Bad Recovery
Date: Fri, 9 Jan 2004 18:28:27 -0600 (CST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4648.192.168.1.81.1073694507.squirrel@exitwound.org>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently underwent a fiasco that is far too long to describe.  Suffice
it to say that all /dev/hd* were renamed.  I've recovered the primary
elements of a raid-5 array, and the array successfully rebuilt during the
night/day.

My array is composed of /dev/hdc1, /dev/hdg1, and /dev/hdd1.  Prior to
said fiasco, /dev/hde1 was a member of the array but got kicked from the
array.  /dev/hdd1 is a new drive that I just added to the system.  When
the array was rebuilding, it kicked hde1 and used hdd1.

I'm now unable to add /dev/hde1 as a spare.  It's there, and the system
sees it, but

# mdadm -a /dev/hde1
mdadm: /dev/hde1 does not appear to be an md device

--force results in the same message.

I rebooted the system, and now can't get /dev/md0 to mount.

# mount /stuff
mount: wront fs type, bad option, bad superblock on /dev/md0,
    or too many mounted file systems
    (could this be the IDE devide where you in fact use
    ide-scsi so that sr0 or sda or so is needed?)

I'm sure I've left out a ton of information you might need.  If you'll let
me know what's needed, I'll be glad to forward it.

Thanks.
--
Steve
------------------------------------------
http://www.exitwound.org......hard to find
http://www.buckowensfan.com...he's the man
------------------------------------------
You are a very redundant person, that's
what kind of person you are.
------------------------------------------

