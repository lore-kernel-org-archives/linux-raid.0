From: "John Stoffel" <john@stoffel.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 16:58:40 -0400
Message-ID: <17245.19200.846162.15129@smtp.charter.net>
References: <E1EU8w7-0003Bp-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU8w7-0003Bp-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Jeff" == Jeff Breidenbach <jeff@jab.org> writes:


Jeff> # mount | grep md0
Jeff> /dev/md0 on /data1 type reiserfs (rw,noatime,nodiratime)

Ah, you're using reiserfs on here.  It may or may not be having
problems with all those files per-directory that you have.  Is there
any way you can split them up more into sub-directories?  

Old news servers used to run into this exact same problem, and what
they did was move all files starting with 'a' into the 'a/' directory,
all files starting with 'b' into b/... etc.  You can go down as many
levels as you want.  

Jeff> Individual directories contain up to about 150,000 files. If I
Jeff> run ls -U on all directories, it completes in a reasonably
Jeff> amount of time (I forget how much, but I think it is well under
Jeff> an hour). Reiserfs is supposed to be good at this sort of
Jeff> thing. If I were to stat each file, then it's a different story.

Do you stat the files in inode order (not sure how reiserfs stores
files), when you're doing a readdir() on the directory contents?  You
don't want to bother sorting at all, you just want to pull them off
the disk as efficiently as possible.

I think you'll get alot more performance out of your system if you can
just re-do how the application writes/reads the files you're using.
It almost sounds like some sort of cache system...

The other idea would be to use 'inotify' and just copy those files
which change to the cloned box.

Another idea, which would require more hardware would be to make some
readonly copies of the system and have all reads go there, and only
writes goto the master system.  If the master dies, you just promote a
slave into that role.  If a slave dies, you have extras running
around.  Then you could do your backups against the readonly systems,
in parallel to get the most performance out of your backups.

But knowing more about the application would help.  Millions of tiny
files aren't optimal these days.  

Oh yeah, what kinds of block size are you using on the filesystem?
And how many disks?  Splitting the load across more smaller disks will
probably help as well, since I suspect that your times are dominated
by seek and directory overhead, not actually reading of all these tiny
files.

John
