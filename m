From: "dan1" <dan1@edenpics.com>
Subject: mdadm grow size gives device or resource busy error
Date: Tue, 15 Jan 2013 22:09:44 +0100
Message-ID: <64E2AC3E84D143EC9C257EA4BB2DB1FE@home>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to shrink an md partition to lower its size but that fails with
an error message.

My context is the following:
/dev/md2 has 3 partitions: /dev/sdb3; /dev/sdc3; /dev/sdd3
The array is 480 Gbytes big (only 30 Gbytes used).
I want to resize it to 100Gbytes (hosting company only allows that size).

Following a procedure, I first resize the partition to 70Gbytes to let some
space:
umount /dev/md2
e2fsck /dev/md2
resize2fs /dev/md2 70G

Then, I disable the bitmap:
mdadm --grow /dev/md2 --bitmap none
And I shrink the array to 100Gbytes (201x512x1024):
mdadm --grow /dev/md2 --size=105381888

Doing this, it produces the following error message:
mdadm: Cannot set size on array members.
mdadm: Cannot set device size for /dev/md2: Device or resource busy

If I look at the messages with "dmesg | tail" there is no error message due
to that manipulation.
Some things to check:
1. No rebuild is in progress (with cat /proc/mdstat): OK
2. The array is unmounted: OK
3. The proble doesn't come from the bitmap as it has been disabled before.
OK
4. Opened files related to the md2 device are the following:
lsof | grep md2
md2_raid1    403    root    cwd    DIR    9,91    4096    2 /
md2_raid1    403    root    rtd      DIR    9,91    4096    2 /
md2_raid1    403    root    txt  unknown                        /
proc/403/exe

I don't know if this is ok or not but I assume it is fine as I didn't mount
the array and didn't put any file on it in this session.

The versions of my system are the following:
Linux CentOS 6.3
mdadm V3.2.3

Thanks for any help.

Daniel 

