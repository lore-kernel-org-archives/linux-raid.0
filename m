From: Alberto Morell <amp4tj@gmail.com>
Subject: Re: Unable to re-assemble a raid 10 after it has FAILED.
Date: Wed, 11 Jun 2014 09:24:18 +0200
Message-ID: <CAEp9EKjcckfJ0Az+-CAU=i+xW=DzsQ_m5r20fOSWJuj9KVw2oQ@mail.gmail.com>
References: <CAEp9EKjgt1RTkYzhSX-UQN2-WhV3iCKPr_DTnHN_KmorvFNsvg@mail.gmail.com>
	<CAEp9EKg462T+7E35RnarP6y41wGgNv3R_jAXEhxiLBg_vukW3g@mail.gmail.com>
	<20140610213044.4b6a7996@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140610213044.4b6a7996@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 10, 2014 at 1:30 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 10 Jun 2014 13:04:28 +0200 Alberto Morell <amp4tj@gmail.com> wrote:
>
>> Hi!
>>
>> I have a raid 10 devices with 4 components. I make the raid fails, by
>> making two components fail (using "mdadm --set-faulty <device>"). When
>> I add the two devices back, they are added as spare devices. Then, I
>> can get the raid active again only creating the raid again using
>> "mdadm --create --assume-clean...". Re-assembling the device does not
>> work with error message:
>>
>> mdadm: failed to RUN_ARRAY /dev/md/hdd: Input/output error
>> mdadm: Not enough devices to start the array.
>>
>> I am trying to automate the raid configuration and the "mdadm --create
>> ..." option is not convenient as I would have to know all the creation
>> parameters.
>>
>> Below is the command sequence.
>>
>> Thanks is advance,
>>
>> Alberto Morell.
>>
>>
>> [root@os2 raid_tools]# mdadm --version
>> mdadm - v3.2.6 - 25th October 2012
>>
>> [root@os2 ~]# mdadm --create /dev/md/hdd --metadata=1.0 --auto=md --name=hdd \
>> --chunk=256 --bitmap=internal --bitmap-chunk=65536 --level=raid10 --run \
>> --raid-devices=4 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
>>
>> [root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sde1
>> mdadm: set /dev/sde1 faulty in /dev/md/hdd
>> [root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sdf1
>> mdadm: set /dev/sdf1 faulty in /dev/md/hdd
>
> So now your array is dead.  I assume you expected this.
>

>>
>> [root@os2 ~]# mdadm --remove /dev/md/hdd /dev/sde1
>> mdadm: hot removed /dev/sde1 from /dev/md/hdd
>> [root@os2 ~]# mdadm --remove /dev/md/hdd /dev/sdf1
>> mdadm: hot removed /dev/sdf1 from /dev/md/hdd
>> [root@os2 ~]# mdadm --add /dev/md/hdd /dev/sde1
>> mdadm: re-added /dev/sde1
>> [root@os2 ~]# mdadm --add /dev/md/hdd /dev/sdf1
>> mdadm: re-added /dev/sdf1
>
> Adding good things to dead things doesn't make the dead thing undead.
> You don't want to do this.
>
> If and array is dead, the best thing to do is to stop it, before trying to
> re-add anything, and (after checking the all the devices are really working)
> assemble with --force.
> That is the best way to breath life into a dead array.
>
> NeilBrown

That sequence solved the problem:
1. After the array is dead, stop it

[root@os2 raid_tools]# mdadm --stop /dev/md127
mdadm: stopped /dev/md127

2. Then, assemble the array with the proper components.

[root@os2 raid_tools]# mdadm --assemble /dev/md/hdd --force --run
--uuid=085d48f6:e6e38d1c:a476006f:cd3a3e51 --verbose /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1

The array started with only three components, but then I added the
fourth just with a "mdadm --add"

(Before, I was first re-adding the failed components, and after that,
stopping and re-assembling the array)

Thanks a lot!

Alberto Morell.
