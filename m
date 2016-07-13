From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with assembling a stopped array
Date: Wed, 13 Jul 2016 15:57:38 -0400
Message-ID: <69b8afa7-bfeb-e85a-aba6-b6013b2302aa@turmel.org>
References: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
 <caf338d7-cc3f-0aca-e928-7619a64d888c@turmel.org>
 <CANz1=TEdGxvDo8WRfCwQy4Ymar2Oo7Ct9acBYJcz06XpaFM15w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz1=TEdGxvDo8WRfCwQy4Ymar2Oo7Ct9acBYJcz06XpaFM15w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vegard Haugland <vegard@haugland.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Vegard,

On 07/13/2016 03:11 PM, Vegard Haugland wrote:
> Hello Phil.
> 
> Thanks for taking your time to answer my post. I really appreciate it!
> 
>> You'll have to supply more detail.  Uncut mdadm -E /dev/sdXY for each
>> member device in its current state.  smartctl -iA -l scterc /dev/sdX for
>> each member device's drive.
> 
> Sure. I wrote that post at 03:23 AM local time somewhat panicked, so I
> didn't think of booting a live distro to easily get the logs you
> require.
> 
> Output from $ for x in /dev/sd?3; do mdadm --examine $x >> output_examine; done;
> 
> http://paste.debian.net/780968/

The device that's popping up as a spare every time really does have the
spare marker (role #10).  That's the drive that was partially re-added
when the array crashed again.  Just leave it out of your next attempts.

> Output from $ for x in /dev/sd?3; do echo $x >> output_smartctl;
> smartctl -iA -l scterc $x >> output_smartctl; done;
> 
> http://paste.debian.net/780967/

The key is "SCT Error Recovery Control command not supported" on most of
your drives.  In fact, upgrading model 7200.11 1T drives to your 2T
Barracudas is precisely the set of models that first bit me in the ass.
I mention that somewhere in the threads I pointed at.

The key is that you have desktop drives in a raid array, and they don't
handle read errors in a way friendly to the linux kernel -- they take
too long.  The one 7200.11 drive can be told to timeout quicker (7.0
seconds is typical for spinning disks).  The kernel will have to be told
to wait extra long for all of the others.  2-3 minutes.  Details in the
reading assignments.  The precise sequence of events that breaks MD raid
is described in the sixth:

http://marc.info/?l=linux-raid&m=133665797115876&w=2

> Note that since I booted into a live CD, the device names do no longer
> match what I wrote in my original post.

Yes, device names are not guaranteed to remain constant in linux.  MD
stores metadata in a superblock that includes array role (position) and
layout details so the name is superfluous once set up.  Getting the
roles wrong with changed device names is a key reason --create is so
dangerous.

After you get your array assembled again, I suggest you run the lsdrv[1]
script to document which drive serial numbers correspond to which array
roles.  Also consider using the --update=metadata at some point (not
now) to get away from the v0.90 metadata.  It is unreliable when used on
partitions that extend to the end of their parent device.

>> You would not believe how often we encounter reports like yours where
>> more member devices fail while trying to rebuild/resync/re-add after a
>> first failure.  There's some reading assignments for you at the at end
>> of this mail that you *must* read and understand or this array will blow
>> up again.
> 
> Of the links you posted, only the last one appeared relevant to my
> problem. If your intention was that I read these to increase my
> knowledge of md in general to avoid issues like mine from happening in
> the future, I'm happy to oblige. There were a lot of technical terms
> and details in those threads that I don't yet fully grasp, so please
> bear with me while I take my time to fully digest this. Do you
> recommend I read these in the suggested order?

Yes.  Your problem is "timeout mismatch", which is use of drives with
extended error recovery times in any linux software raid array. (I
understand hardware raid also struggles with this, but I don't know the
details.)

For now, use at every boot:

for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

You can stop doing that when you've replaced all of your desktop drives.

> Yes. I spelled out all the good drives and omitted the faulty ones.

This time, omit the drive that shows up as "spare".  Use all nine
others.  You really want nine, so the redundancy in your array can
reconstruct when it hits the UREs you obviously have.  See "Current
Pending Sector" != 0 in your smartctl reports.

After it assembles the nine, issue "mdadm --run /dev/md4" if it didn't
start.  Then "echo check >>/sys/block/md4/md/sync_action".

Wait for that to finish.  Then add the spare back to the array.

Also, in the future, paste drive reports and console output inline in
your mails, with word wrapping disabled.  That puts the details in the
archives for future googlers to find.  (This list allows ~ 100k per mail.)

Phil
