From: Ming Lei <Ming.Lei@riverbed.com>
Subject: FW: question about bitmap for raid6
Date: Mon, 10 Sep 2012 16:43:14 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA39284A942@SFO1EXC-MBXP06.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA39284A4F5@SFO1EXC-MBXP06.nbttech.com>
 <20120910085035.3fe12f99@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120910085035.3fe12f99@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

How about the other scenario: I plug out a drive and put aside for a while and put it back to the same machine with bitmap enabled for the raid6 array? Does it do full-recovery or fast resync?

I noticed either md superblock or bitmap superblock has events recorded and I guess it may be used to identify the up-to-date drive or the old drive put back again. 

Thanks
Ming

-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Sunday, September 09, 2012 3:51 PM
To: Ming Lei
Subject: Re: question about bitmap for raid6

On Sat, 8 Sep 2012 21:07:46 +0000 Ming Lei <Ming.Lei@riverbed.com> wrote:

> Hi Neil,
> 
> We use 2.6.32 in house and most recently we found something bad happen when we turn on bitmap for raid6 array. Let me ask a question to help me to understand our situation.
> 
> Say I have two hardware identical PCs(name them A and B) running with the same linux distribution. Both box has an raid6 array assmeblying 7 drives with internal bitmap. If I yank out one drive from PC B to make this drive slot empty, and then yank out a drive from PC A and move it to PC B, would md driver force the raid6 array on PC B rebuild(take a long time) or just do resync(very short time)? What's the condition on bitmap code to check if it is really the drive I just pull out from the same machine or it is the drive pulled out from different machine?
> 
> Thanks
> Ming

PC B would not do anything to drive that you moved from PC A until you add it as a spare.  Then it will perform a complete rebuild of the missing device to the new device.  It will not do a partial recovery.

'md' knows it is a device from a different array because the 'uuid' stored in the metadata is different.
If you managed to create two arrays on two different PCs which both had the same UUID, then you could  definitely get strange data corruption happening, but that is very unlikely.

NeilBrown

