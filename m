From: Dragos <dragos@mpigani.org>
Subject: Re: assemble vs create an array.......
Date: Sat, 01 Dec 2007 01:48:07 -0500
Message-ID: <475103A7.3070109@mpigani.org>
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown> <47501D7E.7000804@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47501D7E.7000804@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for your very fast answers.

First I tried 'fsck -n' on the existing array. The answer was that If I 
wanted to check a XFS partition I should use 'xfs_check'. That seems to 
say that my array was partitioned with xfs, not reiserfs. Am I correct?

Then I tried the different permutations:
mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sda1 
/dev/sdb1
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1 missing 
/dev/sdb1
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1 /dev/sdb1 
missing
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sda1 
/dev/sdc1
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1 missing 
/dev/sdc1
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1 /dev/sdc1 
missing
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sdb1 
/dev/sdc1
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 missing 
/dev/sdc1
mount /dev/md0 temp
mdadm --stop --scan

mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 /dev/sdc1 
missing
mount /dev/md0 temp
mdadm --stop --scan

With some arrays mount reported:
    mount: you must specify the filesystem type
and with others:
    mount: Structure needs cleaning

No choice seems to have been successful.
Please let me know of other ideas.

Thank you again,
Dragos

David Greaves wrote:
> Neil Brown wrote:
>   
>> On Thursday November 29, dragos@mpigani.org wrote:
>>     
>>> 2. Do you know of any way to recover from this mistake? Or at least what 
>>> filesystem it was formated with.
>>>       
> It may not have been lost - yet.
>
>
>   
>> If you created the same array with the same devices and layout etc,
>> the data will still be there, untouched.
>> Try to assemble the array and use "fsck" on it.
>>     
> To be safe I'd use fsck -n (check the man page as this is odd for reiserfs)
>
>
>   
>> When you create a RAID5 array, all that is changed is the metadata (at
>> the end of the device) and one drive is changed to be the xor of all
>> the others.
>>     
> In other words, one of your 3 drives has just been erased.
> Unless you know the *exact* command you used and have the dmesg output to hand
> then we won't know which one.
>
> Now what you need to do is to try all the permutations of creating a degraded
> array using 2 of the drives and specify the 3rd as 'missing':
>
> So something like:
> mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sdb1 /dev/sdc1
> mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 missing /dev/sdc1
> mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 /dev/sdc1 missing
> mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sdb1 /dev/sdd1
> mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 missing /dev/sdd1
> mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sdb1 /dev/sdd1 missing
> etc etc
>
> It is important to create the array using a 'missing' device so the xor data
> isn't written.
>
> There is a program here: http://linux-raid.osdl.org/index.php/Permute_array.pl
> that may help...
>
> David
>
>
>   
