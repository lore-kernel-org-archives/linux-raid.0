From: Eric Mei <meijia@gmail.com>
Subject: Re: Last working drive in RAID1
Date: Wed, 04 Mar 2015 15:48:57 -0700
Message-ID: <54F78BD9.403@gmail.com>
References: <54F7633F.3020503@gmail.com> <20150305084634.2d590fe4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150305084634.2d590fe4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I see, that does make sense. Thank you.

But it impose a problem for HA. We have 2 nodes as active-standby pair, 
if HW on node 1 have problem (e.g. SAS cable get pulled, thus all access 
to physical drives are gone), we hope the array failover to node 2. But 
with lingering drive reference, mdadm will report array is still alive 
thus failover won't happen.

I guess it depends on what kind of error on the drive. If it's just a 
media error we should keep it online as much as possible. But if the 
drive is really bad or physically gone, keeping the stale reference 
won't help anything. Back to your comparison with single drive /dev/sda, 
I think MD as an array should do the same as /dev/sda, not the 
individual drive inside MD, for them we should just let it go. How do 
you think?

Eric

On 2015-03-04 2:46 PM, NeilBrown wrote:
> On Wed, 04 Mar 2015 12:55:43 -0700 Eric Mei <meijia@gmail.com> wrote:
>
>> Hi,
>>
>> It is interesting to notice that RAID1 won't mark the last working drive
>> as Faulty no matter what. The responsible code seems here:
>>
>> static void error(struct mddev *mddev, struct md_rdev *rdev)
>> {
>>           ...
>>           /*
>>            * If it is not operational, then we have already marked it as dead
>>            * else if it is the last working disks, ignore the error, let the
>>            * next level up know.
>>            * else mark the drive as failed
>>            */
>>           if (test_bit(In_sync, &rdev->flags)
>>               && (conf->raid_disks - mddev->degraded) == 1) {
>>                   /*
>>                    * Don't fail the drive, act as though we were just a
>>                    * normal single drive.
>>                    * However don't try a recovery from this drive as
>>                    * it is very likely to fail.
>>                    */
>>                   conf->recovery_disabled = mddev->recovery_disabled;
>>                   return;
>>           }
>>           ...
>> }
>>
>> The end result is that even if all the drives are physically gone, there
>> still one drive remains in array forever, and mdadm continues to report
>> the array is degraded instead of failed. RAID10 also has similar behavior.
>>
>> Is there any reason we absolutely don't want to fail the last drive of
>> RAID1?
>>
> When a RAID1 only has one drive remaining, then it should act as much as
> possible like a single plain ordinary drive.
>
> How does /dev/sda behave when you physically remove the device?  md0 (as a
> raid1 with one drive) should do the same.
>
> NeilBrown

