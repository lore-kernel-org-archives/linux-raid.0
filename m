From: Alfred Matthews <asm13243546@gmail.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Sat, 18 Mar 2017 14:08:34 -0400
Message-ID: <CAAZLhTcoU232uBs2zcK6TFj67Jru5oeNE_F0T2fQR6Un66OPXA@mail.gmail.com>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
 <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com>
 <87d1djdz8y.fsf@notabene.neil.brown.name> <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've switched to the backup drives which are clones of the first, now,
so destructive operations are ok if necessary. Also signatures will
have changed.

0. Hm. Evidently the system is JHFS instead of HFS+, per the output
below. Unsure if there is separate tooling in Debian.

1. Mount via

mdadm --build /dev/md0 --level=0 -n2 --chunk=512K /dev/sdc2 /dev/sdb2

works just fine. Thanks!

2. I'm still sticking with the non-destructive, non-mount edits for
now. So I can report the following:

hpfsck -v /dev/md0 | cat >> hpfsck_output.txt

yields some stuff probably more enlightening than prior.

*** Checking Volume Header:
This HFS+ volume is not wrapped.
signature       : +H
version         : 4
attributes      : 0X80002100
last_mount_vers : JSFH
reserved        : 11178
create_date     : Mon Oct 15 05:03:21 2012
modify_date     : Sat Mar  4 15:53:51 2017
backup_date     : Thu Dec 31 19:00:00 1903
checked_date    : Sun Oct 14 22:03:21 2012
file_count      : 961818
folder_count    : 192894
blocksize       : 2000
total_blocks    : 732482664
free_blocks     : 30231127
next_alloc      : 517947667
rsrc_clump_sz   : 65536
data_clump_sz   : 65536
next_cnid       : 1885617
write_count     : 348970204
encodings_bmp   : 0X200008B
                  Allocation file
total_size          : 0X5752000
clump_size          : 0X5752000
total_blocks        : 0X2BA9
extents             : (0X1+0X2BA9) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0)
                  Extension file
total_size          : 0X1400000
clump_size          : 0X1400000
total_blocks        : 0XA00
extents             : (0X10BAB+0XA00) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0)
                  Catalog file
total_size          : 0X30800000
clump_size          : 0X18400000
total_blocks        : 0X18400
extents             : (0X96BAB+0XC200) (0X15586D+0XC200) (0+0) (0+0)
(0+0) (0+0) (0+0) (0+0)
                  Attribute file
total_size          : 0X18400000
clump_size          : 0X18400000
total_blocks        : 0XC200
extents             : (0X115AB+0XC200) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0)
                  Start file
total_size          : 0
clump_size          : 0
total_blocks        : 0
extents             : (0+0) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0) (0+0)
Reserved attribute in use: 2000
Reserved attribute in use: 80000000
Volume was last Mounted by unknnown implemenatation:
JSFH
Invalid total blocks 2BA8CC68, expected 0 Done ***
*** Checking Backup Volume Header:
Unexpected Volume signature '  ' expected 'H+'

There is also the following on stderr

hpfsck: hpfsck: error writing to medium (Bad file descriptor)

Al.

On 18 March 2017 at 13:11, Alfred Matthews <asm13243546@gmail.com> wrote:
> Sorry for the delay. Thanks for the reply.
>
> You're correct, there is no hardware RAID in the available lsdrv; I've
> removed each drive from its housing in the controller because it's
> Thunderbolt-only, Thundderbolt is borked on OSX here, and I'm rescuing
> on Linux. I appreciate your diagnosis and will try, and will write
> back.
>
> On 14 March 2017 at 22:56, NeilBrown <neilb@suse.com> wrote:
>> On Tue, Mar 14 2017, Alfred Matthews wrote:
>>
>>>> Does
>>>>   dmraid -b /dev/sda /dev/sdb /dev/sdc
>>>> tell you anything useful?
>>>>
>>>
>>> # dmraid -b /dev/sdb /dev/sdc
>>> /dev/sdc:   5860533168 total, "WD-WCAWZ2927144"
>>> /dev/sdb:   5860533168 total, "WD-WCAWZ2939730"
>>
>>
>> No, not useful.
>>
>> Your other output also doesn't show anything interesting.
>> I had another look at the lsdrv output you showed before and I'm
>> wondering if there really is anything "hardware RAID" here at all.
>>
>> Both drives (sdb and sdc) are partitioned into a 200MB EFI partition, a
>> 2.75TB hfsplus (Apple file system) / unknown partition, and a 128M
>> hfsplus boot partition.
>>
>> Maybe the two 2.75TB paritions were raided together.
>> sdc looks like the "first" device if this were the case.
>> Try:
>>
>>   mdadm --build /dev/md0 --level=0 -n2 --chunk=512M /dev/sdc2 /dev/sdb2
>>
>> Then try fsck.hfs of hpfsck ... in the "hfsplus" package on Debian.
>>  hpfsck /dev/md0
>> maybe.
>>
>> NeilBrown
>
>
>
> --
>
> Alfred S. Matthews
>
> Software, Visuals, Music
>
> Atlanta, Georgia, US
>
> +1.337.214.4688



-- 

Alfred S. Matthews

Software, Visuals, Music

Atlanta, Georgia, US

+1.337.214.4688
