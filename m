From: "Don Dupuis" <dondster@gmail.com>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Wed, 16 May 2007 21:57:42 -0500
Message-ID: <632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	 <17995.46536.195175.894763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17995.46536.195175.894763@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/16/07, Neil Brown <neilb@suse.de> wrote:
> On Wednesday May 16, dondster@gmail.com wrote:
> ...
> >
> > The problem arises when I do a drive removal such as sda and then I
> > remove power from the system. Most of the time I will have a corrupted
> > partition on the md device. Other corruption will be my root partition
> > which is an ext3 filesystem. I seem to have a better chance of booting
> > a least 1 time with no errors with bitmap turned on, but If I repeat
> > the process, I will have corruption as well. Also with bitmap turned
> > on, adding the new drive into the md device will take way to too long.
> > I only get about 3MB per second on the resync. With bitmap turned off,
> > I will get between 10MB to 15MB resync rate. Has anyone else seen this
> > behavior, or is this situation is no tested very often? I would think
> > that I shouldn't get corruption with this raid  setup and jornaling of
> > my filesytems? Any help would be appreciated.
>
>
> The resync rate should be the same whether you have a bitmap or not,
> so that observation is very strange.  Can you double check, and report
> the contents of "/proc/mdstat" in the two situations.
>
> You say you have corruption on your root filesystem.  Presumably that
> is not on the raid?  Maybe the drive doesn't get a chance to flush
> it's cache when you power-off.  Do you get the same corruption if you
> simulate a crash without turning off the power. e.g.
>    echo b > /proc/sysrq-trigger
>
> Do you get the same corruption in the raid10 if you turn it off
> *without* removing a drive first?
>
> NeilBrown
>
Powering off with all drives will not have corruption. When I have a
drive missing and the md device does a full resync, I will get the
corruption. Usually the md partition table is corrupt or gone. and
with the first drive gone it happens more frequently. If the partition
table is not corrupt, then the rootfilesystem or one of the other
filesystems on the md device will be corrupted. Yes my root filesystem
is on the raid device. I will update with the bitmap resync rate stuff
later.

Don
