From: Phil Turmel <philip@turmel.org>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Fri, 3 Apr 2020 14:34:16 -0400
Message-ID: <5985cc5b-a332-eb69-2d84-cb54f8f5b0fc@turmel.org>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
 <CAB00BMgYmi+4XvdmJDWjQ8qGWa9m0mqj7yvrK3QSNH9SzYjypw@mail.gmail.com>
 <1d6b3e00-e7dd-1b19-1379-afe665169d44@turmel.org>
 <CAB00BMg50zcerSLHShSjoOcaJ0JQSi2aSqTFfU2eQQrT12-qEg@mail.gmail.com>
 <e77280ef-a5ac-f2d8-332c-dec032ddc842@turmel.org>
 <CAB00BMj5kihqwOY-FOXv-tqG1b2reMnUVkdmB9uyNAeE7ESasw@mail.gmail.com>
 <061b695a-2406-fc00-dd6d-9198b85f3b1b@turmel.org>
 <CAB00BMi3zhfVGpeE_AyyKiu1=MY2icYgfey0J3GeO8z9ZDAQbg@mail.gmail.com>
 <5E8485DA.2050803@youngman.org.uk>
 <9a303b9b-52b8-f0c6-4288-120338c6572f@turmel.org>
 <CAB00BMig177NjEbBQgfjQ5gZE3QPTR-B6FD9i8oczHqf7mMqcg@mail.gmail.com>
 <1f4b8c74-4c38-6ea4-6868-b28f9e5c4a10@turmel.org>
 <e75f80f4-70d4-e283-b3bc-c78bd0d55a8a@turmel.org>
 <CAB00BMhU76rjvQv9v-HxM8Harc9ssLBANWfPsW9abbSRNgwoUQ@mail.gmail.com>
 <bb554b86-3dc0-8cb2-c279-f8841742195c@turmel.org>
 <CAB00BMgwCbtGYJ_hX3_rZv3uaOd7vrHuEebqsPLHp3S96tJaRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB00BMgwCbtGYJ_hX3_rZv3uaOd7vrHuEebqsPLHp3S96tJaRw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Jones <dj@iowni.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/3/20 2:29 PM, Daniel Jones wrote:
> Hello again,
> 
>> Don't do the --add operation until you've copied anything critical in the array to external backups (while running with 3 of 4).
> 
> Everything from the array has been backed up elsewhere.
> 
> Up until now the only writes intentionally done to the physical drives
> have been the new partition tables.  Everything else has been through
> the overlay.
> 
> Now I think I'm ready to run a --create as follows on the physical drives:
> mdadm --create /dev/md0 --assume-clean --data-offset=129536 --level=5
> --chunk=512K --raid-devices=4 missing /dev/sdc1 /dev/sdd1 /dev/sde1
> 
> After that I'd try to re-add the rejected drive?
> mdadm --manage /dev/md0 --add /dev/sdb1
> 
> Part of me wonders about just rebuilding the whole thing and then
> copying the data back, but I don't know that would be any better then
> this path.

Sounds like a risk-free decision.  mdadm --create --assume-clean 
followed by a proper fsck will be lots faster than mdadm --create, mkfs, 
and copying.

I'd go fast.

Phil
