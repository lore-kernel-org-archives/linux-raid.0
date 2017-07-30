From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: How to add journal device to existing RAID5?
Date: Sun, 30 Jul 2017 13:05:48 -0400
Message-ID: <37a24c87-b29f-5e1b-c683-671946fce48f@nuclearwinter.com>
References: <ec6b9beb-b239-9ab9-03ac-7351e152d1af@kyberraum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ec6b9beb-b239-9ab9-03ac-7351e152d1af@kyberraum.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Vasco Steinmetz <linux@kyberraum.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The patch to allow the adding of a journal to an existing array was 
applied in March. See:

http://marc.info/?l=linux-raid&m=149072503301987

The most recent mdadm release, v4.0, was in January so it does not 
include that patch.

All the patch does is remove the restriction in mdadm so it may be 
possible to patch the v4.0 source and build locally to test.

I too am very interested in this capability and would like to know when 
the next mdadm release is expected.

--Larkin

On 7/30/2017 11:19 AM, Vasco Steinmetz wrote:
> Hi,
>
> I bought a 32GB Intel Optane NVMe and would like to add it to an
> existing RAID5 array as the journal device.
>
> My hope was that with the latest Loonix kernel 4.12.4 and mdadm 4.0
> adding a log device to an already existing array should work.
>
> It didn't. :(
>
> Though I marked the R5 array as RO, mdadm complained that adding a
> journal to that particular array is not possible because it didn't have
> had a journal device in teh past.
>
> Unfortunately it is not possible for me to recreate the array, as that
> would imply to move all data to backup, delete and recreate the array
> and afterwards move it back.
>
>
> When is it planned for mdadm/md-raid?.c to add/remove journal devices on
> the fly (assuming they array may not be currently in use, e.g. --readonly)?
>
>
> Kind regards,
> Vasco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

