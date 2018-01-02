From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Troubleshooting "Buffer I/O error" on reading md device
Date: Tue, 2 Jan 2018 04:13:48 +0100
Message-ID: <cc833a06-70c9-f979-00b7-4b62e6730c7f@thelounge.net>
References: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1z_MZ4Xqld_IRMUbGJE66v2VUhXkBhlHnWJEfLASWNcv5s3Wo3A1YeuQBJBuksxJtFPpmsPbg1_F8PC3Sj4HrzL6Go3aIanVihzcC-4ZHEQ=@protonmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: RQM <rqm@protonmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 02.01.2018 um 03:46 schrieb RQM:
> I hope this list is the right place to ask the following:
> 
> I've got a 5-disk RAID-5 array that's been built by a QNAP NAS device, which has recently failed (I suspect a faulty SATA controller or backplane).
> I migrated the disks to a desktop computer that runs Debian stretch (kernel 4.9.65-3+deb9u1 amd64) and mdadm version 3.4. Although the array can be assembled, I encountered the following error in my dmesg output ([1], recorded directly after a recent reboot and fsck attempt) when running fsck:
> 
> Buffer I/O error on dev md0, logical block 1598030208, async page read
> 
> I can reliably reproduce that error by trying to read from the md0 device. It's always the same block, also across reboots

i had the same message on my testserver VM running within VMware 
Workstation after upgrade to one of the first 4.14 kernels on Fedora for 
/dev/sdb1 (rootfs) and it went away as it came

in case of a virtual disk faulty hardware is even impossible or at least 
would i expect such message on the underlying raid10 and not in a random 
guest
