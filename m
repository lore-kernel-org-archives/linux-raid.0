From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 12:43:58 -0400
Message-ID: <4E7F5A4E.2000805@turmel.org>
References: <4E7EDE58.3000804@yazzy.org> <4E7F297C.9070403@turmel.org> <4E7F37CB.5030900@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F37CB.5030900@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/25/2011 10:16 AM, Marcin M. Jessa wrote:
> On 9/25/11 3:15 PM, Phil Turmel wrote:
>> On 09/25/2011 03:55 AM, Marcin M. Jessa wrote:
> [...]
> 
>>> [5]: http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superblock
>>
>> These instructions are horrible!  If you make the slightest mistake, your data is completely hosed.
> 
> Do you know of a better howto ? I was desperate googling a lot, trying to run different commands first in order to rebuild my raid array, but with no luck. The only howto that started resyncing was the wikipedia one I linked to...

The mdadm(1) and md(7) manual pages are first.  Next would be anything on or linked from Neil Brown's blog: http://neil.brown.name/blog/mdadm

Of course, you found this list somehow.  It's the official home of mdadm development, and the primary developer, Neil Brown, is an active participant.

>> If first asks for your "mdadm -E" reports from the drives, but it has you filter them through a grep that throws away important information.  (Did you keep that report?)
> 
> No, unfortunately I did not.

Then there's no way to determine any of the original parameters of the array, nor the proper device order.  You can't rely on the device names themselves, as modern kernels try to identify drives on multiple controllers simultaneously, and slight timing changes will change what name ends up where.  Only the original superblock will have a positive ID.

>> Next, it has you wipe the superblocks on the array members, destroying all possibility of future forensics.
>> Then, it has you re-create the array, but omits "--assume-clean", so the array rebuilds.  With the slightest mistake in superblock type, chunk size, layout, alignment, data offset, or device order, the rebuild will trash your data.  Default values for some of those have changed in mdadm from version to version, so a naive "--create" command has a good chance of getting something wrong.
> 
> I tried to run mdadm --assemble --assume-clean /dev/md0 /dev/sd[f-j]1 but that AFAIR only said that the devices which still were members of the array and were still working were busy. I always stoped the array before running it.

"--assume-clean" only applies to "--create" operations, where it suppresses the starting rebuild.  This gives you the opportunity to run "fsck -n" to test whether the device order and other parameters you used results in a working filesystem.

Devices can be reported busy for a variety of reasons.  I would examine /proc/mdstat, the output of "dmsetup table", and the contents of /sys/block/.

>> There is no mention of attempting "--assemble --force" with your original superblocks, which is the correct first step in this situation.  And it nearly always works.
> 
> I also tried running - with no luck:
>  # mdadm --assemble --force --scan /dev/md0
>  # mdadm --assemble --force /dev/md0 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdi1
>  # mdadm --assemble --force --run /dev/md0 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdi1
> and
>  # mdadm --assemble /dev/md0 --uuid=9f1b28cb:9efcd750:324cd77a:b318ed33  --force

If these failed with "device busy", you never really tested whether assembly could have worked.

>> I'm sorry, Marcin, but you shouldn't expect to get your data back.  Per your "mdadm -D" report, the rebuild was already 63% done, so the destruction of your data is certainly complete now.
> 
> Oh sh** ! :( Really, there is nothing that can be done? What happened when I started resyncing? I thought the good, working drives would get the data syneced with the one of drives which failed (it did not really fail, it was up after reboot and smartctl --attributes --log=selftest shows it's healthy).

"--zero-superblock" destroys all previous knowledge of the member devices' condition, role, or history.  After that, all are considered "good", with the role specified with "--create".

Phil
