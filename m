From: "Janos Haar" <djani22@netcenter.hu>
Subject: questions about softraid limitations
Date: Wed, 14 May 2008 02:34:19 +0200
Message-ID: <002801c8b55a$60e4a360$0404a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list, Neil,

I have worked on a faulty hw raid card data recovery some days before.
The project is already successfully done, but i run into some limitations.

For the best safe way first i have jumperd the drives to readonly mode.

Than try to build an "old fashion" linear arrays from each disks + 64k 
another blockdevice. (for store the superblock)
But the mdadm refused to _build_ the array, because the source scsi drive is 
jumpered to readonly. Why? :-)

I try to build the array with --readonly option, but the mdadm still dont 
understand what i want. (yes, i know, rtfm...)

The next step is:

mdadm --create --assume-clean -l 5 /dev/mdX --raid-disks 5 /dev/....

(And this step is refused too if the drives or some part of the sources are 
readonly.)

Its OK, but what about building a readonly raid 5 array for recovery usage 
only? :-)
And _build_ a degraded-readonly raid 4-5-6 is even better if this will ever 
available....

And i need to set the readonly flag _after_ the --create, but the --create 
+ --assume-clean is logical, and working combination with --readonly.

More additionally, i think the only write the superblocks to the disks, when 
the --readonly flag is cleared.
And more, if the readonly raid 4-5-6 array can handle, and recover the bad 
sectors from the parity infos.... hmmmm... :-)

These little options can be great help for data recovery, and all is safe.

Thanks and regards,

Janos Haar



