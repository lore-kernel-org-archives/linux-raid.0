From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID1 assembled broken array
Date: Tue, 15 Sep 2009 16:04:39 -0400
Message-ID: <E0075EC5-F8DC-4D53-A2F8-C8FE8B4403D9@redhat.com>
References: <h8ophd$n8p$6@ger.gmane.org> <70ed7c3e0909151224s75cd6c60kc65c2f4e9076e649@mail.gmail.com>  <1253043199.7774.179.camel@kiste> <70ed7c3e0909151243o13d1e624w2033bf37b64c987b@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-30--140027015"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909151243o13d1e624w2033bf37b64c987b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-30--140027015
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 15, 2009, at 3:43 PM, Majed B. wrote:
> Weird. I haven't seen that before on my disks/partitions.
>
> user@Adam:~$ ls -l /dev/disk/by-uuid/
> total 0
> lrwxrwxrwx 1 root root 10 2009-09-14 18:05
> cf70cb2b-8e1e-44f3-b361-4a27e169eef2 -> ../../sdi1
> lrwxrwxrwx 1 root root 10 2009-09-14 18:05
> f54698f9-72a0-4226-9ada-34af2699a25c -> ../../sdi5
>
> My array is offline at the moment, so I can't print the disks' info,
> but as you can see, each partition has its own UUID, and if each
> partition belonged to a different array then it would have a different
> UUID.

As did Matthias' setup.  However, if you fail to read the partition  
table on a device, *and* the superblock on any given partition is in  
the exact same location as it would be if you put a superblock on the  
entire device, then mdadm can get confused and think the superblock  
belongs to the entire device and not just the partition that the  
superblock is at the end of.  When that happens, it will think the  
data starts at block 0 of the drive, instead of block 0 of the  
partition and the data read will be inconsistent.  That's what  
happened to Matthias.

> Sorry for your loss :/
>
> On Tue, Sep 15, 2009 at 10:33 PM, Matthias Urlichs <matthias@urlichs.de 
> > wrote:
>> On Tue, 2009-09-15 at 22:24 +0300, Majed B. wrote:
>>> Specifying partition names may cause problems if the disk names
>>> changed. Specify the UUID instead.
>>>
>> What I was trying to say is "use a pattern that matches all of your
>> partitions and none of your actual disks". That should be safe from
>> changing disk file names.
>>
>> Besides, specifying UUIDs does not work because it runs into the  
>> exact
>> problem we're trying to solve in the first place. Behold the "blkid"
>> output from the server in question:
>>
>> /dev/sdb2: UUID="1583e643-7004-a86e-4eff-81c58ea53278" TYPE="mdraid"
>> /dev/sdb: UUID="1583e643-7004-a86e-4eff-81c58ea53278" TYPE="mdraid"
>>
>> Interestingly, for some reason it doesn't do that with /dev/sda --  
>> most
>> probably because the disks in question use different head/sector  
>> values
>> and thus have slightly different partition layout.
>>
>>
>
>
>
> -- 
>       Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-30--140027015
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqv81cACgkQg6WylM+/8ZSf6QCfZSKRZl0RwAJMh8AXZXVIhoOn
EzcAoJOlLtNEckqWQAPa49dQhYZxY6FK
=Q46I
-----END PGP SIGNATURE-----

--Apple-Mail-30--140027015--
