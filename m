From: "Simon Jackson" <sjackson@bluearc.com>
Subject: RE: RAID 1 resync with both members good.
Date: Fri, 8 May 2009 08:15:20 +0100
Message-ID: <3D76E016F4A2A749A1EB1A3FD83E22BC027F1C64@uk-email.terastack.bluearc.com>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC02783863@uk-email.terastack.bluearc.com> <a93e6da36d0a72953e6a2cce74323e2d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <a93e6da36d0a72953e6a2cce74323e2d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil that clarifies the situation.

-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: 08 May 2009 01:32
To: Simon Jackson
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID 1 resync with both members good.

On Thu, May 7, 2009 6:08 pm, Simon Jackson wrote:
> Could someone help me understand why I am seeing the following
> behaviour?
>
> We use a pair of disks with 3 RAID1 partitions inside an appliance
> system.
>
> During testing we have seen some instances of the RAID devices
resyncing
> even though both members are marked as good in the output of
> /proc/mdstat.

That is exactly as expectedc.
If one of the devices had failed and was being replaced by a spare, you
would see "recovery" not "resync".

Resync happens after an unclean shutdown.
In that case, both drives have good data, but they might not be the
same.
The resync makes sure that all copies have exactly the same data.

So you there must have been an unclean shutdown before the most recent
restart.

NeilBrown


>
> merc:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md2 : active raid1 sda3[0] sdb3[1]
> 7823552 blocks [2/2] [UU]
> resync=DELAYED
> md0 : active raid1 sda5[0] sdb5[1]
> 7823552 blocks [2/2] [UU]
> md1 : active raid1 sda6[0] sdb6[1]
> 55841792 blocks [2/2] [UU]
> [=================>...] resync = 88.8% (49606848/55841792)
finish=8.4min
> speed=12256K/sec
> unused devices: <none>
>
>
> Why would a resync occur if both members are marked us good?
>
> What we usually see when a drive is failed removed and readded is that
> the resync marks the new drive as down "_" until the resync completes.
>
> Firstly why is a resync occurring when both drives are still good in
the
> raid set?  Is this be expected behaviour or an indication of an
> underlying problem.
>
> Thanks for any assistance.
>
> Using Debian 2.6.26-1
>
> Thanks Simon.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

