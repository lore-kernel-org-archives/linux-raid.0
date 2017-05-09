From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID creation resync behaviors
Date: Tue, 09 May 2017 17:16:08 -0400
Message-ID: <yq1bmr1rasn.fsf@oracle.com>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
        <87inlhpgzu.fsf@notabene.neil.brown.name>
        <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
        <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
        <87o9v1n56m.fsf@notabene.neil.brown.name>
        <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com>
        <yq1k25prbd4.fsf@oracle.com>
        <08ba08b3-0e8c-c064-6b35-9084545e2c22@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <08ba08b3-0e8c-c064-6b35-9084545e2c22@gmail.com> (Jes Sorensen's
        message of "Tue, 9 May 2017 17:11:53 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


Jes,

> This is fine within the kernel, however it is not overly useful for
> mdadm to determine which strategy to apply when syncing devices.

BLKZEROOUT

-- 
Martin K. Petersen	Oracle Linux Engineering
