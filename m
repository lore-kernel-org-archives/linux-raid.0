From: "Conway S. Smith" <beolach@gmail.com>
Subject: Re: RAID5 to RAID6 reshape?
Date: Sun, 17 Feb 2008 09:18:15 -0700
Message-ID: <20080217091815.0464044d@hardcode42.net>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<20080217143122.36413814@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080217143122.36413814@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 17 Feb 2008 14:31:22 +0100
Janek Kozicki <janek_listy@wp.pl> wrote:
> Beolach said:     (by the date of Sat, 16 Feb 2008 20:58:07 -0700)
> 
> > I'm also interested in hearing people's opinions about LVM / EVMS.
> 
> With LVM it will be possible for you to have several raid5 and
> raid6: eg: 5 HHDs (raid6), 5HDDs (raid6) and 4 HDDs (raid5). Here
> you would have 14 HDDs and five of them being extra - for
> safety/redundancy purposes.
> 
> LVM allows you to "join" several blockdevices and create one huge
> partition on top of them. Without LVM you will end up with raid6 on
> 14 HDDs thus having only 2 drives used for redundancy. Quite risky
> IMHO.
> 

I guess I'm just too reckless a guy.  I don't like having "wasted"
space, even though I know redundancy is by no means a waste.  And
part of me keeps thinking that the vast majority of my drives have
never failed (although a few have, including one just recently, which
is a large part of my motivation for this fileserver).  So I was
thinking RAID6, possibly w/ a hot spare or 2, would be safe enough.

Speaking of hot spares, how well would cheap external USB drives work
as hot spares?  Is that a pretty silly idea?

> It is quite often that a *whole* IO controller dies and takes all 4
> drives with it. So when you connect your drives, always make sure
> that you are totally safe if any of your IO conrollers dies (taking
> down 4 HDDs with it). With 5 redundant discs this may be possible to
> solve. Of course when you replace the controller the discs are up
> again, and only need to resync (which is done automatically).
> 

That sounds scary.  Does a controller failure often cause data loss
on the disks?  My understanding was that one of the advantages of
Linux's SW RAID was that if a controller failed you could swap in
another controller, not even the same model or brand, and Linux would
reassemble the RAID.  But if a controller failure typically takes all
the data w/ it, then the portability isn't as awesome an advantage.
Is your last sentence about replacing the controller applicable to
most controller failures, or just w/ more redundant discs?  In my
situation downtime is only mildly annoying, data loss would be much
worse.

> LVM can be grown on-line (without rebooting the computer) to "join"
> new block devices. And after that you only `resize2fs /dev/...` and
> your partition is bigger. Also in such configuration I suggest you
> to use ext3 fs, because no other fs (XFS, JFS, whatever) had that
> much testing than ext* filesystems had.
> 
> 

Plain RAID5 & RAID6 are also capable of growing on-line, although I
expect it's a much more complex & time-consuming process than LVM.  I
had been planning on using XFS, but I could rethink that.  Have there
been many horror stories about XFS?

> Question to other people here - what is the maximum partition size
> that ext3 can handle, am I correct it 4 TB ?
> 
> And to go above 4 TB we need to use ext4dev, right?
> 

I thought it depended on CPU architecture & kernel version, w/ recent
kernels on 64-bit archs being capable of 32 TiB.  If it is only 4
TiB, I would go w/ XFS.

> oh, right - Sevrin Robstad has a good idea to solve your problem -
> create raid6 with one missing member. And add this member, when you
> have it, next year or such.
> 

I thought I read that would involve a huge performance hit, since
then everything would require parity calculations.  Or would that
just be w/ 2 missing drives?


Thanks,
Conway S. Smith
