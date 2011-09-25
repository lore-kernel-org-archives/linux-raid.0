From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 16:16:43 +0200
Message-ID: <4E7F37CB.5030900@yazzy.org>
References: <4E7EDE58.3000804@yazzy.org> <4E7F297C.9070403@turmel.org>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F297C.9070403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/11 3:15 PM, Phil Turmel wrote:
> On 09/25/2011 03:55 AM, Marcin M. Jessa wrote:
[...]

>> [5]: http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superblock
>
> These instructions are horrible!  If you make the slightest mistake, your data is completely hosed.

Do you know of a better howto ? I was desperate googling a lot, trying 
to run different commands first in order to rebuild my raid array, but 
with no luck. The only howto that started resyncing was the wikipedia 
one I linked to...

> If first asks for your "mdadm -E" reports from the drives, but it has you filter them through a grep that throws away important information.  (Did you keep that report?)

No, unfortunately I did not.

> Next, it has you wipe the superblocks on the array members, destroying all possibility of future forensics.
> Then, it has you re-create the array, but omits "--assume-clean", so the array rebuilds.  With the slightest mistake in superblock type, chunk size, layout, alignment, data offset, or device order, the rebuild will trash your data.  Default values for some of those have changed in mdadm from version to version, so a naive "--create" command has a good chance of getting something wrong.

I tried to run mdadm --assemble --assume-clean /dev/md0 /dev/sd[f-j]1 
but that AFAIR only said that the devices which still were members of 
the array and were still working were busy. I always stoped the array 
before running it.

> There is no mention of attempting "--assemble --force" with your original superblocks, which is the correct first step in this situation.  And it nearly always works.

I also tried running - with no luck:
  # mdadm --assemble --force --scan /dev/md0
  # mdadm --assemble --force /dev/md0 /dev/sde1 /dev/sdf1 /dev/sdg1 
/dev/sdi1
  # mdadm --assemble --force --run /dev/md0 /dev/sde1 /dev/sdf1 
/dev/sdg1 /dev/sdi1
and
  # mdadm --assemble /dev/md0 --uuid=9f1b28cb:9efcd750:324cd77a:b318ed33 
  --force


> I'm sorry, Marcin, but you shouldn't expect to get your data back.  Per your "mdadm -D" report, the rebuild was already 63% done, so the destruction of your data is certainly complete now.

Oh sh** ! :( Really, there is nothing that can be done? What happened 
when I started resyncing? I thought the good, working drives would get 
the data syneced with the one of drives which failed (it did not really 
fail, it was up after reboot and smartctl --attributes --log=selftest 
shows it's healthy).


-- 

Marcin M. Jessa
