From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Tue, 19 Mar 2013 16:15:35 -0500
Message-ID: <1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com>
References: <1363195764.24906.14.camel@f16> <20130318104905.4a70bc00@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130318104905.4a70bc00@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:

> On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> Neil,
>> 
>> I've noticed that when too many devices fail in a RAID arrary that
>> addtional I/O will hang, yielding an endless supply of:
>> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logical block 3
>> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
>> Mar 12 11:52:53 bp-01 kernel: sector=800 i=3           (null)           (null)  
>>         (null)           (null) 1
> 
> This is the third report in as many weeks that mentions that WARN_ON.
> The first two where quite different causes.
> I think this one is the same as the first one, which means it would be fixed
> by  
>      md/raid5: schedule_construction should abort if nothing to do.
> 
> which is commit 29d90fa2adbdd9f in linux-next.

Sorry, I don't see this commit in linux-next:
(the "for-next" branch of) git://github.com/neilbrown/linux.git
or git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Where should I be looking?

I did grab a patch from an earlier discussion where you mentioned a similar commit ID.  It didn't solve the problem, but it did prevent an endless progression of the same error messages.  I only saw one instance of the above after the patch.

I'm fairly certain that the hang was affecting more than just RAID5 though.  It also happened with raid1/10.  I'll go back with 3.9.0-rc3 and make sure that's true until I can figure out which 'linux-next' commit you are talking about.

thanks,
 brassow

