From: Andreas Boman <aboman@midgaard.us>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 06 May 2013 22:21:33 -0400
Message-ID: <5188652D.3090705@midgaard.us>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us> <518721CD.2040108@turmel.org> <51878BD0.9010809@midgaard.us> <5187A3D2.6060109@turmel.org> <5188189D.1060806@midgaard.us> <51884D49.3090602@turmel.org> <5188556A.7050605@midgaard.us> <51885CDB.8040508@turmel.org> <5188620B.4050206@midgaard.us> <518863E6.7020909@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <518863E6.7020909@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/06/2013 10:16 PM, Phil Turmel wrote:
> On 05/06/2013 10:08 PM, Andreas Boman wrote:
>> My ddrescue problem remains however, I'm still unable to get my degraded
>> array online with the ddrescued disk since I'm missing the md superblock
>> on that disk.
>>
>> /Andreas
>>
>> mdadm -E /dev/sdf1
>> mdadm: No md superblock detected on /dev/sdf1.
> Try using "blockdev --rereadpt /dev/sdf".  Then check again.
>
> Phil
>

No change.

Thanks,
Andreas
