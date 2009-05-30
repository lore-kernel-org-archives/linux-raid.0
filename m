From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 10:06:35 -0400
Message-ID: <4A213D6B.8040501@usherbrooke.ca>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com> <4A213612.7080206@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A213612.7080206@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


John Robinson a =E9crit :
> On 30/05/2009 06:44, SandeepKsinha wrote:
>> Hi all,
>>
>> Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
>>
>> I have data of 5GB. When a disk fails and replaced with a spare disk=
=2E
>> Will the reconstruction happen only for the 5GB allocated disk block=
s
>> or it will happen for the whole disk size.
>
> The whole disc size, for now anyway; md does not currently note which=
=20
> blocks have been used by its client (the filesystem, LVM, whatever).
>
>> Is it possible to make  reconstruction intelligent enough to keep it=
=20
>> optimized ?
>
> This has been discussed in combination with supporting SSD drives'=20
> TRIM function, and would mean md had to keep track of used chunks or=20
> possibly even sectors using a bitmap or something like that, but=20
> whether anyone's working on it I don't know.
>
I don't know how it goes for Linux, but hasn't ZFS been developped=20
exactly for that purpose ? From what I understand, ZFS manage both the=20
file system and the RAID features at once. Therefore, the "raid" part=20
knows where are the files and the filesystem knows about the raid.=20
Reconstruction is then done intelligently (not reconstructing unused sp=
ace).


Maxime Boissonneault

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
