From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Fri, 23 Dec 2016 17:17:05 +0100
Message-ID: <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
 <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
 <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com>
 <87k2arpmvt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k2arpmvt.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 12:25 AM, NeilBrown <neilb@suse.com> wrote:
> On Fri, Dec 23 2016, Giuseppe Bilotta wrote:
>> I also wrote a small script to test all combinations (nothing smart,
>> really, simply enumeration of combos, but I'll consider putting it up
>> on the wiki as well), and I was actually surprised by the results. To
>> test if the RAID was being re-created correctly with each combination,
>> I used `file -s` on the RAID, and verified that the results made
>> sense. I am surprised to find out that there are multiple combinations
>> that make sense (note that the disk names are shifted by one compared
>> to previous emails due a machine lockup that required a reboot and
>> another disk butting in to a different order):
>>
>> trying /dev/sdd /dev/sdf /dev/sde /dev/sdg
>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>> (needs journal recovery) (extents) (large files) (huge files)
>>
>> trying /dev/sdd /dev/sdf /dev/sdg /dev/sde
>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>> (needs journal recovery) (extents) (large files) (huge files)
>>
>> trying /dev/sde /dev/sdf /dev/sdd /dev/sdg
>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>> (needs journal recovery) (extents) (large files) (huge files)
>>
>> trying /dev/sde /dev/sdf /dev/sdg /dev/sdd
>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>> (needs journal recovery) (extents) (large files) (huge files)
>>
>> trying /dev/sdg /dev/sdf /dev/sde /dev/sdd
>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>> (needs journal recovery) (extents) (large files) (huge files)
>>
>> trying /dev/sdg /dev/sdf /dev/sdd /dev/sde
>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>> (needs journal recovery) (extents) (large files) (huge files)
>> :
>> So there are six out of 24 combinations that make sense, at least for
>> the first block. I know from the pre-fail dmesg that the g-f-e-d order
>> should be the correct one, but now I'm left wondering if there is a
>> better way to verify this (other than manually sampling files to see
>> if they make sense), or if the left-symmetric layout on a RAID6 simply
>> allows some of the disk positions to be swapped without loss of data.

> You script has reported all arrangements with /dev/sdf as the second
> device.  Presumably that is where the single block you are reading
> resides.

That makes sense.

> To check if a RAID6 arrangement is credible, you can try the raid6check
> program that is include in the mdadm source release.  There is a man
> page.
> If the order of devices is not correct raid6check will tell you about
> it.

That's a wonderful small utility, thanks for making it known to me!
Checking even just a small number of stripes was enough in this case,
as the expected combination (g f e d) was the only one that produced
no errors.

Now I wonder if it it would be possible to combine this approach with
something that simply hacked the metadata of each disk to re-establish
the correct disk order to make it possible to reassemble this
particular array without recreating anything. Are problems such as
mine common enough to warrant support for this kind of verified
reassembly from assumed-clean disks easier?.

-- 
Giuseppe "Oblomov" Bilotta
