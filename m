From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH 000 of 3] md: Introduction
Date: Thu, 2 Feb 2006 17:52:17 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0602021749080.1958@filesrv1.baby-dragons.com>
References: <20060202165638.15890.patches@notabene>
 <Pine.LNX.4.64.0602020945460.1426@filesrv1.baby-dragons.com>
 <17378.32580.843867.356162@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17378.32580.843867.356162@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  	Hello Neil ,

On Fri, 3 Feb 2006, Neil Brown wrote:
> On Thursday February 2, babydr@baby-dragons.com wrote:
>> On Thu, 2 Feb 2006, NeilBrown wrote:
>>> Three patches for 2.6.lastest. All should go in 2.6.16.
>>> One won't apply against -rc1-git5 as it fixes a bug in a patch
>>> in -mm that hasn't quite got to -linus yes.
>>>
>>> They are mostly little fixes.  I've been doing some more testing,
>>> particularly creating a raid1 over 2 6TB arrays.  This requires
>>> version-1 superblocks, so they have had a bit more testing too.
>>>
>>> (No, I didn't try to resync the 6TB raid1.  I created it
>>> --assume-clean and gave it a write-intent bitmap so a full resync
>>> would never be needed.  If one side died, a recovery would take
>>> ages!!!! but for me it was only an experiment, not a serious configuration).
>>> (You will need mdadm-2.3 if you too want a 6TB raid1).
>>>
>>> [PATCH 001 of 3] md: Handle overflow of mdu_array_info_t->size better.
>>> [PATCH 002 of 3] md: Assorted little md fixes:
>>> [PATCH 003 of 3] md: Make sure rdev->size gets set for version-1 superblocks.
>>  	Would you be so kind and share the commands you ran in order to
>>  	build this array ?  Please ,  Please !-)   Tia ,  JimL

> Well, I don't have 12TB of storage so:
>
> # create some sparse 2G loopback devices
> for i in 1 2 3 4 5 6
> do
> dd if=/dev/full of=Big$i bs=1024k seek=2000000 count=1
> losetup /dev/loop$i Big$1
> done
>
> # combine them into 6G linear arrays
> mdadm -C /dev/md4 -l linear -n 3 /dev/loop[123]
> mdadm -C /dev/md5 -l linear -n 3 /dev/loop[456]
>
> # now make the 6G mirrored pair.
> mdadm -C /dev/md3 -l 1 -n2 --assume-clean --bitmap=internal /dev/md[45]
>
> Providing you are using mdadm 2.3, this will automatically select
> version-1 superblocks and create the array marking it clean without
> any resync.
>
> Ofcourse, as this particular array is based on sparse files, actually
> trying to store much data on it will quickly run you into trouble, but
> as a proof-of-implementation, it works OK.
>
> Was that what you were after?
 	Yes ,  Exactly what I was looking for .  The loop* stuff is not
 	needed for me but the last to commands sure were .
 		Tnx agn ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
|  http://www.asteriskhelpdesk.com/cgi-bin/astlance/r.cgi?babydr   |
+------------------------------------------------------------------+
