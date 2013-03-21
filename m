From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Thu, 21 Mar 2013 09:01:22 -0500
Message-ID: <5194AA5D-827E-4E6F-8749-3F345DFB0287@redhat.com>
References: <1363195764.24906.14.camel@f16> <20130318104905.4a70bc00@notabene.brown> <1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com> <20130320134611.4c9b0e75@notabene.brown> <AE87208C-5B7F-4949-8A99-F8841ADD5B1F@redhat.com> <20130321100450.6b82dbfa@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130321100450.6b82dbfa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Mar 20, 2013, at 6:04 PM, NeilBrown wrote:

>> 
>> On a different topic, I've noticed the following commits in 'for-next':
>>  90584fc MD: Prevent sysfs operations on uninitialized kobjects
>>  e3620a3 MD RAID5: Avoid accessing gendisk or queue structs when not available
>> but these are not in 3.9.0-rc3.  They should make their way into 3.9.0 as well as 3.8.0.  (They apply cleanly to the 3.8 kernel, but I hadn't bothered to notify 'stable' - only mention the regression was introduced in 3.8-rc1.)
> 
> They are due to be sent to Linus today.
> The second one is  tagged for -stable and will go to 3.8.x (I think 3.7.x is
> closed).
> The first isn't - my quick examination suggested that the current code is
> safe but not ideal.  If you think it is appropriate for -stable  (i.e. fixes
> a real bug that could hurt users) let me know why and I'll make sure it goes
> to -stable.

Yes, the second is the important one.  We don't need the first backported to stable.

Thanks!
 brassow