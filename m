From: "TJ" <tjharrel@eagle.fgcu.edu>
Subject: Re: RAID5 reconfig
Date: Sat, 28 Dec 2002 11:43:25 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000f01c2ae90$3e9c4eb0$6500a8c0@system>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Use with extreme care:
> http://unthought.net/raidreconf/index.shtml

> Someone posted a success story on this list a few weeks ago using a
> pretty big RAID5 volume/array.

> Marco

> PS: Please use the 'Subject' field.

Sorry about that.. Please CC me, I don't seem to be getting any feed from
the list.

Thanks for the link. I've been reading up on others experiences and
documentation seems somewhat thin. Does a mini-HOWTO exist anywhere?
From what I've read, first raidreconf is used to change the array, then
fsck -f is run to check the product, then the file system resize utility
must be used to change the size of the filesystem on the RAID array. Then it
would probably be a good idea to run fsck -f once more. This should be
sufficient to add more disks to a RAID 5 array and enlarge the filesystem to
take advantage of the larger block device. Am I missing anything?

