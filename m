From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Mon, 29 Oct 2007 09:41:18 +0100
Message-ID: <20071029084118.GC15475@percy.comedia.it>
References: <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com> <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com> <20071026095417.GC32550@percy.comedia.it> <1193424779.10336.287.camel@firewall.xsintricity.com> <20071026223046.GB8210@boogie.lpds.sztaki.hu> <1193531160.10336.397.camel@firewall.xsintricity.com> <20071028141336.GC22861@percy.comedia.it> <1193593675.10336.404.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193593675.10336.404.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 28, 2007 at 01:47:55PM -0400, Doug Ledford wrote:
>On Sun, 2007-10-28 at 15:13 +0100, Luca Berra wrote:
>> On Sat, Oct 27, 2007 at 08:26:00PM -0400, Doug Ledford wrote:
>> >It was only because I wasn't using mdadm in the initrd and specifying
>> >uuids that it found the right devices to start and ignored the whole
>> >disk devices.  But, when I later made some more devices and went to
>> >update the mdadm.conf file using mdadm -Eb, it found the devices and
>> >added it to the mdadm.conf.  If I hadn't checked it before remaking my
>> >initrd, it would have hosed the system.  And it would have passed all
>> the above is not clear to me, afair redhat initrd still uses
>> raidautorun,
>
>RHEL does, but this is on a personal machine I installed Fedora an and
>latest Fedora has a mkinitrd that installs mdadm and mdadm.conf and
>starts the needed devices using the UUID.  My first sentence above
>should have read that I *was* using mdadm.
ah, ok i should look again at fedora's mkinitrd, last one i checked was
6.0.9-1 and i see mdadm was added in 6.0.9-2

>>  which iirc does not works with recent superblocks,
>> so you used uuids on kernel command line?
>> or you use something else for initrd?
>> why would remaking the initrd break it?
>
>Remaking the initrd installs the new mdadm.conf file, which would have
>then contained the whole disk devices and it's UUID.  There in would
>have been the problem.
yes, i read the patch, i don't like that code, as i don't like most of
what has been put in mkinitrd from 5.0 onward.
Imho the correct thing here would not have been copying the existing
mdadm.conf but generating a safe one from output of mdadm -D (note -D,
not -E)

>> >the tests you can throw at it.  Quite simply, there is no way to tell
>> >the difference between those two situations with 100% certainty.  Mdadm
>> >tries to be smart and start the newest devices, but Luca's original
>> >suggestion of skip the partition scanning in the kernel and figure it
>> >out from user space would not have shown mdadm the new devices and would
>> >have gotten it wrong every time.
>> yes, in this particular case it would have, congratulation you found a new
>> creative way of shooting yourself in the feet.
>
>Creative, not so much.  I just backed out of what I started and tried
>something else.  Lots of people do that.
>
>> maybe mdadm should do checks when creating a device to prevent this kind
>> of mistakes.
>> i.e.
>> if creating an array on a partition, check the whole device for a
>> superblock and refuse in case it finds one
>> 
>> if creating an array on a whole device that has a partition table,
>> either require --force, or check for superblocks in every possible
>> partition.
>
>What happens if you add the partition table *after* you make the whole
>disk device and there are stale superblocks in the partitions?  This
>still isn't infallible.
It depends on what you do with that partitioned device *after* having
created the partition table.
- If you try again to run mdadm on it (and the above is implemented it
would fail, and you will be given a chance to wipe the stale sb)
- If you don't and use them as plain devices, _and_ leave the line in
mdadm.conf you will suffer a lot of pain. Since the problem is known and
since fdisk/sfdisk/parted already do a lot of checks on the device, this
could be another useful one.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
