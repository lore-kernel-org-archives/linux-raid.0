From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 4/4] md-cluster: re-add
Date: Thu, 09 Apr 2015 22:49:36 -0500
Message-ID: <55274850.6060903@suse.de>
References: <20150408192414.GA9693@shrek.lan> <20150409095501.536f6216@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150409095501.536f6216@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids



On 04/08/2015 06:55 PM, NeilBrown wrote:
> On Wed, 8 Apr 2015 14:24:14 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
>> This extends the capabilites of re-adding a failed device
>> to the clustering environment.
>>
>> A new function gather_bitmaps gathers set bits from bitmaps of
>> all nodes, sends a message to all nodes to readd the disk
>> and then initiates the recovery process.
>>
>> Question: Do you see a race in sending a READD and then performing
>> the bitmap resync/recovery? Should the initiating node perform the
>> recovery before sending the READD message? The recovery will send a
>> METADATA_UPDATE anyways.
>
> The RE-ADD has to happen *before* the bitmaps are gathered.
> After the RE-ADD, all writes will go to the new device.
> Any write before that RE-ADD will be recorded in the bitmap.
> To ensure that the recovery handles all regions affected by writes, it needs
> to know about all writes that didn't go to the new device.  So it needs to
> collect bitmaps only once new writes have started going to the new device.
>
> Is that clear?  If not, I'll try again.
>

Yes, I understood your point. Performing the re-add later would miss on 
the ones between the recovery and the re-add.

-- 
Goldwyn
