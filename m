From: David Greaves <david@dgreaves.com>
Subject: Re: assemble vs create an array.......
Date: Fri, 30 Nov 2007 14:26:06 +0000
Message-ID: <47501D7E.7000804@dgreaves.com>
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18255.41044.614676.410107@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Dragos <dragos@mpigani.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 29, dragos@mpigani.org wrote:
>> 2. Do you know of any way to recover from this mistake? Or at least what 
>> filesystem it was formated with.
It may not have been lost - yet.


> If you created the same array with the same devices and layout etc,
> the data will still be there, untouched.
> Try to assemble the array and use "fsck" on it.
To be safe I'd use fsck -n (check the man page as this is odd for reiserfs)


> When you create a RAID5 array, all that is changed is the metadata (at
> the end of the device) and one drive is changed to be the xor of all
> the others.
In other words, one of your 3 drives has just been erased.
Unless you know the *exact* command you used and have the dmesg output to hand
then we won't know which one.

Now what you need to do is to try all the permutations of creating a degraded
array using 2 of the drives and specify the 3rd as 'missing':

So something like:
mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sdb1 /dev/sdc1
mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 missing /dev/sdc1
mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 /dev/sdc1 missing
mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sdb1 /dev/sdd1
mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 missing /dev/sdd1
mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 /dev/sdd1 missing
etc etc

It is important to create the array using a 'missing' device so the xor data
isn't written.

There is a program here: http://linux-raid.osdl.org/index.php/Permute_array.pl
that may help...

David


