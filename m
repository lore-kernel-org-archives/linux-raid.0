From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH 1/2] md: Inform udev about device removal when stopping
Date: Wed, 17 Feb 2016 12:24:54 +0100
Message-ID: <56C45886.7020200@profitbricks.com>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
 <1455633877-4813-2-git-send-email-sebastian.riemer@profitbricks.com>
 <20160216200553.GA13119@kernel.org> <8760xotmi0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760xotmi0.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

On 16.02.2016 21:43, NeilBrown wrote:
> On Wed, Feb 17 2016, Shaohua Li wrote:
> 
>> On Tue, Feb 16, 2016 at 03:44:36PM +0100, Sebastian Parschauer wrote:
>>> When stopping an MD device, then its device node /dev/mdX may still
>>> exist afterwards or it is recreated by udev. The next open() call
>>> can lead to creation of an inoperable MD device. The reason for
>>> this is that a change event (KOBJ_CHANGE) is announced to udev.
>>> So announce a removal event (KOBJ_REMOVE) to udev instead.
>>>
>>> A change is likely also required in mdadm because of the support
>>> for kernels prior to 2.6.28.
>>
>> I didn't follow why we need the change. Shouldn't the KOBJ_REMOVE event be sent
>> automatically when gendisk is deleted?
>> mddev_put()->mddev_delayed_delete()->md_free()->del_gendisk().
>>
>> Thanks,
>> Shaohua
> 
> For a bit of context: this KOBJ_CHANGE event was added in Oct 2008
> 
> Commit: 934d9c23b4c7 ("md: destroy partitions and notify udev when md array is stopped.")
> 
> At the time, md devices weren't getting removed at all.
> Now they are (I figured out the locking), though they can still come
> back.
> 
> There are still two stages.  The array is stopped, and then the block
> device is destroyed.  It is theoretically possible to stop the array
> without destroying the block device, though I don't think that happens
> in practice.
> 
> So this KOBJ_CHANGE is, I think, technically correct (change from
> "active" to "inactive")  but probably isn't needed any more - not to the
> extent it was at the time.
> 
> There are some annoying races with caused by udev responding (belatedly)
> to events by running programs that open s/dev/mdXX and so automatically
> re-creates the md device.
> The real problem here is not the event or the delays in udev.  It is the
> fact that opening /dev/mdXX transparently creates a device.
> 
> The only way (I know of) to really avoid these races is to use named
> arrays.
> Put
>    CREATE names=yes
> 
> in mdadm.conf.  Then md arrays will be created by writing a name to a
> magic file in /sys.  The arrays have a minor number >=512 and are not
> auto-re-created if the device node is re-opened before udev unlinks it.
> 
> So: the patch might be safe, and might solve a particular problem, but
> it is really just a bandaid.  The best fix is "CREATE named=yes" (and
> use named like "md_home", not "md4".

Older mdadm versions like 3.2.6 have really bad scaling issues as they
search the whole /dev directory with map_dev() for the correct device
and we've hit further issues with the symlinks in /dev/md/. This is why
we've decided to go for the /dev/mdX devices directly as then also the
minor number is clear.

I remember custom commits:
* dev_open: add parameter 'do_map_dev'
* mdopen: don't do 'map_dev' in 'create_mddev' if devname is /dev/mdX

I did a further test: If mdadm and the kernel don't send any uevent when
stopping, then it also works. Might be the best solution.

Cheers,
Sebastian
