From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 21:07:24 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0510242050360.23767@twinlark.arctic.org>
References: <E1EUFcV-0005s3-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUFcV-0005s3-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Oct 2005, Jeff Breidenbach wrote:

> Dean, the comment about "write-mostly" is confusing to me.  Let's say
> I somehow marked one of the component drives write-mostly to quiet it
> down. How do I get at it? Linux will not let me mount the component
> partition if md0 is also mounted. Do you think "write-mostly" or
> "write-behind" are likely enough to be magic bullets that I should
> learn all about them?

if one drive is write-mostly, and you remount the filesystem read-only... 
then no writes should be occuring... and you could dd from the component 
drive directly and get a consistent fs image.  (i'm assuming you can 
remount the filesystem read-only for the duration of the backup because it 
sounds like that's how you do it now; and i'm assuming you're happy enough 
with your dd_rescue image...)

myself i've been considering a related problem... i don't trust LVM/DM 
snapshots in 2.6.x yet, and i've been holding back a 2.4.x box waiting for 
them to stabilise... but that seems to be taking a long time.  the box 
happens to have a 3-way raid1 anyhow, and 2.6.x bitmapped intent logging 
would give me a great snapshot backup option:  just break off one disk 
during the backup and put it back in the mirror when done.

there's probably one problem with this 3-way approach... i'll need some 
way to get the fs (ext3) to reach a "safe" point where no log recovery 
would be required on the disk i break out of the mirror... because under 
no circumstances do you want to write on the disk while it's outside the 
mirror.  (LVM snapshotting in 2.4.x requires a "VFS lock" patch which does 
exactly this when you create a snapshot.)


> John, I'm using 4KB blocks in reiserfs with tail packing.

i didn't realise you were using reiserfs... i'd suggest disabling tail 
packing... but then i've never used reiser, and i've only ever seen 
reports of tail packing having serious performance impact.  you're really 
only saving yourself an average of half a block per inode... maybe try a 
smaller block size if the disk space is an issue due to lots of inodes.

-dean
