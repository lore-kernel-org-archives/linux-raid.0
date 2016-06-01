From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 recovery with 6/9 drives out-of-sync
Date: Wed, 1 Jun 2016 08:06:58 -0400
Message-ID: <574ECFE2.9050602@turmel.org>
References: <C50C72C6-FC75-4863-B743-F63F09AF93B0@illinois.edu>
 <574DE3B0.8000409@turmel.org>
 <5D9C8773-D76E-409F-8961-41EB3ACD177A@illinois.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5D9C8773-D76E-409F-8961-41EB3ACD177A@illinois.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Peckins, Steven E" <speckins@illinois.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/01/2016 07:32 AM, Peckins, Steven E wrote:
>=20
> On May 31, 2016, at 2:19 PM, Phil Turmel <philip@turmel.org> wrote:
>=20
>> On 05/30/2016 10:43 PM, Peckins, Steven E wrote:
>>>
>>> The component devices in the array are supposed to be multipath dev=
ices (dm-multipath), but for some reason, when the server was restarted=
, md grabbed both dm-* components and raw devices.  I *think* that this=
 is what caused the problem.
>>
>> Quite possible.  You probably need a DEVICES clause in your mdadm.co=
nf
>> to exclude the raw devices from the arrays.
>=20
> I had a typo in the DEVICE glob for the system disks (/dev/sd[ab]* in=
stead of /dev/sd[ab][12]).

Understood, but be aware that if you have to hotswap one of these syste=
m
devices, they may not get the sda or sdb name, preventing a re-add or a
replacement from joining the array.

Since you are having to use /dev/mapper entries for some arrays,
consider using /dev/disk/by*/ symlinks for your system arrays.

>>> I'm seeking advice on how to proceed at this point.  If more inform=
ation is required, please ask.
>>
>> Hmmm.  The partial success on mdadm --force suggests trying that aga=
in.
>> Possible with --force twice on the command line.
>>
>> Forced assembly is precisely what you need -- don't despair and atte=
mpt
>> anything else.
>=20
> Repeating the command was not successful; it is still reporting "/dev=
/md10 assembled from 5 drives and 1 spare - not enough to start the arr=
ay."  Four drives are listed as =E2=80=9Cpossibly out of date."  I assu=
me those are the four that are not being incorporated.
>=20
> Output from --assemble --force 1x and 2x:  http://pastebin.com/k1dT2z=
YC

{ In the future, please paste these in-line so the archives will have
them.  The size limit for this list is ~ 100k. }

I vaguely recall a bug in forced reassembly for many out-of-date drives=
=2E
 Please clone and build the latest mdadm userspace[1] and run that mdad=
m
binary for the forced assembly.  Also show the portion of dmesg that
corresponds to the attempt.

Phil

[1] https://github.com/neilbrown/mdadm

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
