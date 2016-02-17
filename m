From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when
 stopping
Date: Wed, 17 Feb 2016 11:31:16 +0100
Message-ID: <56C44BF4.8070301@profitbricks.com>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
 <1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com>
 <wrfjio1oeemz.fsf@redhat.com> <56C36487.3060201@profitbricks.com>
 <56C36D20.6030001@suse.de> <wrfja8n0bi8n.fsf@redhat.com>
 <8737sstmbh.fsf@notabene.neil.brown.name> <wrfjmvr09uvi.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000503020206020009090604"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjmvr09uvi.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, NeilBrown <neilb@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000503020206020009090604
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 16.02.2016 23:02, Jes Sorensen wrote:
> NeilBrown <neilb@suse.com> writes:
>> On Wed, Feb 17 2016, Jes Sorensen wrote:
>>
>>> Hannes Reinecke <hare@suse.de> writes:
>>>> On 02/16/2016 07:03 PM, Sebastian Parschauer wrote:
>>>>> The worst thing that can happen is that the kernel sends the change
>>>>> event after the remove event. Then it is the current situation again.
>>>>>  From my tests mdadm does enough other stuff in between. Udev is able to
>>>>> handle receiving two remove events from my testing. Multiple mdadm
>>>>> instances can't run in parallel any ways. So userspace around it needs
>>>>> some serialization for it any ways. So also stopping an MD device and
>>>>> assembling a new one with the same minor number shouldn't race.
>>>>>
>>>>> I still prefer this solution here. But if you decide to drop the udev
>>>>> event sending in mdadm, then I'm also fine with that.
>>>>>
>>>> I strongly prefer removing the udev event generation altogether.
>>>> As this appears to be a carry-over from older kernels, it looks to me
>>>> as being an incomplete conversion:
>>>> At one point udev introduced 'ONLINE' and 'OFFLINE' events, which were
>>>> supposed to be used for this kind of scenario.
>>>> (ONLINE being a companion to 'ADD', and 'OFFLINE' being the companion
>>>> to 'DELETE'). However, later the 'ONLINE' got modified to 'CHANGE',
>>>> and the 'OFFLINE' got dropped completely.
>>>> Or that was the plan.
>>>> So it looks as if the conversion to 'CHANGE' got applied to the
>>>> 'OFFLINE' event, too.
>>>> Hence I strongly recommend to drop it completely, and let the kernel
>>>> or the MD module decide if and when a uevent should be send.
>>>
>>> I am totally fine with this, however we should make mdadm fail if run
>>> against a pre-2.6.28 kernel then.
>>>
>>> Cheers,
>>> Jes
>>
>> I would suggest protecting the
>>
>> 	if (fd >= 0)
>> 		ioctl(fd, BLKRRPART, 0);
>> 	if (mdi)
>> 		sysfs_uevent(mdi, "change");
>>
>> code with
>>
>>    if (get_linux_version() < 2006028)
>>
>> That should be completely safe - 2.6.28 and later do this (if needed).
> 
> Seems a better fix to me. I much prefer the duplicated events.
> 
> Sebastian, does this patch resolve the problem for you? If nobody
> hollors, I will push this into mdadm.

I've tested this on top of mdadm-3.4 and with vanilla kernel 4.5.0-rc3.
The device nodes are still there. I guess this is because of the change
event from the kernel. This confirms my former tests.

Run 1, 2: one of two device nodes gone
Run 3: both device nodes gone
Run 4: both device nodes are there (again)

It only works if the kernel sends the remove event instead of the change
event as well. So I'm only fine with this if the kernel change gets
accepted as well.

I create two MD devices (md0 and md1) on top of LVM. Then I check if the
creation worked, stop the devices and check the devices again. For a
clean state afterwards, I clean up everything and check devices again in
my script. I have 5s sleep between each action to get final states.

I've attached my test script.

> commit 7856fa44b8f0bc217a6bbcb5f7c51b2f03717655
> Author: Jes Sorensen <Jes.Sorensen@redhat.com>
> Date:   Tue Feb 16 16:58:36 2016 -0500
> 
>     Manage.c: Only issue change events for kernels older then 2.6.28

Shouldn't the prefix be "Manage:" or "Manage/stop:"? Here is a typo.
Should be "than" instead of "then" here.

>     
>     2.6.28+ kernels handle this themselves and issuing the event here can
>     cause a race.
>     
>     Reported-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
>     Suggested-by: NeilBrown <neilb@suse.com>
>     Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> diff --git a/Manage.c b/Manage.c
> index 7e1b94b..eae96e1 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -493,14 +493,17 @@ done:
>  		rv = 1;
>  		goto out;
>  	}
> -	/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
> -	 * was stopped, so We'll do it here just to be sure.  Drop any
> -	 * partitions as well...
> -	 */
> -	if (fd >= 0)
> -		ioctl(fd, BLKRRPART, 0);
> -	if (mdi)
> -		sysfs_uevent(mdi, "change");
> +
> +	if (get_linux_version() < 2006028) {
> +		/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
> +		 * was stopped, so We'll do it here just to be sure.  Drop any
> +		 * partitions as well...
> +		 */
> +		if (fd >= 0)
> +			ioctl(fd, BLKRRPART, 0);
> +		if (mdi)
> +			sysfs_uevent(mdi, "change");
> +	}
>  
>  	if (devnm[0] && use_udev()) {
>  		struct map_ent *mp = map_by_devnm(&map, devnm);
> 


--------------000503020206020009090604
Content-Type: text/plain; charset=UTF-8;
 name="test_mdadm_stop.sh.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="test_mdadm_stop.sh.txt"

#!/bin/bash

NUM_VOL=3D2

remove_devices() {
    for ((i=3D0;i<${NUM_VOL};i++)); do
        rm -fv /dev/md${i}
    done
}

check_devices() {
    ls -l /dev/disk/by-id/md*
    ls -d /dev/md*
    ls -d /sys/block/md*
    cat /proc/mdstat
}

stop_devices() {
    for ((i=3D0;i<${NUM_VOL};i++)); do
        mdadm --stop /dev/md${i} 2>&1
    done
}

create_devices() {
    for ((i=3D0;i<${NUM_VOL};i++)); do
        mdadm --zero-superblock /dev/dm-${i}
        mdadm -C /dev/md${i} -l 1 -n 2 -e 1.2 \
            --run /dev/dm-${i} missing
    done
}

####### MAIN #######

create_devices

sleep 5

echo "=3D=3D=3D=3D CREATE CHECK =3D=3D=3D=3D"
check_devices

sleep 5

stop_devices

sleep 5

echo "=3D=3D=3D=3D CHECK 1 =3D=3D=3D=3D"
check_devices

stop_devices
remove_devices

sleep 5

echo "=3D=3D=3D=3D CHECK 2 =3D=3D=3D=3D"
check_devices

--------------000503020206020009090604--
