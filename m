From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 10:38:13 +0000
Message-ID: <AANLkTimF5ExS7Wo_JK5Ap9KSFzDNJjNWk8davnLB70zZ@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5ACE4B.9040309@gmail.com>
	<4D5AD613.3040402@turmel.org>
	<20110216004524.67abe977@natsu>
	<AANLkTikLWmC1u3rMFktwULgSPh-zL+D-xgcyogcJfqnP@mail.gmail.com>
	<20110217204221.7a865364@natsu>
	<4D5E383D.9010608@gmail.com>
	<20110218093804.GA2405@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218093804.GA2405@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Simon McNair <simonmcnair@gmail.com>, Roman Mamedov <rm@romanrm.ru>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Cc: Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

Hi Robin,

proxmox:~# apt-get install e2fsprogs
Reading package lists... Done
Building dependency tree
Reading state information... Done
e2fsprogs is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 3 not upgraded.

Yeah, It's installed :-)

Simon

On 18 February 2011 09:38, Robin Hill <robin@robinhill.me.uk> wrote:
> On Fri Feb 18, 2011 at 09:13:33AM +0000, Simon McNair wrote:
>
>> Hi Roman,
>> Sorry to be so persistent on something that is not Linux raid specif=
ic,
>> but I still can't get blkid to run, the message is:
>>
>> proxmox:~# ls -la /usr/lib/debug/sbin/blkid
>> -rwx------ 1 root root 19887 2008-10-13 04:54 /usr/lib/debug/sbin/bl=
kid
>>
>> proxmox:~# /usr/lib/debug/sbin/blkid --help
>> -bash: /usr/lib/debug/sbin/blkid: cannot execute binary file
>>
>> If I can't run it directly I'm pretty sure symlinking it will not ma=
ke
>> any difference. =A0It's weird, normally when I apt-get things it mod=
ifies
>> the path etc and does everything required to make it work, I would h=
ave
>> thought if I installed a debug version of something it should add th=
e
>> debug path as well ?
>>
> I suspect that those are just the debug symbols - they're split off f=
rom
> the binary so they can be automatically pulled in when needed, but do=
n't
> bloat the application itself. =A0From the package naming, the actual =
blkid
> binary should be in the e2fsprogs package - do you have that installe=
d?
>
> Cheers,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
