From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID tuning?
Date: Tue, 13 Jun 2006 22:38:24 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0606132229110.17860@lion.drogon.net>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
 <17550.2944.728044.154492@cse.unsw.edu.au> <448E127F.5010708@comcast.net>
 <Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>
 <Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>
 <Pine.LNX.4.56.0606131124160.27931@lion.drogon.net> <448EFCA7.6050603@comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <448EFCA7.6050603@comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 13 Jun 2006, Adam Talbot wrote:

> I still have not figured out if "block" is per disk or per stripe?
> My current array is rebuilding and states "64k chunk" is this a per disk
> number or is that a functional stripe?

The block-size in the argument to mkfs is the size of the basic data block
on disk. (if this is what you mean) In olden days you'd fiddle with this
to do two things: By reducing it, you can reduce the amount of wasted
space on the filesystem - eg. if you were to only write files of 1K long,
then with a 4K blocks-size, you'll waste 3K of disk space for each file,
secondly reducing it you can increase the number of inodes - which once
upon a time was neccessary when using a disk for a usenet new spool disk
(millions upon millions of small files where you'r typically run out of
inodes)

Of course you might be meaning something else ;-)

> Nice scrip Gordon.  It turns out that I have build a script that does
> the exact same thing.  I call I thrash_test.  Trying to take down the
> array before it goes in to production. It is a very good test!

It's csh, so people can sue me if they like ;-)

I do a number of things - trying to excercise as much of the hardware at
any ont time as possible - so I'll typically run bonnie on each partition,
and at the same time run a continuous wget to ftp a file into the box, and
a wget from anothe box to ftp a file out (big files, 1GB or so), and run a
loop of make clean ; make -j3 in the kernel build directory too. If I can
do this for a week I'm usually more than happy!!!

If anyone else has good "soaktest" type runes, I'd like to hear them to
add to my collection. (I do run cpuburn too, but I don't think it's a good
representation of "server" work on a modern machine).

> I ran hdpram -t last time the array was up. It states I am running at
> about 200 MB/sec.  I will get you the real number when the array is done
> rebuilding.  currently at 120min left...

hdparn really is quick & dirty. you might want to time a dd of /dev/md? to
/dev/null with varying block sizes and read sizes to get 'raw' streaming
performance.

> Can any one give me more info on this error?  Pulled from
> /var/log/messages.
> "raid6: read error corrected!!"

Not seen that one!!!

Gordon
