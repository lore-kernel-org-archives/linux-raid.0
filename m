From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: Re: Re: [PATCH] md/raid1:Fix bug about fixing read errors.
Date: Tue, 17 Apr 2012 13:00:42 +0800
Message-ID: <201204171300362653566@gmail.com>
References: <201204112008265318561@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi:

>>  However it seems to address multiple issues, and so should be multiple
>>patches.

>>Firstly, it allows fix_read_error to read from a disk that is being recovered.
>>It seems unlikely that this will ever be necessary, but it is theoretically
>>possible so I am happy with the patch.
>>I have applied a patch making just this change.
 This idea from the read_balance. 

>>Secondly it records a bad block on every device if it cannot read from
>>anywhere.
>>I don't think this is necessary.  fix_read_error should only be addressing
>>the one read error.  It either fixes it or marks it as bad.
>>If there are other bad blocks on other disks they will be found and handled
>>eventually and adding extra code in here  just makes it more complex with
>>little gain.
In this situation
1:no channce to recover
2: performance,why judge more read?
3:like the action  in function fix_sync_read_error().

>>So unless you can convince me that it is actually behaving wrongly, I won't
>>be applying the rest of the patch.


