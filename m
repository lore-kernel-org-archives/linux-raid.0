From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Sun, 2 Oct 2016 12:33:57 -0500
Message-ID: <e51999b2-9a41-a675-b544-95d48ba992b5@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
 <57EAA214.8030603@youngman.org.uk>
 <5427ce35-f222-8a2c-486e-441c4c6ec9a6@gmail.com>
 <be044941-8097-7d6f-5216-294fe2cac4d9@websitemanagers.com.au>
 <b87f3f0d-e9a9-8ece-d708-9b8730157bfb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b87f3f0d-e9a9-8ece-d708-9b8730157bfb@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 09/28/2016 10:55 AM, Benjammin2068 wrote:
> On 09/27/2016 06:09 PM, Adam Goryachev wrote:
>> Just out of interest, but I'm not sure how useful your munin monitoring will be... AFAIK, the mismatch_cnt value is only updated when you run a check, which would probably take some number of hours to complete. I would guess that you are unlikely to run more than one check a week or month.... and as soon as there is any change (unless you know the explanation) then you should be looking to resolve that.
>>
>> Unless of course I'm wrong about when the count is updated?
> You would be correct - only during checks - but it's an easy way for me to just keep track of it..
>
> And a check takes about 3hrs on this array. (and it happens every weekend)
>
>

Ok... so as an update....

I ran 2 checks during the week after fixing the thermal issues I was seeing that I think were part of the problem. Both checks resulted in the mismatch_cnt remaining at 0.

The usual CRON automated check ran this weekend -- and bumped the count to 24 on my RAID6 (there's a RAID1 swap that went to 160, but I've read for something like SWAP, this can be ignored. I just thought I'd mention it since it feels a bit like Schrodinger's drive array.)

So... I've emailed the Vendor for a replacement since this SAS/SATA add-on card is new. And maybe it's just flaky.

IN the meantime, is it possible to shrink the array back to RAID5 (4 members) so I can run it on the MB's controller only -- where I never seemed to have a mismatch count problem? (I kind need the array to be up and running since I need to work. :P)

Also -- for academic reasons, is it possible to get a list of the the blocks that causes the count to increase to try confirm it's the new add-on card that's the problem?
If there's a way to list what blocks and drive that were the issue, then I could go check those files....

Otherwise, the mdadm reports the array as clean and happy and FSCK reports the partition as clean and happy.

How disconcerting is that?

Thanks,

 -Ben

