From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Wed, 13 Jun 2007 07:50:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706130749390.31068@p34.internal.lan>
References: <20070612072408.19140@gmx.net> <18030.19615.898281.457910@notabene.brown>
 <20070613114553.235550@gmx.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-579206122-1181735406=:31068"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070613114553.235550@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Thorsten Wolf <T_Wolf@gmx.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-579206122-1181735406=:31068
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

You don't even need that, just do this:

1. echo 'DEVICE /dev/hd*[0-9] /dev/sd*[0-9]' > mdadm.conf
2. mdadm  --examine  --scan --config=3Dmdadm.conf

This will search all partitions and give the relevant SW raid information:

ARRAY /dev/md/4 level=3Draid5 metadata=3D1 num-devices=3D5=20
UUID=3D7f453e1889:3e4dd96e:8103724c:724f49 name=3D4
ARRAY /dev/md/3 level=3Draid5 metadata=3D1 num-devices=3D4=20
UUID=3Db3d7134904:52828f3d:0f0245a2:e8226d name=3D3

Then edit these lines so they look like this:

ARRAY /dev/md3 level=3Draid5 metadata=3D1 num-devices=3D4=20
UUID=3Db3d7134904:52828f3d:0f0245a2:e8226d name=3D3
ARRAY /dev/md4 level=3Draid5 metadata=3D1 num-devices=3D5=20
UUID=3D7f453e1889:3e4dd96e:8103724c:724f49 name=3D4

Then run:

1. mdadm -As /dev/md3
2. mdadm -As /dev/md4

p34:/etc/mdadm# mdadm -As /dev/md3
mdadm: /dev/md3 has been started with 4 drives.
p34:/etc/mdadm# mdadm -As /dev/md4
mdadm: /dev/md4 has been started with 5 drives.

Done.


On Wed, 13 Jun 2007, Thorsten Wolf wrote:

> Dear Neil,
> hi everyone else.
>
> I've been reading a lot about the mdadm tools lately, and I believe that =
it is possible, but I haven't found the right documentation yet.
>
> Is it possible to re-mount the RAID I have from another Linux installatio=
n? Do I need more than the 'mdadm --detail --scan > /etc/mdadm.conf' info s=
aved to another location (so I can re-import it)?
>
> Regards,
>
> Thorsten
>
>> On Tuesday June 12, T_Wolf@gmx.net wrote:
>>> Hello everyone.
>>>
>>> I've got a SLES9 SP3 running and I've been quite happy with it so far.
>>>
>>> Recently, I've created a 4 disk spanning RAID-5 on our company
>>> server. Runs quite nice and we're happy with that too. I created
>>> that RAID using the SLES mdadm (1.4 I believe) package.
>>>
>>> After discovering that there is a much newer mdadm out here (2.6.1),
>>> I decided to upgrade. It went just fine. Raid still running at 120
>>> MB/sec.
>>>
>>> After adding a disk to the raid, which went fine as well...... BUT:
>>>
>>> The added disk /dev/sda1 shows up in /proc/mdstat, but does not have
>>> the "spare (s)" flag.
>>>
>>> Plus... the --grow doesn't work...
>>>
>>> I get the: mdadm: /dev/md0: Cannot get array details from sysfs
>>> error which has been discussed before. Can it be that this is caused
>>> by the 2.6.5-7.2xx Kernel? Any ideas?
>>
>> Yes.  All of your issues are caused by using a 2.6.5 based kernel.
>> However even upgrading to SLES10 would not get you raid5-grow.  That
>> came a little later.  You would need to compile a mainline kernel or
>> wait for SLES11.
>>
>> NeilBrown
>
> --=20
> Contact me on ICQ: 7656468
> skype://sysfried
>
> Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
> Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
---1463747160-579206122-1181735406=:31068--
