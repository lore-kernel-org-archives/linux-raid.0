From: Gordon Henderson <gordon@drogon.net>
Subject: Re: New RAID-5 800GB array, wich fs ? wich stripe block size ?
Date: Tue, 20 Jul 2004 09:29:08 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0407200902120.30363@lion.drogon.net>
References: <40FB923D.1080903@gouny.org> <40FC30C2.5050600@dobbels.com>
 <40FC37A9.6060006@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40FC37A9.6060006@h3c.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 19 Jul 2004, Mike Hardy wrote:

> I just chose plain vanilla ext3 ('mke2fs -j -m1 /dev/md2') on top of
> plain ol' raid 5. The only option that's different there is the "m1"
> since with an enormous filesystem, reserving 5% of it for root use is a
> bit silly.

I'm using ext3 on some biggish systems too. Never thought about the -m
option, but I always thought the 5% was for efficiency to stop
fragmentation?

> With regard to performance, the first thing you'll notice is that unless
> you have gigabit to everywhere, you're limited by network I/O. I am
> anyway. I could saturate a 100Mbit network connection with the read
> speed, and after that, who cares?

One thing you might want to look into with ext2/3 is the stride size.
Theres an option in mkfs.ext2/3 to let you set this, and words in the S/W
RAID HowTo describing its use with a RAID5 setup.

However, as you say, it probably doesn't matter if you only have 100Mb
networking! DAThe only time I've seen this make a difference though is
when backing up to a local DLT tape drive.

Basically, you set the stride size to the chunk-size / 4 (if you are using
the default 4K block size) So with a chunk-size of 64, the stride size
will be 16; mkfs -t ext3 -R stride=16 /dev/mdX

See

  http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.10

and read down to the bottom of the page.

However, I feel that this sort of tuning will really only matter if your
data is of a nature to take full advantage of it - eg. all big files,
access sequentially rather than lots of little files access randomly, or
whatever! I suspect the only way to see what will work for you is to suck
it and see!

> Different filesystems will clearly be better for different situations,
> but if you're just looking to serve files over the network you're really
> not going to need to work hard to get it set up "good enough".

Indeed. One other thing that you might want to invest in is a managed
Ethernet switch. That way to can see if it really is the filesystem thats
a bottleneck (assuming it's a server and not just a filestore for local
applications). I recently checked a network I look after, after the users
were wondering if the network was running flat-out (it's only 100Mb) and
was able to show that actually, 10Mb switches would be almost good enough
for the most-part. MRTG is your friend here! I was able to get more or
less full bandwidth out of it via NFS (running Bonnie) and over 5 times
that locally (again with Bonnie) so I was happy with the servers
performance and happy to blame the applications for being slow to write
their data ;-)

> I will say though, I've had hardware failures and machine failures take
> the array out before - remember that MTBF is divided by the number of
> parts and arrays usually have lots of parts. Don't forget to backup
> early and often...

Absolutely.

Gordon
