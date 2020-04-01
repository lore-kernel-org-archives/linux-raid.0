From: Phil Turmel <philip@turmel.org>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Wed, 1 Apr 2020 08:55:02 -0400
Message-ID: <9a303b9b-52b8-f0c6-4288-120338c6572f@turmel.org>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
 <058b3f48-e69d-2783-8e08-693ad27693f6@youngman.org.uk>
 <CAB00BMgYmi+4XvdmJDWjQ8qGWa9m0mqj7yvrK3QSNH9SzYjypw@mail.gmail.com>
 <1d6b3e00-e7dd-1b19-1379-afe665169d44@turmel.org>
 <CAB00BMg50zcerSLHShSjoOcaJ0JQSi2aSqTFfU2eQQrT12-qEg@mail.gmail.com>
 <e77280ef-a5ac-f2d8-332c-dec032ddc842@turmel.org>
 <CAB00BMj5kihqwOY-FOXv-tqG1b2reMnUVkdmB9uyNAeE7ESasw@mail.gmail.com>
 <061b695a-2406-fc00-dd6d-9198b85f3b1b@turmel.org>
 <CAB00BMi3zhfVGpeE_AyyKiu1=MY2icYgfey0J3GeO8z9ZDAQbg@mail.gmail.com>
 <5E8485DA.2050803@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E8485DA.2050803@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Daniel Jones <dj@iowni.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/1/20 8:15 AM, Wols Lists wrote:
> On 01/04/20 07:03, Daniel Jones wrote:
>> Thanks Phil,
>>
>> I'll read this a couple of times and try some commands (likely on an
>> overlay) tomorrow.
> 
> If you CAN overlay, then DO. If you can't back up the drives, the more
> you can do to protect them from being accidentally written to, the better.

I have to admit that I pretty much never use overlays.  But then I'm 
entirely confident of what any given mdadm/lvm/fdisk operation will do, 
in regards to writing to devices.  And since it is burned into my psyche 
that raid is *not* backup, only an uptime aid, I keep good external 
backups. (:

Lacking confidence and lacking backups are both good reasons for using 
overlays.  I'm not entirely sure the mental effort for a novice to learn 
to use overlays is time better spent than learning enough about MD and 
mdadm for confident use.

I do think initial recovery efforts with --assemble and --assemble 
--force do not need to be done with overlays.  They are so safe and so 
likely to quickly yield a working array that I think overlays should be 
recommended only for invasive tasks needed after these --assemble 
operations fail.

--create is a very invasive opertion.

Phil
