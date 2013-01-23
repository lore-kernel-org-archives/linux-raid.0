From: "dan1" <dan1@edenpics.com>
Subject: Re: mdadm grow size gives device or resource busy error
Date: Wed, 23 Jan 2013 22:35:42 +0100
Message-ID: <3FFD0C1E3D0D4A969877A80BF263F51F@home>
References: <64E2AC3E84D143EC9C257EA4BB2DB1FE@home> <CAANkY-=ZDA1y4fTmZSw_X4EbD_XfsVVH_hUd5RWL1pTcv1OYiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ionut Cadariu <ionut.cadariu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Ionut for this suggestion.

You are right, it works if we reassemble the array from a Live CD and then 
only shrink with --grow --size, thanks for the tip.
However, this seems to show that there is a bug in the way mdadm handles 
this --grow --size, because in my procedure I was first unmounting the 
array, thus the command should have been worked.

It is like if mdadm thinks that the array is still mounted even if it is not 
and no files are accessed anymore. Also that is strange because when I mount 
and unmount the array from the LiveCD, the grow command still work, whereas 
when trying from the machine's OS where the array was created, it doesn't 
work.

Can someone else confirm this bug and would it be possible to solve it?

Thanks,
Daniel


>I had this problems too...the fix i have found was to use a Live CD,
>rebuild array and then shrink...but maybe someone have a better idea.

>>
>>On Tue, Jan 15, 2013 at 11:09 PM, dan1 <dan1@edenpics.com> wrote:
>>
>>Hi,
>>
>>
>>I am trying to shrink an md partition to lower its size but that fails
>>with
>>an error message.
>>
>>My context is the following:
>>/dev/md2 has 3 partitions: /dev/sdb3; /dev/sdc3; /dev/sdd3
>>The array is 480 Gbytes big (only 30 Gbytes used).
>>I want to resize it to 100Gbytes (hosting company only allows that size).
>>
>>Following a procedure, I first resize the partition to 70Gbytes to let
>>some
>>space:
>>umount /dev/md2
>>e2fsck /dev/md2
>>resize2fs /dev/md2 70G
>>
>>Then, I disable the bitmap:
>>mdadm --grow /dev/md2 --bitmap none
>>And I shrink the array to 100Gbytes (201x512x1024):
>>mdadm --grow /dev/md2 --size=105381888
>>
>>Doing this, it produces the following error message:
>>mdadm: Cannot set size on array members.
>>mdadm: Cannot set device size for /dev/md2: Device or resource busy
>>
>>If I look at the messages with "dmesg | tail" there is no error message
>>due
>>to that manipulation.
>>Some things to check:
>>1. No rebuild is in progress (with cat /proc/mdstat): OK
>>2. The array is unmounted: OK
>>3. The proble doesn't come from the bitmap as it has been disabled before.
>>OK
>>4. Opened files related to the md2 device are the following:
>>lsof | grep md2
>>md2_raid1    403    root    cwd    DIR    9,91    4096    2 /
>>md2_raid1    403    root    rtd      DIR    9,91    4096    2 /
>>md2_raid1    403    root    txt  unknown                        /
>>proc/403/exe
>>
>>I don't know if this is ok or not but I assume it is fine as I didn't
>>mount
>>the array and didn't put any file on it in this session.
>>
>>The versions of my system are the following:
>>Linux CentOS 6.3
>>mdadm V3.2.3
>>
>>Thanks for any help.
>>
>>Daniel
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>>-- 
>>Best regards,
>>Ionut

