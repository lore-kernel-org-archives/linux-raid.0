From: "Don Dupuis" <dondster@gmail.com>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Wed, 16 May 2007 22:50:43 -0500
Message-ID: <632b79000705162050w70a2feb1w14919fde6e98818c@mail.gmail.com>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	 <17995.46536.195175.894763@notabene.brown>
	 <632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
	 <632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/16/07, Don Dupuis <dondster@gmail.com> wrote:
> On 5/16/07, Don Dupuis <dondster@gmail.com> wrote:
> > On 5/16/07, Neil Brown <neilb@suse.de> wrote:
> > > On Wednesday May 16, dondster@gmail.com wrote:
> > > ...
> > > >
> > > > The problem arises when I do a drive removal such as sda and then I
> > > > remove power from the system. Most of the time I will have a corrupted
> > > > partition on the md device. Other corruption will be my root partition
> > > > which is an ext3 filesystem. I seem to have a better chance of booting
> > > > a least 1 time with no errors with bitmap turned on, but If I repeat
> > > > the process, I will have corruption as well. Also with bitmap turned
> > > > on, adding the new drive into the md device will take way to too long.
> > > > I only get about 3MB per second on the resync. With bitmap turned off,
> > > > I will get between 10MB to 15MB resync rate. Has anyone else seen this
> > > > behavior, or is this situation is no tested very often? I would think
> > > > that I shouldn't get corruption with this raid  setup and jornaling of
> > > > my filesytems? Any help would be appreciated.
> > >
> > >
> > > The resync rate should be the same whether you have a bitmap or not,
> > > so that observation is very strange.  Can you double check, and report
> > > the contents of "/proc/mdstat" in the two situations.
> > >
> > > You say you have corruption on your root filesystem.  Presumably that
> > > is not on the raid?  Maybe the drive doesn't get a chance to flush
> > > it's cache when you power-off.  Do you get the same corruption if you
> > > simulate a crash without turning off the power. e.g.
> > >    echo b > /proc/sysrq-trigger
> > >
> > > Do you get the same corruption in the raid10 if you turn it off
> > > *without* removing a drive first?
> > >
> > > NeilBrown
> > >
> > Powering off with all drives will not have corruption. When I have a
> > drive missing and the md device does a full resync, I will get the
> > corruption. Usually the md partition table is corrupt or gone. and
> > with the first drive gone it happens more frequently. If the partition
> > table is not corrupt, then the rootfilesystem or one of the other
> > filesystems on the md device will be corrupted. Yes my root filesystem
> > is on the raid device. I will update with the bitmap resync rate stuff
> > later.
> >
> > Don
> >
> Forgot to tell you that I have the drive write cache disabled on all my drives.
>
> Don
>
Here is the /proc/mdstat output doing a recover after adding a drive
to the md device:
unused devices: <none>
-bash-3.1$ cat /proc/mdstat
Personalities : [raid10]
md_d0 : active raid10 sda2[4] sdd2[3] sdc2[2] sdb2[1]
      3646464 blocks 256K chunks 3 near-copies [4/3] [_UUU]
      [>....................]  recovery =  2.6% (73216/2734848)
finish=4.8min speed=9152K/sec

unused devices: <none>
-bash-3.1$ cat /proc/mdstat
Personalities : [raid10]
md_d0 : active raid10 sda2[4] sdd2[3] sdc2[2] sdb2[1]
      3646464 blocks 256K chunks 3 near-copies [4/3] [_UUU]
      [>....................]  recovery =  3.4% (93696/2734848)
finish=4.6min speed=9369K/sec

I am still trying to get where I had the low recover rate with the
bitmap turned on. I will get back with you
Don
