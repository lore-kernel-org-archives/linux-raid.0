From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 and data safety?
Date: Tue, 22 Mar 2005 09:26:55 +1100
Message-ID: <16959.18991.327224.545186@cse.unsw.edu.au>
References: <62b0912f05031601131b8daf4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Molle Bestefich on Wednesday March 16
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 16, molle.bestefich@gmail.com wrote:
> Just wondering;
> 
> Is there any way to tell MD to do verify-on-write and
> read-from-all-disks on a RAID1 array?

No.
I would have thought that modern disk drives did some sort of
verify-on-write, else how would they detect write errors, and they are
certainly in the best place to do verify-on-write.
Doing it at the md level would be problematic as you would have to
ensure that you really were reading from the media and not from some
cache somewhere in the data path.  I doubt it would be a mechanism
that would actually increase confidence in the safety of the data.

read-from-all-disks would require at least three drives before there
would be any real value in it.  There would be an enormous overhead,
but possibly that could be justified in some circumstances.  If we
ever implement background-data-checking, it might become relatively
easy to implement this.

However I think that checksum based checking would be more effective,
and that it should be done at the filesystem level.

Imagine a filesystem that could access multiple devices, and where it
kept index information it didn't just keep one block address, but
rather kept two block address, each on different devices, and a strong
checksum of the data block.  This would allow much the same robustness
as read-from-all-drives and much lower overhead.

It is very possibly the Sun's new ZFS filesystem works like this,
though I haven't seen precise technical details.

In summary:
 - you cannot do it now.
 - I don't think md is at the right level to solve these sort of problems.
   I think a filesystem could do it much better. (I'm working on a
   filesystem .... slowly...)
 - read-from-all-disks might get implemented one day. verify-on-write
   is much less likely.

> 
> Apologies if the answer is in the docs.

It isn't.  But it is in the list archives now....

NeilBrown
