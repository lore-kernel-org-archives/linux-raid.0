From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Manage: Inform udev about device removal when
 stopping
Date: Tue, 16 Feb 2016 19:40:32 +0100
Message-ID: <56C36D20.6030001@suse.de>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
 <1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com>
 <wrfjio1oeemz.fsf@redhat.com> <56C36487.3060201@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C36487.3060201@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

On 02/16/2016 07:03 PM, Sebastian Parschauer wrote:
> On 16.02.2016 18:41, Jes Sorensen wrote:
>> Sebastian Parschauer <sebastian.riemer@profitbricks.com> writes:
>>> When stopping an MD device, then its device node /dev/mdX may still
>>> exist afterwards or it is recreated by udev. The next open() call
>>> can lead to creation of an inoperable MD device. The reason for
>>> this is that a change event (KOBJ_CHANGE) is announced to udev.
>>> So announce a removal event (KOBJ_REMOVE) to udev instead.
>>>
>>> This also overrides the change event sent by the kernel.
>>>
>>> Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.=
com>
>>> ---
>>>   Manage.c |    6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Manage.c b/Manage.c
>>> index 7e1b94b..bc89764 100644
>>> --- a/Manage.c
>>> +++ b/Manage.c
>>> @@ -494,13 +494,13 @@ done:
>>>   		goto out;
>>>   	}
>>>   	/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
>>> -	 * was stopped, so We'll do it here just to be sure.  Drop any
>>> -	 * partitions as well...
>>> +	 * was stopped, it should be KOBJ_REMOVE instead, so we set the
>>> +	 * remove event here just to be sure. Drop any partitions as well=
=2E..
>>>   	 */
>>>   	if (fd >=3D 0)
>>>   		ioctl(fd, BLKRRPART, 0);
>>>   	if (mdi)
>>> -		sysfs_uevent(mdi, "change");
>>> +		sysfs_uevent(mdi, "remove");
>>
>> I am a little concerned about this change. You assume the kernel and
>> mdadm will be updated in sync, which is unlikely to happen. I believ=
e
>> you need to match the kernel version and send the corresponding even=
t
>> currectly for this to work correctly?
>
> The worst thing that can happen is that the kernel sends the change
> event after the remove event. Then it is the current situation again.
>  From my tests mdadm does enough other stuff in between. Udev is able=
 to
> handle receiving two remove events from my testing. Multiple mdadm
> instances can't run in parallel any ways. So userspace around it need=
s
> some serialization for it any ways. So also stopping an MD device and
> assembling a new one with the same minor number shouldn't race.
>
> I still prefer this solution here. But if you decide to drop the udev
> event sending in mdadm, then I'm also fine with that.
>
I strongly prefer removing the udev event generation altogether.
As this appears to be a carry-over from older kernels, it looks to me a=
s=20
being an incomplete conversion:
At one point udev introduced 'ONLINE' and 'OFFLINE' events, which were=20
supposed to be used for this kind of scenario.
(ONLINE being a companion to 'ADD', and 'OFFLINE' being the companion t=
o=20
'DELETE'). However, later the 'ONLINE' got modified to 'CHANGE', and th=
e=20
'OFFLINE' got dropped completely.
Or that was the plan.
So it looks as if the conversion to 'CHANGE' got applied to the=20
'OFFLINE' event, too.
Hence I strongly recommend to drop it completely, and let the kernel or=
=20
the MD module decide if and when a uevent should be send.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
