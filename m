From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 09:11:12 +1000
Message-ID: <bdb354cb-62f4-a254-11f6-6cdb00639341@websitemanagers.com.au>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
 <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <7d0af770699948fb0ecb66185145be05@assyoma.it>
 <alpine.DEB.2.20.1708201241400.3655@uplift.swm.pp.se>
 <59998974.60103@youngman.org.uk>
 <5df0037e-fc76-1127-e2e8-c4992b6d216e@websitemanagers.com.au>
 <alpine.DEB.2.20.1708201742080.3655@uplift.swm.pp.se>
 <5999B46C.1050906@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5999B46C.1050906@youngman.org.uk>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/08/17 02:10, Wols Lists wrote:
> On 20/08/17 16:48, Mikael Abrahamsson wrote:
>> On Mon, 21 Aug 2017, Adam Goryachev wrote:
>>
>>> data (even where it is wrong). So just do a check/repair which will
>>> ensure both drives are consistent, then you can safely do the fsck.
>>> (Assuming you fixed the problem causing random write errors first).
>> This involves manual intervention.
>>
>> While I don't know how to implement this, let's at least see if we can
>> architect something for throwing ideas around.
>>
>> What about having an option for any raid level that would do "repair on
>> read". So you can do "0" or "1" on this. RAID1 would mean it reads all
>> stripes and if there is inconsistency, pick one and write it to all of
>> them. It could also be some kind of IOCTL option I guess. For RAID5/6,
>> read all data drives, and check parity. If parity is wrong, write parity.
>>
>> This could mean that if filesystem developers wanted to do repair (and
>> this could be a userspace option or mount option), it would use the
>> beforementioned option for all fsck-like operation to make sure that
>> metadata was consistent while doing fsck (this would be different for
>> different tools, if it's an "fs needs to be mounted"-type of fs, or if
>> it's an "offline fsck" type filesystem. Then it could go back to normal
>> operation for everything else that would hopefully not cause
>> catastrophical failures to the filesystem, but instead just individual
>> file corruption in case of mismatches.
>>
> Look for the thread "RFC Raid error detection and auto-recovery, 10th May.
>
> Basically, that proposed a three-way flag - "default" is the current
> "read the data section", "check" would read the entire stripe and
> compare a mirror or calculate parity on a raid and return a read error
> if it couldn't work out the correct data, and "fix" would write the
> correct data back if it could work it out.
>
> So basically, on a two-disk raid-1, or raid 4 or 5, both "check" and
> "fix" would return read errors if there's a problem and you're SOL
> without a backup.
>
> With a three-disk or more raid-1, or raid-6, it would return the correct
> data (and fix the stripe) if it could, otherwise again you're SOL.

 From memory, the main sticking point was in implementing this with 
RAID6 and the argument that you might not be able to choose the "right" 
pieces of data because there wasn't a sufficient amount of data to know 
which was corrupted. Perhaps it would be a easier starting point to use 
RAID1 with a three (or more) mirrors to implement this. You only need to 
read two drives to "check" that there is consensus (technically, 
int(n/2)+1, though you could start with just 2 which ensures there isn't 
one drive behaving badly). Once this is implemented, if you need larger 
arrays, then you would need to layer your RAID, using RAID61 with >=3 
mirror RAID1 components. Eventually, you might be able to migrate this 
to RAID6 or other levels, but at least once it is in kernel, and proven 
to be working (and actually used by people) then it will get a lot easier.

Regards,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
-- 
The information in this e-mail is confidential and may be legally privileged.
It is intended solely for the addressee. Access to this e-mail by anyone else
is unauthorised. If you are not the intended recipient, any disclosure,
copying, distribution or any action taken or omitted to be taken in reliance
on it, is prohibited and may be unlawful. If you have received this message
in error, please notify us immediately. Please also destroy and delete the
message from your computer. Viruses - Any loss/damage incurred by receiving
this email is not the sender's responsibility.
