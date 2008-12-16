From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: raid1 recovery: reads and writes
Date: Tue, 16 Dec 2008 14:04:58 -0700
Message-ID: <494817FA.5040108@intel.com>
References: <cccedfc60812150545s7159f0a2x2fa7f36ecf8d9c60@mail.gmail.com>	 <18758.51053.866819.442495@notabene.brown>	 <e9c3a7c20812151654u5d644ccbv2c925a2fe2bc1c7e@mail.gmail.com> <cccedfc60812151840g8febe5ayfda29ae609bca9df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812151840g8febe5ayfda29ae609bca9df@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Neil Brown <neilb@suse.de>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> ..
> 
>> Yes it is hard to guess what is happening here; however, should not
>> the following commit go to -stable?
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=56ac36d722d0d27c03599d1245ac0ab59e474e5c
> 
> Is it possible this commit is (partially) responsible for what I was
> seeing? Under what conditions would it trigger?

I don't think this commit is responsible, it's a fix for a case where 
the kernel was asked to do a repair but a recovery is pending.

This commit addressed a bug in external-metadata support when adding a 
spare disk via sysfs.  It would be fairly difficult to trigger this in 
the non-external-metadata case.   It would require a check/repair 
request to come in immediately after the disk was (re-)added, but before 
the kernel started the resync.

--
Dan
