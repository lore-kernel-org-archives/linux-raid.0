From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Mon, 29 Aug 2011 09:45:17 +0200
Message-ID: <4E5B438D.8000107@xunil.at>
References: <4E5787A1.7080807@xunil.at> <20110826125653.GA13709@cthulhu.home.robinhill.me.uk> <4E57A4D5.3070004@xunil.at> <20110826140810.GB13709@cthulhu.home.robinhill.me.uk> <4E57BEBB.2000606@xunil.at> <4E5B396D.9020609@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5B396D.9020609@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

Am 29.08.2011 09:02, schrieb Stefan G. Weichinger:
> Am 26.08.2011 17:41, schrieb Stefan G. Weichinger:
> 
>> Yep, also clear now.
>> I wait with that ddrescue-stuff anyway.
> 
> Could I somehow make the hdd re-map those 2 sectors?

I now followed

http://smartmontools.sourceforge.net/badblockhowto.html#lvm

and afai see the two bad blocks are inside a LVM-LV which is not
important at all!

It is a 20 GB LV prepared for something the customer never really used
so I will mv away the test-data and remove the LV.

Does this somehow help me to be able to maybe remap the bad blocks?

Thanks, Stefan



