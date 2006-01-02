From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: Raid source 2TB limit question + system upgrade plan
Date: Mon, 2 Jan 2006 01:38:48 +0100
Message-ID: <02de01c60f34$e61f12f0$a400a8c0@dcccs>
References: <00fc01c60367$d3b99eb0$0400a8c0@dcccs> <17317.63490.418776.287118@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Few months ago i got one patch from you to let the linear raid handle
>2TB
> > devices.
> > At this point  i not to able to test it, because i dont have money to
buy
> > the upgrade.
> >
> > The question is this:
> >
> > If i switch from i386 to x86_64, the patch will be unneccesary or still
need
> > the kernel, to handle the big drive?
>
> You need it on x86_64 as well, though it you are running 2.6.14 or
> later, the patch is already there.
>
> NeilBrown

Hello, Neil,

Now it is the time to upgrade my system from 8TB to 13.2TB. :-)

(Simple reminder if somebody forget, or missed something:
i use 4 disk node with NBD.
Each nodes are 2TB (11x200GB Raid5) now, and in the concentrator i use one
raid0 to join the nodes to one big raid array.
Some months ago, when i try to build this system, found one limit.
The linear array cannot import the 8TB array, caused by its size.)

I want to ask you, Neil, about possible limitations....

My plan:

I will replace the all 200 GB hdd with new 300GB, + add some new (12.) drive
on each node.
+ i want to backup the existing data to the new space. :-) (or backup some
data if i unable to backup the all of 8TB)

Step 1:
fdisk.
On the new disks, i will create one 200GB partition(part.2.) on the *END* of
the devices (only on 11 device) similar with the original size of the
existing 200GB hdds...
And another one from the beginning, to the next partition.(part.1. ~ 100GB)
(I have found the first problem: [called as #1]
The original 200GB devices partiton starts from the beginning of the device,
and this is only from head 1, and not head 0, caused by MBR.)

Step 2:
I will backup the original nodes to this new raid5 on the end of the
devices.
old md0 = 2TB-64k, new md0 = 2TB
There is no problem. :-)

Step 3:
Join the 4 new  2TB(4x11x200GB) device on the concentrator as md1 (inside
the existing 8TB data), and the another 4 new device(4x12x100GB) as md0
(empty array).
There is some problem, caused by #1.
The new 4x2TB devices is bigger with +64KB, and the raid0's superblock is
"wrong placed".
This is OK, i will use mdadm --build /dev/md1 command to buid an array,
without the superblock. :-)

Step 4:
Copy the most valuable data from md1 to md0
The md1 > md0.
This is OK, the problem is simly mine. :-D (I need to delete....)

Step 5a:
I will delete the partition 2 from all HDD, and resize the partition 1 to
fit the whole drive (300GB).
With this, the nodes will be 3.3TB! (12x300 [-1 raid5])

Step 5b:
Resizing the md0 (raid5 )in the nodes.
If i resize the partitions, the superblock is "wrong placed" again.
It is safe to re-create the raid5 array, with the new size?
In my previos mail with title"where is the spare :-)" i can see, there is
some risk too! :-/
If the newly created raid5 array starts again to using the 12. drive as
spare, it will owerwrite everything!!!

Step 6:
I will recreate the md0 on the concentrator, with the new node size.
(4x3.3TB)

Step 7:
Finally resize(8TB -> 13.2TB) the XFS on the md0 in concentrator.

Done.


I hope, you can say something else than "good luck!" :-D

Thanks,

Janos
(Happy new year! :-)



