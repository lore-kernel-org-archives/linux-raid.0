From: Yi Zhang <yizhan@redhat.com>
Subject: raid1 (re)-add recovery data corruption
Date: Thu, 30 Jul 2015 07:35:10 -0400 (EDT)
Message-ID: <705099586.901961.1438256110567.JavaMail.zimbra@redhat.com>
References: <543799034.898896.1438255427047.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <543799034.898896.1438255427047.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Xiao Ni <xni@redhat.com>, jes sorensen <jes.sorensen@redhat.com>, Yi Zhang <yizhan@redhat.com>
List-Id: linux-raid.ids

Hi Neil
I observed raid1 data corruption on raid1 test, below is the test env/reproduce steps/log, pls check it.

Kernel-verison: 4.2.0-rc3
Test-steps:
1. First create one 2GB file bigfile
2. Execute below script
#!/bin/bash
Create_Loop()
{
for i in `seq 0 7`;do
        dd if=/dev/zero of=/tmp/$i.tmp bs=1M count=3000 &
done
wait
for i in `seq 0 7`;do
        losetup /dev/loop$i /tmp/$i.tmp
done
}
Prepare()
{
mdadm --create --run /dev/md0 --level 1 --metadata 1.2 --raid-devices 8 /dev/loop[0-7] --chunk 512 --bitmap=internal --bitmap-chunk=64M
mdadm --wait /dev/md0
mkfs.ext4  /dev/md0
mkdir /mnt/fortest
mount /dev/md0 /mnt/fortest
md5sum bigfile  >md5sum1
}
Create_Loop
Prepare
cnt=0
while [ 1 ]; do
        echo "-----------------------------------------------------$cnt"
        cp bigfile /mnt/fortest &
        sleep 10
        mdadm /dev/md0 -f /dev/loop0
        sleep 5
        mdadm /dev/md0 -r /dev/loop0
        while [ 1 ]; do
                if [ $? -ne 0 ];then
                        sleep 5
                        mdadm /dev/md0 -r /dev/loop0
                else
                        break
                fi
        done
        sleep 30
        mdadm /dev/md0 -a /dev/loop0
        wait
        echo "cp done"
        mdadm --wait /dev/md0
        echo "recovery done"
        md5sum /mnt/fortest/bigfile > md5sum2
        tmp1=`awk '{print $1}' ./md5sum1`
        tmp2=`awk '{print $1}' ./md5sum2`
        echo $tmp1 > a
        echo $tmp2 > b
        diff a b                                         //data corruption observed
        if [ $? -ne 0 ]; then
                echo "There are some date corruption, cnt is $cnt"
                exit 1
        fi
        ((cnt++))
        rm -rf /mnt/fortest/bigfile
done


Kernel-Log:
[ 1113.577378] loop: module loaded
[ 1290.190065] md: bind<loop0>
[ 1290.193214] md: bind<loop1>
[ 1290.196387] md: bind<loop2>
[ 1290.199542] md: bind<loop3>
[ 1290.202704] md: bind<loop4>
[ 1290.205854] md: bind<loop5>
[ 1290.209003] md: bind<loop6>
[ 1290.212170] md: bind<loop7>
[ 1290.229799] md: raid1 personality registered for level 1
[ 1290.235946] md/raid1:md0: not clean -- starting background reconstruction
[ 1290.243515] md/raid1:md0: active with 8 out of 8 mirrors
[ 1290.249449] created bitmap (1 pages) for device md0
[ 1290.254927] md0: bitmap initialized from disk: read 1 pages, set 47 of 47 bits
[ 1290.328736] md0: detected capacity change from 0 to 3143630848
[ 1290.335316] md: resync of RAID array md0
[ 1290.339689] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1290.346192] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[ 1290.356702] md: using 128k window, over a total of 3069952k.
[ 1640.101181] md: md0: resync done.
[ 1668.352287] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
[ 1681.845966] md/raid1:md0: Disk failure on loop0, disabling device.
[ 1681.845966] md/raid1:md0: Operation continuing on 7 devices.
[ 1844.296614] md: unbind<loop0>
[ 1844.302013] md: export_rdev(loop0)
[ 1874.363488] md: bind<loop0>
[ 1874.566435] md: recovery of RAID array md0
[ 1874.571006] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1874.577514] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[ 1874.588224] md: using 128k window, over a total of 3069952k.
[ 1889.487210] md: md0: recovery done.


Test Log:
-----------------------------------------------------0
mdadm: set /dev/loop0 faulty in /dev/md0
mdadm: hot removed /dev/loop0 from /dev/md0
mdadm: re-added /dev/loop0
cp done
recovery done
-----------------------------------------------------1
mdadm: set /dev/loop0 faulty in /dev/md0
mdadm: hot removed /dev/loop0 from /dev/md0
mdadm: re-added /dev/loop0
cp done
recovery done
1c1
< c4eddcf325ba5741d37f164750412619
---
> 4444f8bbfb1d22f1731fb5b0c846ef8a
There are some date corruption, cnt is 1



Best Regards,
 Yi Zhang


