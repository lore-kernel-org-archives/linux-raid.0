From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: How to fix mistake on raid: mdadm create instead of assemble?
Date: Sun, 9 Oct 2016 23:39:54 +0100
Message-ID: <57FAC73A.6020603@youngman.org.uk>
References: <CAJh8RqUaT_D3GEkj9dWGY5d4e4icUKzyidV2JTVToKN=MpCRyQ@mail.gmail.com>
 <20161008123040.GA4603@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161008123040.GA4603@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Santiago DIEZ <santiago.diez@caoba.fr>
Cc: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/10/16 13:30, Andreas Klauer wrote:
> On Fri, Oct 07, 2016 at 05:37:32PM +0200, Santiago DIEZ wrote:
>> > First thing I did is ddrescue the remaining partitions sd[abc]10 .
>> > ddrescue did not stumble into any read error so I assume all remaining
>> > partitions are perfectly safe.
> So ... don't you still have a good copy?
> 
> You only killed one of them, right? Did not make same mistake twice?
> 
>> > There comes my mistake: I ran the --create command instead of --assemble :
>> > 
>> > ================================================================================
>> > # mdadm --create --verbose /dev/md1 --raid-devices=4 --level=raid5
>> > --run --readonly /dev/loop0 /dev/loop1 /dev/loop2 missing

One oddity I've noticed. You've created the array using loop devices.
What are these?

The reason I ask is that using loopback devices is a standard technique
for rebuilding a damaged array, specifically to prevent md from actually
writing to the drive. So is it possible that "mdadm --create" only wrote
to ram, and a reboot will recover your ddrescue copies untouched?

My raid-fu isn't enough to tell me whether I'm right or not ... :-)

If necessary you'll have to do another ddrescue from the original
drives, and you should then be able to assemble the array from the
copies. Don't use "missing", use "--force" and you should get a working,
degraded, array to which you can add a new drive and rebuild the array.

mdadm --assemble /dev/md0 /dev/sd[efg]10 --force

if I'm right ... so long as it's the copies, you can always recover
again from the original disks, and if there's a problem with the copies
mdadm should complain when it assembles the array.

Cheers,
Wol
