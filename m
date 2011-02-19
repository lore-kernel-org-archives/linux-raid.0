From: Larry Schwerzler <larry@schwerzler.com>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Fri, 18 Feb 2011 17:50:47 -0800
Message-ID: <AANLkTineVuCyxu9Brd030Z4McxFGdc+-KMJF1U6ekjzm@mail.gmail.com>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com> <4D5F0458.3060403@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5F0458.3060403@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 18, 2011 at 3:44 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> Larry Schwerzler put forth on 2/18/2011 2:55 PM:
>
>> 1. In my research of raid10 I very seldom hear of drive configuratio=
ns
>> with more drives then 4, are there special considerations with havin=
g
>> an 8 drive raid10 array? I understand that I'll be loosing 2TB of
>> space from my current setup, but i'm not too worried about that.
>
> This is because Linux mdraid is most popular with the hobby crowd, no=
t
> business, and most folks in this segment aren't running more than 4
> drives in a RAID 10. =A0For business solutions using embedded Linux a=
nd
> mdraid, mdraid is typically hidden from the user who isn't going to b=
e
> writing posts on the net about mdraid. =A0He calls his vendor for sup=
port.
> =A0In a nutshell, that's why you see little or no posts about mdraid =
10
> arrays larger than 4 drives.
>

Gotcha so no specific issues, thanks.

>> 2. One problem I'm having with my current setup is the esata cables
>> have been knocked loose which effectively drops 4 of my drives. I'd
>> really like to be able to survive this type of sudden drive loss. if
>
> Solve the problem then--quit kicking the cables, or secure them in a
> manner that they can't be kicked loose. =A0Or buy a new chassis that =
can
> hold all drives internally. =A0Software cannot solve or work around t=
his
> problem. =A0This is actually quite silly to ask. =A0Similarly, would =
you ask
> your car manufacturer to build a car that floats and has a propeller,
> because you keep driving off the road into ponds?

I'm working on securing the cables, but sometimes there are things
beyond your control and I'd like to protect against a possible issue,
rather then just throw up my hands and say, well this won't work, I
oviously need a whole new setup. If I can get some of the protection
from mdraid awesome, if not, well at least I'll know.

Your example is a bit off, it would be more like asking my car
manufacturer if the big button that says "float" could be used for
when I occasionally drive into ponds.

I'm not asking anyone to change the code just to protect me from my
poor buying choices, just wondering if the tool has the ability to
help me.

>
>> my drives are /dev/sd[abcdefgh] and abcd are on one esata channel
>> while efgh are on the other is there what drive order should I creat=
e
>> the array with? I'd guess /dev/sd[aebfcgdh] would that give me
>> survivability if one of my esata channels went dark?
>
> On a cheap SATA PCIe card, if one channel goes, they both typically g=
o,
> as it's a single chip solution and the PHYs are built into the chip.
> However, given your penchant for kicking cables out of their ports, y=
ou
> might physically damage the connector. =A0So you might want to create=
 the
> layout so your mirror pairs are on opposite ports.
>

Not sure if I have a cheap esata card (SANS DIGITAL HA-DAT-4ESPCIE
PCI-Express x8 SATA II) but when one of the cables has come out the
drives on the other cable work fine, so I'd guess my chipset doesn't
fall into that scenario.
I for sure want to create the pairs on opposite ports, but I was
unclear what drive order durring the create procedure would actually
do that given an f2 layout.

>> 3. One of the concerns I have with raid10 is expandability, and I'm
>> glad to see reshaping raid10 as an item on the 2011 roadmap :) Howev=
er
>> it will likely be a while before I'll see that ability in my distro
>> for a while. I did find a guide on expanding raid size when using lv=
m
>> by increasing the size of each drive and creating two partitions 1 t=
he
>> size of the original drive, and one with the remainder of the new
>> space. Once you have done this for all drives you create a new raid1=
0
>> array with the 2nd partitions on all the drives and add it to the lv=
m
>> storage group, effectively you have two raid10 arrays 1 on the first
>> half of the drives 1 on the 2nd half of the drives and the space
>> pooled together. I'm sure many of you are familiar with this scenari=
o,
>> but I'm wondering if this scenario could be problematic, is having t=
wo
>> raid10 arrays on one drive an issue?
>
> Reshaping requires you have a full good backup for when it all goes
> wrong. =A0Most home users don't keep backups. =A0If you kick the cabl=
e
> during a reshape you may hose everything and have to start over from
> scratch. =A0If you don't/won't/or can't keep a regular full backup, t=
hen
> don't do a reshape. =A0Simply add new drives, create a new mdraid if =
you
> like, make a filesystem, and mount it somewhere. =A0Others will likel=
y
> give different advice. =A0If you need to share it via samba or nfs, c=
reate
> another share. =A0For those who like everything in one "tree" you can
> simply create a new directory "inside" your current array filesystem =
and
> mount the new one there. =A0Unix is great like this. =A0Many Linux nu=
bies
> forget this capability, or never learned it.
>

I understand reshaping is tricky, and I do keep backups of the
critical data. But much of my data are movies that I own and use to
play over the network for my home media server. I don't back these up
because if I lose them all I just get to spend a lot of evenings
re-ripping the movies, which sucks but isn't as bad as losing the
photos etc.

Without the LVM raid expansion solution the expansion for me looks
like. Buy another jbod raid enclosure that holds 8 drives (or get
another computer case that holds 8 drives + system HD + dvd drive and
another mobo that can support 10 sata devices) setup the 8 new drives,
copy the data from the old drives, retire the old drives, sell the
extra jbod enclosure.

I was hoping I have the same effect withou buying the extra jbod
enclosure, but raid10 can't reshape.

>> 4. Part of the reason I'm wanting to switch is because of informatio=
n
>> I read on the "BAARF" site pointing out some of the issues in the
>> parity raid's that can cause issues that people sometimes don't thin=
k
>> about. (site: http://www.miracleas.com/BAARF/BAARF2.html) A lot of t=
he
>> information on the site is a few years old now and given how fast
>> things can change and the fact that I have not found many people
>> complaining about the parity raids I'm wondering if some/all of the
>> gotchas that they list are less of an issue now? Maybe my reasons fo=
r
>> moving to raid10 are no longer relevant?
>
> You need to worry far more about your cabling situation. =A0Kicking a
> cable out is what can/will cause data loss. =A0At this point that is =
far
> more detrimental to you than the RAID 5/6 invisible data loss issue.
>
> Always fix the big problems first. =A0The RAID level you use is the l=
east
> of yours right now.
>
> --
> Stan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
