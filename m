From: Phil Turmel <philip@turmel.org>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Wed, 14 Sep 2011 07:41:37 -0400
Message-ID: <4E7092F1.5010209@turmel.org>
References: <4E6F13F7.6070507@truschnigg.info> <4E6F4091.7050206@turmel.org> <4E6FA76A.90206@truschnigg.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E6FA76A.90206@truschnigg.info>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good Morning Johannes,

Sorry about the delay...  worked late yesterday.

On 09/13/2011 02:56 PM, Johannes Truschnigg wrote:
> The controller seems alive still - lsdrv (output attached) lists the
> kernel still having registered some of the component devices.

Actually, it doesn't.  None of the /dev/md0 components are present.  Ditto for the "mdadm -D" report.

There's also insufficient open controller ports shown in lsdrv to account for the five missing raid drives.  That strongly suggests that you've been using an add-on controller or port multiplier, and that controller has died.  A complete dmesg (from boot) would provide the details of the missing controller.  At least ports "scsi 4:x:x:x", "scsi 5:x:x:x", and "scsi 6:x:x:x" must have existed from boot, as they were interleaved with 2, 3, and 7.

>> Since some drives are still "alive", they'll have newer event counts
>>  than the devices that went offline.  When you fix the root cause,
>> you may need to use "--assemble --force" to get mdadm to restart your
>> array.
> 
> I see - I don't have the interim storage capacity to dump the drives
> before trying to do so - is there any advice you can offer to do this
> assembly procedure in the safest way possible?

"--assemble" is safe in all known cases.  Use it first.  With the whole controller gone, you probably have consistent event counts after all, and --assemble should just work.  "--assemble --force" is somewhat less safe, but I wouldn't hesitate to use it in a situation where the drives truly dropped out together.  You'll likely find some problems with fsck if files were actively being written when the array dropped out, but the vast majority of your filesystem(s) should be safe.

Other procedures are progressively less safe.  I prefer to not offer specifics until you've hooked your drives back up, and generated fresh "lsdrv" and "mdadm" reports.

>> The output of "lsdrv" [1] would be helpful in offering more specific
>>  advice, along with "mdadm -D" of the array and "mdadm -E" of all of
>>  its components (when you get them back).
> 
> I will provide the components' info asap.
> 
> Thanks very much for sharing your input and expertise!

You're welcome.

Phil
