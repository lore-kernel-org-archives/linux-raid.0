From: "Lucas Albers" <admin@cs.montana.edu>
Subject: Re: create failed raid5 disk with mdadm
Date: Fri, 28 May 2004 17:47:07 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1736.153.90.196.102.1085788027.squirrel@web1.cs.montana.edu>
References: <Pine.LNX.4.44.0405281445550.25012-100000@signals10.bu.edu><1087.153.90.196.102.1085772526.squirrel@web1.cs.montana.edu>
    <16567.48996.202819.382152@cse.unsw.edu.au>
Reply-To: admin@cs.montana.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16567.48996.202819.382152@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown said:

> That certainly should work, and I just tried it and it did.
>
> Could you describe the way in which it failed to work for you?

So I zero the superblock and do the create, and get this error:
comp3:~# mdadm --zero-superblock /dev/hde4 /dev/hdf4 /dev/hdg4 /dev/hdh4

mdadm -v --create /dev/md4 --level=5 --raid-disks=4 /dev/hde4 /dev/hdf4
/dev/hdg4 /dev/hdh4

I was at the console when it happened, it indicated  a could not access
error.

When I ran zero-superblock twice, and then tried it again it worked flawless.
At least I know the correct syntax. Thanks.


-- 
Luke Computer Science System Administrator

