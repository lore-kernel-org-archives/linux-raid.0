From: Neil Brown <neilb@suse.de>
Subject: Re: RAID10: near, far, offset -- which one?
Date: Tue, 10 Oct 2006 09:27:55 +1000
Message-ID: <17706.56059.308351.48710@cse.unsw.edu.au>
References: <20061005152321.GA32017@piper.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin f krafft on Thursday October 5
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday October 5, madduck@madduck.net wrote:
> I am trying to compare the three RADI10 layouts with each other.
> Assuming a simple 4 drive setup with 2 copies of each block,
> I understand that a "near" layout makes RAID10 resemble RAID1+0
> (although it's not 1+0).
> 
> I also understand that the "far" layout trades some read performance
> for some write performance, so it's best for read-intensive
> operations, like read-only file servers.
> 
> I don't really understand the "offset" layout. Am I right in
> asserting that like "near" it keeps stripes together and thus
> requires less seeking, but stores the blocks at different offsets
> wrt the disks?
> 
> If A,B,C are data blocks, a,b their parts, and 1,2 denote their
> copies, the following would be a classic RAID1+0 where 1,2 and 3,4
> are RAID0 pairs combined into a RAID1:
> 
>   hdd1  Aa1 Ba1 Ca1
>   hdd2  Ab1 Bb1 Cb1
>   hdd3  Aa2 Ba2 Ca2
>   hdd4  Ab2 Bb2 Cb2
> 
> How would this look with the three different layouts? I think "near"
> is pretty much the same as above, but I can't figure out "far" and
> "offset" from the md(4) manpage.

near=2 would be

   hdd1  Aa1 Ba1 Ca1
   hdd2  Aa2 Ba2 Ca2
   hdd3  Ab1 Bb1 Cb1
   hdd4  Ab2 Bb2 Cb2

offset=2 would be

   hdd1  Aa1 Bb2 Ca1 Db2
   hdd2  Ab1 Aa2 Cb1 Ca2
   hdd3  Ba1 Ab2 Da1 Cb2
   hdd4  Bb1 Ba2 Db1 Da2

far=2 would be

   hdd1  Aa1 Ca1  .... Bb2 Db2
   hdd2  Ab1 Cb1  .... Aa2 Ca2
   hdd3  Ba1 Da1  .... Ab2 Cb2
   hdd4  Bb1 Db1  .... Ba2 Da2

Where the second set start half-way through the drives.

The advantage of far= is that you can easily spread a long sequential
read across the drives.  The cost is more seeking for writes.
offset= can possibly get similar benefits with large enough chunk
size, though I haven't tried to understand all the implications of
that layout.  I added it simply because it is a supported layout in
DDF and I am working towards DDF support.

NeilBrown
