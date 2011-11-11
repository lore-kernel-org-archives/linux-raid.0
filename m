From: Chris Purves <chris@northfolk.ca>
Subject: Re: unable to recover RAID 5 due to bad block [solved]
Date: Thu, 10 Nov 2011 20:15:20 -0400
Message-ID: <4EBC6918.9010405@northfolk.ca>
References: <4EBBF60F.4030606@northfolk.ca> <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net> <4EBC00E6.3030404@northfolk.ca> <20111111071142.383f10f0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111111071142.383f10f0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, =?ISO-8859-1?Q?Alexander_K=FChn?= <alexander.kuehn@nagilum.de>, jeromepoulin@gmail.com
List-Id: linux-raid.ids

On 2011-11-10 16:11, NeilBrown wrote:
> On Thu, 10 Nov 2011 12:50:46 -0400 Chris Purves<chris@northfolk.ca>  =
wrote:
>
>> On 2011-11-10 12:20, Alexander K=FChn wrote:
>>> ddrescue to the rescue!
>>> Get a another new disk, then ddrescue the one with the read error t=
o the new disk.
>>> Assemble the array using the new disk instead of the one with the r=
ead error.
>>> You will loose the blocks that can't be read of course.
>>> And in the future do run raid check/scrubbing at regular intervals.=
 ;)
>>
>> I have tried this already.  After cloning the disk with errors, I re=
placed it with the clone and tried to re-start the array using
>>
>> mdadm --assemble --force /dev/md1
>>
>> mdadm assigned the new disk as a spare and said there were only thre=
e disks to start the array and so couldn't start it.
>>
>> After I clone the disk with the error, how precisely should I re-sta=
rt the array?
>>
>>
>
> This should have worked.  So presumably some unstated requirement was=
n't met.
>
> Give details.  Names of devices, sizes of devices, "mdadm --examine" =
of
> device.  Are you using partitions or whole disk ....
>
> The best assemble command would be:
>    mdadm --assemble /dev/md1 -vv ...list...of.devices..you...want.it.=
to.include.
>
>
> NeilBrown

After ddrescue finished, I unplugged the disk with the bad sector (all =
4 KB worth), and ran mdadm --assemble --force.

This time the array started up with four disks (three old, one new).  I=
'm not sure why it didn't work the previous time; I must have done some=
thing differently.

In any case, it's working now.  Thanks to everyone for your assistance.=
  It was a big help knowing that replacing the damaged disk with a clon=
e should work.  It saved me a lot of hassle restoring from backup.  Now=
 I just need to add a fifth disk and I'll be back to normal.


--=20
Chris Purves
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
