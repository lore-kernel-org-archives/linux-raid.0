From: maarten <maarten@ultratux.net>
Subject: Re: adding a disk smaller than the array size
Date: Thu, 14 Oct 2004 00:08:23 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410140008.23084.maarten@ultratux.net>
References: <dff3752704101313303d344fb8@mail.gmail.com> <200410132254.22483.maarten@ultratux.net> <dff375270410131406572e5ec8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dff375270410131406572e5ec8@mail.gmail.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 13 October 2004 23:06, kclair wrote:
> I am using raid 1 - sorry for the incomplete information.
>
> The situation is that the array was comprised of two disks, one
> slightly smaller than the other.  I did need to remove the smaller of
> the disks to fix a partition problem, but now I am unable to add it
> back, presumably because the size of the array grew to the size of the
> larger disk when the smaller disk was removed?

Mmm. That shouldn't happen if it's the exact same disk.  However, maybe the 
size _did_ get just a tiny bit smaller somehow, possibly due to a bad 
sector(?) or due to a different C/H/S(*) mapping than before.  Can you see 
how big the size is exactly using 'fdisk -l' and compare the two drives ?

(*) 16 heads, 400 cylinders may appear to be just as big as 256 heads, 25 
cylinders but in my experience there can be a small difference despite what 
the math says.  Dunno where that comes from (maybe I'm just dreaming).

I've never heard of an array growing out of its own accord, so that can not 
possibly be the reason, AFAIK.

> It is my understanding that the size of the array is not equal to the
> amount of data that is actually on the disks.  Is this not true?

Don't understand what you're saying here, but you build arrays out of 
partitions, and the array doesn't care whether there is data there or not. So 
no, the size of the array is indeed not equal to the data on it.
But that makes no difference, since not the actual used data is mirrored, but 
the entire partition, including any and all unused blocks with it. 

> I tried to resize the array using mdadm, but that did not work (I got
> an error saying the file exists).
>
> The array now only consists of the one larger disk.  If I try to
> reassemble the array with both disks, will the information from the
> larger disk get synced to the other disk?  Or is there something else
> I need to do?

Well... Can you post the output of 'fdisk -l' for both those drives here ?
And maybe throw in a 'cat /proc/mdstat' or 'mdadm --detail /dev/md?' for good 
measure.

And failing everything, you could (maybe) clone the array-disk to the empty 
smaller one, run fsck to fix the partition size (but I'm not totally sure it 
does, so that remains doubtful), reverse the roles of the two disks and then 
add the -now free- larger disk to the array. But that would be a last resort.
I cannot vouch for how md copes with the few missing sectors, and neither how 
the filesystem reacts, so you'd better not try that without good testing.

Maarten

> Thanks,
> Kristina

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

