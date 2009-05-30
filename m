From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 12:16:16 -0400
Message-ID: <4A215BD0.3070901@usherbrooke.ca>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com> <4A213612.7080206@anonymous.org.uk> <4A213D6B.8040501@usherbrooke.ca> <4A2154C5.6050500@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A2154C5.6050500@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


John Robinson a =E9crit :
> On 30/05/2009 15:06, Maxime Boissonneault wrote:
>> I don't know how it goes for Linux, but hasn't ZFS been developped=20
>> exactly for that purpose ? From what I understand, ZFS manage both=20
>> the file system and the RAID features at once. Therefore, the "raid"=
=20
>> part knows where are the files and the filesystem knows about the=20
>> raid. Reconstruction is then done intelligently (not reconstructing=20
>> unused space).
>
> Yes, ZFS can do this, but ext4 and md could do it too, and probably=20
> will at some point. I prefer separating the layers, then I can switch=
=20
> one and not the other, e.g. start using a hardware RAID controller=20
> instead of md.
>
> Cheers,
>
> John.
>
Chances are that the hardware controler would not be compatible with=20
mdadm and you would have to backup and copy your data anyway.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
