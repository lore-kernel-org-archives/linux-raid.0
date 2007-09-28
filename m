From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 11:52:31 -0500
Message-ID: <cccedfc60709280952k125f9356oa7f476a490a9ff@mail.gmail.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
	 <87sl521kqh.fsf@informatik.uni-tuebingen.de>
	 <20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>
	 <87k5qe19p0.fsf@informatik.uni-tuebingen.de>
	 <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com>
	 <46FB7D2A.1050608@ziu.info>
	 <20070927221049.19BE21023EB@medulla.enet.sharplabs.com>
	 <46FD1442.70707@tmr.com>
	 <cccedfc60709280811j44d6b1c8w60e209d7c6defca9@mail.gmail.com>
	 <46FD2AF3.4040501@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46FD2AF3.4040501@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
> What I don't understand is how you use hard links... because a hard link
> needs to be in the same filesystem, and because a hard link is just
> another pointer to the inode and doesn't make a physical copy of the
> data to another device or to anywhere, really.

Yes, I know how hard links work. There is (one) physical copy of the
data when it goes from the filesystem on the raid to the filesystem on
the drbd. Subsequent "copies" of the same file, assuming the file has
not changed, are all hard links on the drbd-backed filesystem. Thus, I
have one *physical* copy of the data and a whole bunch of hard links.
Now, since I'm using drbd I actually have *two* physical copies (for a
total of three if you include the original) because the *other*
machine has a block-for-block copy of the drbd device (or it did, as
of a few days ago).

link-dest basically works like this:

Assuming we are going to "copy" (using that word loosely here) file
"A" from "/source" to "/dest/backup.tmp/", and we've told rsync that
"/dest/backup.1/A" might exist:


If "/dest/backup.1/A" does not exist: make a physical copy from
"/source/A" to "/dest/backup.tmp/A".
If it does exist, and the two files are considered identical, simply
hardlink "/dest/backup.tmp/A" to "/dest/backup.1/A".
When all files are copied, move every "/dest/backup.N" (N is a number)
to "/dest/backup.N+1"
If /dest/backup.31 exists, delete it.
Move /dest/backup.tmp to /dest/backup.1 (which was just renamed /dest/backup.2)

I can do all of this, for 175K files (40G), in under 2 minutes on
modest hardware.
I end up with:
1+1 physical copies of the data (local drbd copy and remote drbd copy)

There is more but if I may suggest: if you want more details contact
me off-line, I'm pretty sure the linux-raid folks couldn't care less
about rsync and drbd.
-- 
Jon
