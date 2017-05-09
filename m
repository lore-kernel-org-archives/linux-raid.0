From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID creation resync behaviors
Date: Tue, 09 May 2017 19:56:05 -0400
Message-ID: <yq1y3u5potm.fsf@oracle.com>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
        <87inlhpgzu.fsf@notabene.neil.brown.name>
        <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
        <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
        <87o9v1n56m.fsf@notabene.neil.brown.name>
        <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com>
        <yq1k25prbd4.fsf@oracle.com>
        <08ba08b3-0e8c-c064-6b35-9084545e2c22@gmail.com>
        <yq1bmr1rasn.fsf@oracle.com>
        <f73c7524-5d35-6104-11b1-2c658b43c68d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f73c7524-5d35-6104-11b1-2c658b43c68d@gmail.com> (Jes Sorensen's
        message of "Tue, 9 May 2017 17:22:57 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


Jes,

>> BLKZEROOUT
>>
>
> Trying to read the code, as this ioctl doesn't seem to be documented
> anywhere I can find.... it looks like this ioctl zeroes out a device.
>
> It doesn't help me obtain the information I need to make a decision in
> mdadm as whether to overwrite all or compare+write when resyncing a RAID
> array.

I wasn't trying to solve your policy decision problem. I was merely
responding to Shaohua's concerns about discard vs. zeroes and wearing
out the media.

If you want to act based on the media type, the best heuristic we have
right now is the rotational sysfs attribute / BLKROTATIONAL ioctl. It'll
be one for spinning rust and zero for pretty much everything else.

-- 
Martin K. Petersen	Oracle Linux Engineering
