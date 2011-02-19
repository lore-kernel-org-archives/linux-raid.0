From: Larry Schwerzler <larry@schwerzler.com>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Fri, 18 Feb 2011 17:33:24 -0800
Message-ID: <AANLkTimZNufgxapCPFa4WFQCQAmL3p5t+_6RAHfEJUSc@mail.gmail.com>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com> <4D5F190C.5050202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5F190C.5050202@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe, thanks for the info, response/questions inline.

On Fri, Feb 18, 2011 at 5:12 PM, Joe Landman <joe.landman@gmail.com> wr=
ote:
> On 02/18/2011 03:55 PM, Larry Schwerzler wrote:
>
> [...]
>
>> Questions:
>>
>> 1. In my research of raid10 I very seldom hear of drive configuratio=
ns
>> with more drives then 4, are there special considerations with havin=
g
>> an 8 drive raid10 array? I understand that I'll be loosing 2TB of
>> space from my current setup, but i'm not too worried about that.
>
> If you are going to set this up, I'd suggest a few things.
>
> 1st: try to use a PCI HBA with enough ports, not the motherboard port=
s.

I use the SANS DIGITAL HA-DAT-4ESPCIE PCI-Express x8 SATA II card with
the SANS DIGITAL TR8M-B 8 Bay SATA to eSATA (Port Multiplier) JBOD
Enclosure, so i'm most of the way there, just esata instead of sas. I
didn't realize that the esata connections had issues like this else I
would have avoided it, though at the time the extra cost of a sas card
that could expand to a total of 16 external hard drives would have
been prohibitive.

>
> 2nd: eSATA is probably not a good idea (see your issue below).
>
> 3rd: I'd suggest getting 10 drives and using 2 as hot spares. =A0Agai=
n, not
> using eSATA. =A0Use an internal PCIe card that provides a reasonable =
chip. =A0If
> you can't house the drives internal to your machine, get a x4 or x8
> JBOD/RAID cannister. =A0A single (or possibly 2) SAS cables. =A0But s=
eriously,
> lose the eSATA setup.

I may see about getting an extra drive or two to act as hot spares.

>
>>
>> 2. One problem I'm having with my current setup is the esata cables
>> have been knocked loose which effectively drops 4 of my drives. I'd
>> really like to be able to survive this type of sudden drive loss. if
>> my drives are /dev/sd[abcdefgh] and abcd are on one esata channel
>> while efgh are on the other is there what drive order should I creat=
e
>> the array with? I'd guess /dev/sd[aebfcgdh] would that give me
>> survivability if one of my esata channels went dark?
>
> Usually the on-board eSATA chips are very low cost, low bandwidth uni=
ts.
> =A0Spend another $150-200 on a dual external SAS HBA, and get the JBO=
D
> container.

I'd be interested in any specific recommendations anyone might have
for a $200 or so card and jbod enclosure that could house at least 8
drives. Off list is fine, so as to not spam the list.

I have zero experience with SAS, does it not experience the issues
that my esata setup runs into?

>
>>
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
> We'd recommend against this. =A0Too much seeking.

So the raid10 expansion solution is again to wait for raid10 reshaping
in the mdraid tools, or start from scratch.

I thought that maybe with LVM since it wouldn't be striping the data
accross the arrays, it would mostly be accessing the info from one
array at a time. I don't know enough about the way that lvm stores the
data to know different though.
>
>>
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
> Things have gotten worse. =A0The BERs are improving a bit (most reaso=
nable
> SATA drives report 1E-15 as their rate as compared with 1E-14 as prev=
iously.
> =A0Remember, 2TB =3D 1.6E13 bits. =A0So 10x 2TB drives together is 1.=
6E14 bits. =A08
> scans or rebuilds will get you to a statistical near certainty of hit=
ting an
> unrecoverable error.
>
> RAID6 buys you a little more time than RAID5, but you still have worr=
ies due
> to the time correlated second drive failure. =A0Google found a peak a=
t 1000s
> after the first drive failure (which likely corresponds to an error o=
n
> rebuild). =A0With RAID5, that second error is the end of your data. =A0=
With
> RAID6, you still have a fighting chance at recovery.
>

This i what really scares me, it seems like a false sense of security
as your drive size increases. Hoping for a better chance with raid10

>
>> Thank you in advance for any/all information given. And a big thank
>> you to Neil and the other developers of linux-raid for their efforts
>> on this great tool.
>
> Despite the occasional protestations to the contrary, MD raid is a ro=
bust
> and useful RAID layer, and not a "hobby" layer. =A0We use it extensiv=
ely, as
> do many others.
>
>
> --
> Joe Landman
> landman@scalableinformatics.com
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
