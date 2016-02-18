From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: mdadm regression tests, slight progress
Date: Thu, 18 Feb 2016 14:20:27 -0500
Message-ID: <wrfjoabdygec.fsf@redhat.com>
References: <56C4F8A4.2080909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C4F8A4.2080909@gmail.com> (Bruce Dubbs's message of "Wed, 17
	Feb 2016 16:48:04 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Dubbs <bruce.dubbs@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bruce Dubbs <bruce.dubbs@gmail.com> writes:
> I'm still trying to figure out why some of the mdadm regression tests
> fail.  I started looking at tests/00raid1:
>
> # ./test --tests=00raid1
>
> It is nice that ./test is a bash script so it is easy to do some debugging.
>
> The test script looks like:
>
> # create a simple mirror
> # test version0, version1, and no super
> # test resync and recovery.
>
> mdadm -CR $md0 -l 1 -n2 $dev0 $dev1
> check resync
> check raid1
> testdev $md0 1 $mdsize1a 64
> mdadm -S $md0
>
> # now with version-0.90 superblock, spare
> mdadm -CR $md0 -e0.90 --level=raid1 -n3 -x2 $dev0 missing missing $dev1 $dev2
> check recovery
> check raid1
> testdev $md0 1 $mdsize0 64
> mdadm -S $md0
>
> # now with no superblock
> mdadm -B $md0 -l mirror  -n2 $dev0 $dev1
> check resync
> check raid1
> testdev $md0 1 $size 1
> #### Point 1
> mdadm -S $md0
>
> # again, but with no resync
> mdadm -B $md0 -l 1 --assume-clean -n2 $dev0 $dev1
> check raid1
> check nosync
> testdev $md0 1 $size 1
> mdadm -S $md0
> exit 0
>
> What I did was add a couple of 'cat /proc/mdstat' commands where the
> script was failing.  At Point 1 above, I got:
>
> ++ cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
> md127 : inactive md0[0](S)
>       19904 blocks
>
> md0 : active raid1 loop1[1] loop0[0]
>       20000 blocks super non-persistent [2/2] [UU]
>       [==>..................]  resync = 12.5% (2688/20000)
> finish=0.1min speed=2688K/sec
>
>
> The line with resync looked suspicious so at that point I added a
> 'sleep 10' command.  The test now passes.
>
> The full log is at
> http://anduin.linuxfromscratch.org/~bdubbs/files/mdadm-test1.log
>
> Does anyone know what is going on to need this sleep in order for this
> test to pass?

It sounds to like the thing hangs if you try to stop the array before
the resync completes. That could be a race in the kernel code.

Jes
