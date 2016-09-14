From: Yi Zhang <yizhan@redhat.com>
Subject: Re: lots of "md: export_rdev(sde)" printed after create IMSM RAID10
 with missing
Date: Wed, 14 Sep 2016 17:24:48 +0800
Message-ID: <297c8c9d-92bd-52f3-047d-1808bf0a8838@redhat.com>
References: <338941973.7699634.1473230038475.JavaMail.zimbra@redhat.com>
 <1648084319.7702644.1473230621059.JavaMail.zimbra@redhat.com>
 <20160908225607.GA66921@kernel.org>
 <7910bc85-f9c4-1ea3-76a6-40b819738537@intel.com>
 <a543dd7a-b582-98fa-3ba8-67500396c766@redhat.com>
 <eae7d252-406c-641f-928e-354b5d6df6c0@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eae7d252-406c-641f-928e-354b5d6df6c0@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Shaohua Li <shli@kernel.org>, Jes.Sorensen@redhat.com, linux-raid@vger.kernel.orgJes.Sorensen@redhat.com
List-Id: linux-raid.ids



On 09/12/2016 06:58 PM, Artur Paszkiewicz wrote:
> On 09/12/2016 10:03 AM, Yi Zhang wrote:
>> Hello Artur
>> With your patch, no "md: export_rdev(sde)" printed after create raid10.
>>
>> I found another problem, not sure whether it is reasonable, could you help confirm it, thanks.
>> When I create one container with 4 disks[1], and create one raid10 with 3 disks(sd[b-d]) + 1 missing [2], but it finally bind the fourth disk: sde [3].
>>
>> [1] mdadm -CR /dev/md0 /dev/sd[b-e] -n4 -e imsm
>> [2] mdadm -CR /dev/md/Volume0 -l10 -n4 /dev/sd[b-d] missing --size=500M
>> [3] # cat /proc/mdstat
>> Personalities : [raid10]
>> md127 : active raid10 sde[4] sdd[2] sdc[1] sdb[0]
>>        1024000 blocks super external:/md0/0 128K chunks 2 near-copies [4/4] [UUUU]
>>
>> md0 : inactive sde[3](S) sdd[2](S) sdc[1](S) sdb[0](S)
>>        4420 blocks super external:imsm
>>
>> unused devices: <none>
> I think that this is correct behavior. Because there is a spare disk
> available in the container, it is used for rebuilding the volume. This
> is equivalent to:
>
> mdadm -CR /dev/md0 /dev/sd[b-d] -n3 -e imsm
> mdadm -CR /dev/md/Volume0 -l10 -n4 /dev/sd[b-d] missing --size=500M
> mdadm -a /dev/md0 /dev/sde
got, thanks Artur for the confirmation.

Yi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

