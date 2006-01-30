From: Wade Pinkston <blata@bugs.osu.edu>
Subject: Re: raid not creating
Date: Sun, 29 Jan 2006 18:29:59 -0800
Message-ID: <43DD7A27.6070806@bugs.osu.edu>
References: <57285.192.55.52.1.1138383357.squirrel@bugs.osu.edu>	<17370.35932.856350.327787@cse.unsw.edu.au>	<43DAD418.9040803@bugs.osu.edu> <17373.14913.427109.184586@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17373.14913.427109.184586@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Neil Brown wrote:
> On Friday January 27, blata@bugs.osu.edu wrote:
> 
> Please don't take a discussion off a mailing list once it has started
> there.  Other people might be listening, and it is useful to have any
> answers in the archives.
> 
> So if you want further help on this, please continue to send your mail
> to linux-raid@vger.kernel.org.
> 
> NeilBrown
> 
> 
> 
> 
> 
> Neil Brown wrote:
> 
>>On Friday January 27, blata@bugs.osu.edu wrote:
> 
> 
>>># mdadm --create --verbose /dev/md4 --level=1 --raid-devices=2 /dev/hde3
>>>/dev/hdg3
>>>mdadm: /dev/hde3 appears to contain an ext2fs file system
>>>   size=35214480K  mtime=Thu Jan 26 13:38:20 2006
>>>mdadm: /dev/hdg3 appears to contain an ext2fs file system
>>>   size=35214480K  mtime=Thu Jan 26 13:38:20 2006
>>>mdadm: size set to 35214400K
>>>Continue creating array? y
>>>mdadm: SET_ARRAY_INFO failed for /dev/md4: Device or resource busy
> 
> 
>>Sounds like /dev/md4 already exists.  What does
>>  cat /proc/mdstat
>>show?
> 
>>NeilBrown
> 
> 
> cat /proc/mdstat
> Personalities :
> md2 : inactive hdc3[0]
>       8723200 blocks
> md3 : inactive hdg1[0]
>       61440448 blocks
> md4 : inactive hdg3[0]
>       35214400 blocks
> md1 : inactive hdc2[0]
>       20482752 blocks
> md0 : inactive hdc1[0]
>       104320 blocks
> unused devices: <none>
> 
> I got this only after doing the following.
> 
> mdadm --manage --add /dev/md2 /dev/hdc3
> 
> for each md device.  If I then go back and try to add /dev/hda1 to the md0
> I get this.
> 
> mdadm --manage --add /dev/md0 /dev/hda1
> mdadm: add new device failed for /dev/hda1: Device or resource busy
> 
> this email includes all new informaiton for me.  but I still am unable to
> add the drives with the actual data on them.
> 
sorry didn't realize just responding took the tread off list.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD3Xonv+6+qSFv3TURAuKiAJ9nIYIcWcRfUycNGLg49H7WIKbIBgCgpKte
R+zZ9W1/KAJH4If+ncNdo5E=
=/n3B
-----END PGP SIGNATURE-----
