From: Hannes Reinecke <hare@suse.de>
Subject: Re: RAID creation resync behaviors
Date: Wed, 10 May 2017 07:58:45 +0200
Message-ID: <f4485279-2146-5134-d292-d1566e465a38@suse.de>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <87inlhpgzu.fsf@notabene.neil.brown.name>
 <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
 <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
 <87o9v1n56m.fsf@notabene.neil.brown.name>
 <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com> <yq1k25prbd4.fsf@oracle.com>
 <08ba08b3-0e8c-c064-6b35-9084545e2c22@gmail.com> <yq1bmr1rasn.fsf@oracle.com>
 <f73c7524-5d35-6104-11b1-2c658b43c68d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f73c7524-5d35-6104-11b1-2c658b43c68d@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 05/09/2017 11:22 PM, Jes Sorensen wrote:
> On 05/09/2017 05:16 PM, Martin K. Petersen wrote:
>>
>> Jes,
>>
>>> This is fine within the kernel, however it is not overly useful for
>>> mdadm to determine which strategy to apply when syncing devices.
>>
>> BLKZEROOUT
>>
> 
> Trying to read the code, as this ioctl doesn't seem to be documented
> anywhere I can find.... it looks like this ioctl zeroes out a device.
> 
> It doesn't help me obtain the information I need to make a decision in
> mdadm as whether to overwrite all or compare+write when resyncing a RAID
> array.
> 
What you actually want is the COMPARE AND WRITE SCSI command :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
