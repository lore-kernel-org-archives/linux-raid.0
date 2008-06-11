From: Hubert Verstraete <hubskml@free.fr>
Subject: Re: RAID5 losing initial synchronization on restart when one disk
 is spare
Date: Wed, 11 Jun 2008 11:27:50 +0200
Message-ID: <484F9A96.3010109@free.fr>
References: <48466AD9.5@free.fr> <484E6C3F.4090204@free.fr> <e9c3a7c20806101556q6315f4c1u67bf8879b66d81a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20806101556q6315f4c1u67bf8879b66d81a9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Dan Williams wrote:
> On Tue, Jun 10, 2008 at 4:57 AM, Hubert Verstraete <hubskml@free.fr> =
wrote:
>> Hubert Verstraete wrote:
>>> Hello
>>>
>>> According to mdadm's man page:
>>> "When creating a RAID5 array, mdadm will automatically create a deg=
raded
>>> array with an extra spare drive. This is because building the spare
>>> into a degraded array is in general faster than resyncing the parit=
y on
>>> a non-degraded, but not clean, array. This feature can be over-ridd=
en
>>> with the --force option."
>>>
>>> Unfortunately, I'm seeing a kind of bug when I create a RAID5 array=
 with
>>> an internal bitmap, then stop the array before the initial synchron=
ization
>>> is done and restart the array.
>>>
>>> 1=B0 When I create the array with an internal bitmap:
>>> mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -b internal -R /dev/sd?
>>> I see the last disk as a spare disk. After the restart of the array=
, all
>>> disks are seen active and the array is not continuing the aborted
>>> synchronization!
>>> Note that I did not use the --assume-clean option.
>>>
>>> 2=B0 When I create the array without a bitmap:
>>> mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -R /dev/sd?
>>> I see the last disk as a spare disk. After the restart of the array=
, the
>>> spare disk is still a spare disk and the array continues the synchr=
onization
>>> where it had stopped.
>>>
>>> In the case 1=B0, is this a bug or did I miss something?
>>> Secondly, what could be the consequences of this non-performed
>>> synchronization ?
>>>
>>> Kernel version: 2.6.26-rc4
>>> mdadm version: 2.6.2
>>>
>>> Thanks,
>>> Hubert
>> For the record, the new stable kernel 2.6.25.6 has the same issue.
>> I thought maybe the patch "md: fix prexor vs sync_request race" coul=
d have
>> fixed this, unfortunately not.
>>
>
> I am able to reproduce this here, and I notice that it does not happe=
n
> with v0.90 superblocks.  In the v0.90 case when the array is stopped
> the last disk remains marked as spare.  The following hack seems to
> achieve the same effect for v1 arrays, but I wonder if it is
> correct... Neil?

Thanks Dan.
I quickly tried your patch on 2.6.25.6, unfortunately it did not fix th=
e=20
issue.

Regards,
Hubert
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
