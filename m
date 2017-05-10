From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID creation resync behaviors
Date: Wed, 10 May 2017 18:20:30 -0400
Message-ID: <yq17f1onykx.fsf@oracle.com>
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
        <f4485279-2146-5134-d292-d1566e465a38@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4485279-2146-5134-d292-d1566e465a38@suse.de> (Hannes Reinecke's
        message of "Wed, 10 May 2017 07:58:45 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


Hannes,

>> It doesn't help me obtain the information I need to make a decision in
>> mdadm as whether to overwrite all or compare+write when resyncing a RAID
>> array.
>> 
> What you actually want is the COMPARE AND WRITE SCSI command

Actually, I think what Jes needs is a MISCOMPARE AND WRITE command :)

-- 
Martin K. Petersen	Oracle Linux Engineering
