From: John Crisp <john@reetspetit.net>
Subject: Re: RAID 1 partition with hot spare shows [UUU] ?
Date: Wed, 18 Apr 2012 10:42:27 +0200
Message-ID: <4F8E7E73.5070909@reetspetit.net>
References: <4F8DF1EE.70402@reetspetit.net> <20120418091233.23d77dfc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418091233.23d77dfc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 18/04/12 01:12, NeilBrown wrote:
> On Wed, 18 Apr 2012 00:42:54 +0200 John Crisp wrote:
>> 
>> I don't understand how md1 shows [UUU] ??
> 
> You have a RAID1 with 3 devices.  What it difficult to comprehend
> about that.

Probably a misunderstanding of the terminology - in Hicksville where I
live mirrored usually just means a pair ;-)

> Each block is written to all three devices.

I didn't realise that a RAID 1 could have more than two devices. Most
documentation around always illustrates a RAID 1 with a pair of drives
and hence the confusion.

> 
> You don't want that?  Change it.
> 
> mdadm --grow /dev/md1 --raid-disks=4
> 
> now it has 4 devices - though one will be missing.
> 

Logical if you know it (RAID 1) can have more devices.

> mdadm --grow /dev/md1 --raid-disks=2

Illogical naming if what you actually want to do is shrink the
array............ like many things in life, once you know, you know.

> 
> now it has 2 devices.  Actually that won't work until you mark one
> of the devices as failed, so
> 
> mdadm /dev/md1 --fail /dev/sdc1 mdadm --grow /dev/md1
> --raid-disks=2
> 


And there lies the answer to my problem. For that I can't thank you
enough !

> 
> But maybe you really wanted a 3-disk RAID1 before - it is a
> configuration that certainly has a place.
> 

No I didn't, but I now understand.

> Next you'll be telling me that a RAID5 cannot be made with just 2
> devices! :-)

Me ? I know jack ...... though I know one more thing than I did
yesterday, and that is good enough for me !

Many thanks for the assistance.

B. Rgds
John
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPjn5zAAoJEPGW9QpGvPXME0sH/0p9dpJkZvWDDxP2sMjjDlE5
0xO8v3BY8frdHT803EYaQUkxOStgtkgMd8+MaZIK3M5Z8DM2BpbDuGyz39FvZ7Ai
r+TWygB2lESxgnFI1PbSeZq+qZholIpS+TD8cJ25gDImXjD9mtkN8sx/cMmcVP7k
CHzPY5cPOGCHNPC1V1BOYAU82+fjGZP8asQJT/TjUTQ/DlWuGVkDSENYGkWNY84T
a7MuF40StY6/RG1X3ETiTlk/iq2+1j7V6I+tQlTIqWyREb9T82O2YJ2HzTeN5uN7
YXc/asVRjELmIQHode/Xq9WXkGZpQskdHqLAPyP1lKc1aNyKARsyaGHKvYZj/94=
=a+Ob
-----END PGP SIGNATURE-----
