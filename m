From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: End to end SMART to RAID repair
Date: Tue, 24 Jun 2008 07:24:26 -0400
Message-ID: <4860D96A.8040502@gmail.com>
References: <1214199855.4296.8.camel@loss.redstem.com>	 <18528.10923.329740.465179@notabene.brown> <1214265944.31695.25.camel@loss.redstem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1214265944.31695.25.camel@loss.redstem.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arthur Britto <ahbritto@iat.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Arthur Britto wrote:
> On Tue, 2008-06-24 at 08:58 +1000, Neil Brown wrote:
>  =20
>> On Sunday June 22, ahbritto@iat.com wrote:
>>    =20
>>> smartmontools (http://smartmontools.sourceforge.net/) can be config=
ured
>>> to passively scan hard drives for defects in the background.  The b=
lock
>>> numbers of pending unreadable sectors are logged via syslog.  These
>>> sectors will be remapped when written too.
>>>
>>> It would be great if this worked end to end with linux software rai=
d to
>>> automatically repair the bad sector.
>>>      =20
>> Well, you can just get md to do a scan (echo check >
>> /sys/block/mdXX/md/sync_action) and it will find any read errors and
>> correct them.
>>    =20
>
> True.  However, a SMART on disk check requires no main board
> resources. =EF=BB=BFSome drives, when idle, may do background checkin=
g anyway.
> This would provide a way to correct the error without needing to scan
> the whole volume and other components with an md check.  Error checki=
ng
> may be less intrusive (vs retries to the exclusion of other work) tha=
n
> normal for an attempted sector read.  At least manufactures have the
> option to give priority to actual read requests over background defec=
t
> checking.
>  =20

This is almost always the case with disk arrays for example.
>  =20
>> Extracting numbers from syslog is a fairly messy thing to try to do.
>> Maybe if smartmontools could report these in some other way -
>> e.g. run a program giving device and block number, we could write a
>> script that feeds that info to md.
>> We would need to map the device+offset to partition+offset, then fin=
d
>> out if that is a member of an md array, then request a limited-range
>> 'check', which I think is possible with current code...
>>
>> Do you know if smartmontools can provide this info in a more
>> controlled way?
>>    =20
>
> I was thinking, a non-smartmontools specific method would be best.  T=
hat
> is: (1) some way for the md driver to request notification about pend=
ing
> uncorrected read errors from a region of a block device and (2) some =
way
> for a trusted application to inform the kernel about pending uncorrec=
ted
> read errors (e.g. echo "start-stop > /sys/...").
>
> -Arthur
>
>  =20

One thing that you can do that is much less invasive is to use the "rea=
d=20
verify" command to scan the platter of the disk at a fairly low rate.

Read verify does not transfer data from the disk to the host and you ca=
n=20
issue fairly large requests (say 1MB at a time) as a background task pe=
r=20
drive. What you will get out of this is a validation that nothing has=20
failed at the disk sector level (i.e., each sector is still readable).=20
On detection of an error, you can go back and try to pin point the=20
failed sector with small IO's and then try to repair the damage with a=20
write (say from the other mirror in a RAID1 device).

This is useful, but is not an end to end data integrity check (like=20
Martin's T10 DIF work that was posted).

In general, it would also be really neat to figure out and API which=20
would let a higher level application (or file system) inform the block=20
level of an error and possibly ask for a read from another mirror.

ric

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
