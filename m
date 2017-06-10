From: Paul Tonelli <paul@tonel.li>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Sat, 10 Jun 2017 22:04:16 +0200
Message-ID: <5f9ed8be-ec90-17bc-3e45-0721689a62a8@tonel.li>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
 <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
 <20170605235619.GA8478@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170605235619.GA8478@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Everybody,

tl dr: I found the --data-offset to allow a e2fsck, but things are not 
as they should be. I still manage to get back data (pictures which are 
 >= 4Mb in size).

On 06/06/2017 01:56 AM, Andreas Klauer wrote:
> On Tue, Jun 06, 2017 at 01:24:41AM +0200, Paul Tonelli wrote:
>> mdadm --create /dev/md0 --level=5 --assume-clean --raid-devices=3 missing /dev/mapper/sdd /dev/mapper/sdb
> You did not specify the --data-offset here?
> Check mdadm --examine to make sure which offset it's using.
The objective was just to reverse the /dev/sdc destruction using the xor 
on /dev/sdb and /dev/sdc, I believe the default offset is earlier than 
the one I specify by hand.
>> xxd -u /dev/mapper/sdc | grep  -C 3 'LABELONE'
>>   >7f001e0: 0000 0000 0000 0000 0000 0000 0000 0000 ................
>>   >7f001f0: 0000 0000 0000 0000 0000 0000 0000 0000 ................
>>   >7f00200: 4C41 4245 4C4F 4E45 0100 0000 0000 0000 LABELONE........
> If correct this should appear at the start of /dev/md0 (even w/o adding sdc).
>
> LABELONE should appear on the first drive so this should not be wrong,
> however the sdd sdb could still have switched  order, and of course
> the chunk size could be different (although unlikely according to your log).
Even after rebuilding the disks, I find the LABELONE at 7f00200. But it 
does not provide a recoverable LVM / ext4 filesystem (the backup 
superblock offset is incorrect for this partition size)
>> I believe you are right, the issue is still the raid: I have tried
>> photorec and most files I have opened look like they have been
>> truncated.
> Well, files could be fragmented, there's a certain sweet spot
> (like - megapixel JPEGs of few megs size) where it's sufficiently
> unlikely to be a problem.
>
> I don't know what files you have, if it's movies it would be okay
> too if the first few megs of the file were playable.
I have multiple assemblies with a custom data-offset in which a e2fsck 
agrees to run from a backup superblock (I have brute forced the tests)

the possible assemblies are (offset, disk order):

261120 missing /dev/mapper/sdc /dev/mapper/sdd
261120 missing /dev/mapper/sdd /dev/mapper/sdc
261120 /dev/mapper/sdb missing /dev/mapper/sdd
261120 /dev/mapper/sdb /dev/mapper/sdd missing

I have already found bmp/png which are > 4MB by using photorec, so I 
think I am going forward.

Right now, I am running e2fsck -n to see which order returns the least 
errors, I will then try to  get back as many files as I can, still using 
overlay.

>> - apart from the raid superblock, the disks I use (sdd and sdb) have not
>> been erased  (as sdc is rebuilt from xor)
> It only rebuilds starting from offset. So it should not have covered that
> offset if you did not specify it. Check it's not there before you --add.
> If it's there then this is after all not the drive you overwrite with dd?
I believe the offset we manually specify is after the default one on a 
raid assembly with 3 disks, so it should have rebuilt the previous LVM 
superblock, or am I missing something (again).
> I am confused now.
So am I, and I am afraid I have used all the time I could spend to get 
this data back. Thanks to your help, I can still recover many files, 
even if it is not a full filesystem :-). Thank you !

Paul


