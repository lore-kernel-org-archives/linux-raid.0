From: Dragos <dragos@mpigani.org>
Subject: Re: assemble vs create an array.......
Date: Thu, 06 Dec 2007 10:17:49 -0500
Message-ID: <4758129D.40600@mpigani.org>
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown> <47501D7E.7000804@dgreaves.com> <475552D2.4000802@mpigani.org> <47568DE1.1050108@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47568DE1.1050108@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you.
I want to make sure I understand.

1- Does it matter which permutation of drives I use for xfs_repair (as 
long as it tells me that the Structure needs cleaning)? When it comes to 
linux I consider myself at intermediate level, but I am a beginner when 
it comes to raid and filesystem issues.

2- After I do it, assuming that it worked, how do I reintegrate the 
'missing' drive while keeping my data?

Thank you for you time.
Dragos


David Greaves wrote:
> Dragos wrote:
>   
>> Thank you for your very fast answers.
>>
>> First I tried 'fsck -n' on the existing array. The answer was that If I
>> wanted to check a XFS partition I should use 'xfs_check'. That seems to
>> say that my array was partitioned with xfs, not reiserfs. Am I correct?
>>
>> Then I tried the different permutations:
>> mdadm --create /dev/md0 --raid-devices=3 --level=5 missing /dev/sda1
>> /dev/sdb1
>> mount /dev/md0 temp
>> mdadm --stop --scan
>>
>> mdadm --create /dev/md0 --raid-devices=3 --level=5 /dev/sda1 missing
>> /dev/sdb1
>> mount /dev/md0 temp
>> mdadm --stop --scan
>>
>>     
> [etc]
>
>   
>> With some arrays mount reported:
>>   mount: you must specify the filesystem type
>> and with others:
>>   mount: Structure needs cleaning
>>
>> No choice seems to have been successful.
>>     
>
> OK, not as good as you could have hoped for.
>
> Make sure you have the latest xfs tools.
>
> you may want to try xfs_repair and you can use the -n (I think - check man page)
> option.
>
> You may need to force it to ignore the log
>
> David
>
>
>
>   
