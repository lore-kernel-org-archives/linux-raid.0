From: NeilBrown <neilb@suse.com>
Subject: Re: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Thu, 25 Jun 2015 11:33:35 +1000
Message-ID: <20150625113335.7bf72b0b@noble>
References: <3700381434301996@web21o.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3700381434301996@web21o.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: tlknv <tlknv@yandex.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Jun 2015 20:13:16 +0300 tlknv <tlknv@yandex.ru> wrote:

> Hello,

> I have raid 1 which mirrors a root/boot partition on 1SSD and 2HDD
> (write-mostly). mismatch_cnt goes up even when there are very few
> writes to the partition as /var is mounted separatly. After I update
> several packages I typically see mismatch_cnt somewhere between
> 500,000 and 2,000,000. I have read a number of threads in this DL
> but could not find an explanation of what could cause mismatch_cnt
> to grow that much. I checked md5 sums using
> /var/lib/dpkg/info/*.md5sums, and didn't see many errors, even
> though there are few, mostly in text files which look ok to me. I
> guess when I check, all reads go to SSD (as both HDDs in this raid
> are write-mostly), and thus md5sum only shows no problem on
> SSD. Note, this partition is used as both boot and root and just in
> case here is some more info about my system:

This does surprise me.

I had another look at the code and there could be a bug that would let
'check' see the difference between when the first write completes and
when the write-behind writes complete, but you would need to run the
check while the install was happening for that to be noticed, and even
then you would need to be unlucky.

What you could try is:
 - add a bitmap (mdadm --grow /dev/md0 --bitmap=internal) so that
   recovery will be fast if you remove then re-add a device.
 - fail and remove one of the HDDs
     mdadm /dev/md0 --fail /dev/sda2
     mdadm /dev/md0 --remove /dev/sda2
 - Find the data offset and use losetup to access the data directly.
    mdadm --examine /dev/sda2 | grep 'Data Offset'
        Data Offset : 160 sectors.
   convert that to 'K' and
    losetup --read-only --offset=80K /dev/loop0 /dev/sda2
 - perform some *read-only* examintion of loop0.
    fsck -n /dev/loop0
    mount -o ro /dev/loop0 /mnt

   and see if there are any differences in files that have changed
   recently.

 - when finished, "umount /mnt", "losetup -d /dev/loop0" and
     mdadm /dev/md0 --re-add /dev/sda2



> root@tbeh:~# sync; cmp -l /dev/sdc2 /dev/sda2|wc -l
> cmp: EOF on /dev/sdc2
> 1903215
> 
> BTW, only first few hundren bytes (at most) have non-zero value on SSD, the rest of differences has 0 bytes on SSD.
>                4233   0 347
>                4234  70  65
>                4235 232 241
>                4257   0   1

Any bytes before the "Data Offset" identified above could easily be
different, or after "Data Offset" + "Used Dev Size".
What bytes are different within that range/

NeilBrown
