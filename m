From: Andrew Hogue <hogue@cs.yorku.ca>
Subject: Re: 15% used but "No space left on Device"
Date: Sun, 16 Nov 2003 18:21:08 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0311161816320.12003@nemesis.cs.yorku.ca>
References: <Pine.LNX.4.56.0311161309010.12003@nemesis.cs.yorku.ca>
 <3FB7CE28.6090100@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FB7CE28.6090100@eglifamily.dnsalias.net>
To: linux-raid@vger.kernel.org, Dan Egli <dan@eglifamily.dnsalias.net>
List-Id: linux-raid.ids

Hi again,

Okay, so I ran fsck on the disk and it said that it had errors.  So I
"corrected" them all and everything was fine.

However, now I'm getting a different message that seems related to this
problem.

I have a set of images on this device that I'm trying to encode into a
movie.  So I run my program on it, which simply reads in an image then
adds it to the video file etc...

This is a very large list of images, about 23000 images.

Now, for some reason it works fine up to a point then dies with a bus
error.  I check the dmesg log and low and behold I get the following
message:

attempt to access beyond end of device
09:00: rw=0, want=707399196, limit=488396800

Weird.  I try using display on that file and sometimes it dies and
sometimes it doesn't.  Very unpredictable.

Why would the system 'think' that I'm trying to access outside of my disk
when the file exists and is the correct size?

Any ideas?

Thanks,

-- Andrew




On Sun, 16 Nov 2003, Dan Egli wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Andrew Hogue wrote:
> | Hi,
> |
> | I just set up 2 hard disks as a striped raid-0 on my system.  They are
> | Serial-ATA 250GB each.  I'm using linux kernel 2.4.22 and the ext2
> | filesystem.
> |
> | The problem I'm encountering happens after using up about 65GB on the
> | raid.  If I do any file-io, i.e. cat > anything.txt , it tells me that
> | there is "no space left on device".
> |
> | I do a df -h and it says that I'm using only 15% of the raid, and that
> | there is 370G free.  I do a df -i to check the inode usage and it says
> | that I'm only using 1% of the inodes.
> |
> | Any ideas?
> |
> | Thanks,
> |
> | -- Andrew
> |
>
> I think depsite what df -i says you are out of inodes. I had a similiar
> problem once. something as simple as dd if=/dev/zero of=myfile count=1
> would fail with out of space. df -i said I was using 2% of the inodes. I
> think df -i reads the total inode count from the partition header, so if
> for whatever reason the system has lost track of inodes the df -i count
> would not reflect that.
>
> Best think I can suggest is to backup the contents, re-run mkfs.ext2 (or
> .ext3 if you want journaling), then copy the files back. That is what I
> did and it worked grand from then on.
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.2 (MingW32)
> Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org
>
> iD8DBQE/t84ntwT22Jak4/4RAsBeAJ9G0Q0edGQ+Jl5f641S4gFyzX+ONwCeNvEd
> +lqE235yoOJV5Q3YcXuCkqs=
> =ic+l
> -----END PGP SIGNATURE-----
>
>
>
