From: Phil Turmel <philip@turmel.org>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Fri, 3 Apr 2020 16:14:46 -0400
Message-ID: <d2db8ad1-9fb3-4d08-3fdd-2eb06a931859@turmel.org>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
 <e77280ef-a5ac-f2d8-332c-dec032ddc842@turmel.org>
 <CAB00BMj5kihqwOY-FOXv-tqG1b2reMnUVkdmB9uyNAeE7ESasw@mail.gmail.com>
 <061b695a-2406-fc00-dd6d-9198b85f3b1b@turmel.org>
 <CAB00BMi3zhfVGpeE_AyyKiu1=MY2icYgfey0J3GeO8z9ZDAQbg@mail.gmail.com>
 <5E8485DA.2050803@youngman.org.uk>
 <9a303b9b-52b8-f0c6-4288-120338c6572f@turmel.org>
 <CAB00BMig177NjEbBQgfjQ5gZE3QPTR-B6FD9i8oczHqf7mMqcg@mail.gmail.com>
 <1f4b8c74-4c38-6ea4-6868-b28f9e5c4a10@turmel.org>
 <e75f80f4-70d4-e283-b3bc-c78bd0d55a8a@turmel.org>
 <CAB00BMhU76rjvQv9v-HxM8Harc9ssLBANWfPsW9abbSRNgwoUQ@mail.gmail.com>
 <bb554b86-3dc0-8cb2-c279-f8841742195c@turmel.org>
 <CAB00BMgwCbtGYJ_hX3_rZv3uaOd7vrHuEebqsPLHp3S96tJaRw@mail.gmail.com>
 <5985cc5b-a332-eb69-2d84-cb54f8f5b0fc@turmel.org>
 <CAB00BMjxywFn_K_D=Xn7ySHp404nvULTXarA7EwjxtuTJSOqQg@mail.gmail.com>
 <346301ce-505f-a2df-5cda-536f3ebb9b34@turmel.org>
 <3f771f84-1c0d-8617-faa7-22657d9de95e@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3f771f84-1c0d-8617-faa7-22657d9de95e@websitemanagers.com.au>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Daniel Jones <dj@iowni.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/3/20 4:13 PM, Adam Goryachev wrote:
> 
> On 4/4/20 05:43, Phil Turmel wrote:
>>
>> On 4/3/20 2:42 PM, Daniel Jones wrote:
>>> After the "--create missing /dev/sdc1 /dev/sdd1 /dev/sde1"  and the
>>> fsck, is "mdadm --manage /dev/md0 --add /dev/sdb" the correct syntax
>>> for attempting to add?
>>
>> You can leave out "--manage".  But yes.
> 
> I was mostly following this, but might have missed something here so 
> this is just a suggestion to double check....
> 
> If you are trying to use partitions instead of whole devices (to prevent 
> this happening again in future), then shouldn't you use:
> 
> mdadm --manage /dev/md0 --add /dev/sdb1
> 
> ie, sdb1 not sdb....

Yes.  Good catch.
