From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID creation resync behaviors
Date: Tue, 09 May 2017 17:03:51 -0400
Message-ID: <yq1k25prbd4.fsf@oracle.com>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
        <87inlhpgzu.fsf@notabene.neil.brown.name>
        <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
        <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
        <87o9v1n56m.fsf@notabene.neil.brown.name>
        <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com> (Jes Sorensen's
        message of "Tue, 9 May 2017 16:49:20 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


Jes,

>> According to
>>
>> Documentation/ABI/testing/sysfs-block
>>
>> Description:
>>                  Will always return 0.  Don't rely on any specific behavior
>>                  for discards, and don't read this file.
>>
>> See also
>>   Commit: 48920ff2a5a9 ("block: remove the discard_zeroes_data flag")
>
> Crap!
>
> Back to the drawing board :(

Discard is now a deallocate hint like it was originally intended.
Behavior is non-deterministic and no guarantees are made wrt. block
contents on subsequent reads.

To zero a block range you should be issuing blkdev_issue_zerooout().
This will use the best zeroing approach given the device characteristics
(TRIM/UNMAP if the device provides hard guarantees, or regular WRITE
SAME which also does the right thing on some SSDs). If none of the fancy
zeroing commands work, you'll fall back to writing zeroes manually.

-- 
Martin K. Petersen	Oracle Linux Engineering
