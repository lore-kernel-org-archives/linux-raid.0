From: Robert Schultz <rob@schultzfamily.ca>
Subject: Re: RAID 5 3-drive array failed 2 disks at once - can anything be
 saved?
Date: Wed, 18 Sep 2013 22:29:51 -0400
Message-ID: <523A619F.90302@schultzfamily.ca>
References: <52332763.30901@schultzfamily.ca> <52347194.7010602@turmel.org> <52361B98.9030705@schultzfamily.ca> <52365AE8.5010807@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52365AE8.5010807@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

That all worked beautifully. Right up until I left the BackupPC running 
against a RAID array with a bad disk.

It failed again after about 30 hours. The symptoms are the same.

I think I need to bring the array back up but leave that disk offline with:

mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc

(sdd is the bad drive)

Then follow the remainder of the steps to check.

I have a new disk on the way. I would then add this new disk into the 
array and sync.

Does that sound correct?

Rob

On 13-09-15 09:12 PM, Phil Turmel wrote:
> Hi Robert,
>
> On 09/15/2013 04:42 PM, Robert Schultz wrote:
>> Phil:
>>
>> Thank you for the information. This is my backup machine. Up to this
>> point I wasn't concerned about having a second copy of this machine, but
>> I have a tendency to decommission a computer and leave the backups on by
>> backuppc for archive purposes. I probably don't really, really need
>> anything on this PC. That said I'm am very paranoid that I will have
>> some other failure before I can resolve this :-(
>>
>> I hadn't read anything about timing in disks in RAID - I'll have to go
>> do some research. I see WD has their RED series that appears to be
>> directed to this market.
> Please do read the archives on the topic.  You won't regret it.
>
> And yes, the WD REDs power up with SCTERC set properly.  I bought four
> of these for my new media server.
>
>> Here is the information requested. Please let me know if this changes
>> anything in your instructions. I'll hold off until you confirm.
> One modest change.  Two of your drives *do* support SCTERC, they just
> have to have it enabled on every powerup:
>
>> SCT Error Recovery Control:
>>             Read: Disabled
>>            Write: Disabled
> For those two drives, your boot sequence should have:
>
> smartctl -l scterc,70,70 /dev/sdX
>
> For the other, you still need:
>
> echo 180 >/sys/block/sdX/device/timeout
>
> Otherwise, my recommendations stand.
>
> Phil

