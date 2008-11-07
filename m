From: "=?ISO-8859-2?Q?Micha=B3_Przy=B3uski?=" <mikylie@gmail.com>
Subject: Re: Problems with raid6 growing
Date: Fri, 7 Nov 2008 21:42:29 +0100
Message-ID: <6c4602af0811071242p406d6a8bjaaea9a9731e428a8@mail.gmail.com>
References: <6c4602af0811071140m636c8729xf57f57c6a2c393c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0811071140m636c8729xf57f57c6a2c393c6@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm sorry, there's been an error in previous mail. I erroneously used old mdadm
to create the array.

> Additionally, I've tried this with mdadm 2.6.7, it goes as follows,
>
> [root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --zero-superblock
> /dev/loop[012345]
> [root@kylie raid-test]# /sbin/mdadm --create --verbose /dev/md55
> --chunk=256 -l 6  --raid-devices=4 /dev/loop0 /dev/loop1 /dev/loop2
> /dev/loop3
> mdadm: layout defaults to left-symmetric
> mdadm: size set to 24832K
> mdadm: array /dev/md55 started.
> [root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --add /dev/md55
> /dev/loop4 /dev/loop5
> mdadm: added /dev/loop4
> mdadm: added /dev/loop5
> [root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --grow /dev/md55
> --raid-devices=6
> mdadm: Need to backup 1024K of critical section..
> mdadm: /dev/md55: failed to suspend device.
> [root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --grow /dev/md55
> --raid-devices=6
> mdadm: Need to backup 1024K of critical section..
> mdadm: ... critical section passed.
> [root@kylie raid-test]#

If rerun, really with 2.6.7 --create, it does the "old" behaviour.
That's how it looks:
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --zero-superblock
/dev/loop[012345]
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --create --verbose
/dev/md55 --chunk=256 -l 6  --raid-devices=4 /dev/loop0 /dev/loop1
/dev/loop2 /dev/loop3
mdadm: layout defaults to left-symmetric
mdadm: size set to 24832K
mdadm: array /dev/md55 started.
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --add /dev/md55
/dev/loop4 /dev/loop5
mdadm: added /dev/loop4
mdadm: added /dev/loop5
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --grow /dev/md55
--raid-devices=6
mdadm: Need to backup 1024K of critical section..
mdadm: /dev/md55: failed to suspend device.
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --grow /dev/md55
--raid-devices=6
mdadm: Need to backup 1024K of critical section..

^C

Sorry for the mess up,
Cheers,
Mike
