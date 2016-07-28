From: yizhan <yizhan@redhat.com>
Subject: Re: test file disappeared after -f, -r, --add-journal for
 write-journal device
Date: Thu, 28 Jul 2016 15:04:23 +0800
Message-ID: <22a737af-1ad8-94ce-de31-abdb9c6187d4@redhat.com>
References: <678915290.9410266.1469620858173.JavaMail.zimbra@redhat.com>
 <1403590832.9411207.1469621239264.JavaMail.zimbra@redhat.com>
 <20160728012225.GB48473@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160728012225.GB48473@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids



On 07/28/2016 09:22 AM, Shaohua Li wrote:
> On Wed, Jul 27, 2016 at 08:07:19AM -0400, Yi Zhang wrote:
>> Hello maintainer
>>
>> Here is another strange phenomenon I found after do -f, -r, --add-journal for write-journal device.
>>
>> Kernel version: 4.7.0-rc7
>> Steps I used:
>> mdadm --create --run /dev/md0 --level 4 --metadata 1.2 --raid-devices 7 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6 /dev/loop7 --write-journal /dev/loop0 --bitmap=internal --bitmap-chunk=64M --chunk 512
>> mdadm --wait /dev/md0
>> mkfs.ext4 /dev/md0
>> mount -t ext4 /dev/md0 /mnt/fortest
>> cp bigfile /mnt/fortest &
>> wait
>> md5sum /mnt/fortest/bigfile > md5sum3
>> mdadm /dev/md0 -f /dev/loop0
> since loop0 is the journal device and it fails, we will mark the md0 readonly
> at this point. Filesystem can't do any write. It's possible the fortest/md5sum3
> files not hit disk yet, and are lost. I think your test should do a sync before
> mark journal disk failure.
I add sync operation before mark journal disk failure, this issue cannot 
be reproduced any more,

thanks
Yi
>> mdadm /dev/md0 -r /dev/loop0
>> umount /dev/md0 -l
>> mdadm -o /dev/md0
>> mdadm /dev/md0 --add-journal /dev/loop0
>> mdadm --wait /dev/md0
>> mdadm -D /dev/md0
>> mount /dev/md0 /mnt/fortest
>> md5sum /mnt/fortest/bigfile > md5sum2   #<----this test file disappeared
> If a sync is done before journal disk fails and you still see the file
> disappeared, it's a bug.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

