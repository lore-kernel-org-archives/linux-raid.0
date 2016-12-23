From: NeilBrown <neilb@suse.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Sat, 24 Dec 2016 09:46:51 +1100
Message-ID: <87d1gip8kk.fsf@notabene.neil.brown.name>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com> <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com> <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com> <87k2arpmvt.fsf@notabene.neil.brown.name> <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Dec 24 2016, Giuseppe Bilotta wrote:

> On Fri, Dec 23, 2016 at 12:25 AM, NeilBrown <neilb@suse.com> wrote:
>> On Fri, Dec 23 2016, Giuseppe Bilotta wrote:
>>> I also wrote a small script to test all combinations (nothing smart,
>>> really, simply enumeration of combos, but I'll consider putting it up
>>> on the wiki as well), and I was actually surprised by the results. To
>>> test if the RAID was being re-created correctly with each combination,
>>> I used `file -s` on the RAID, and verified that the results made
>>> sense. I am surprised to find out that there are multiple combinations
>>> that make sense (note that the disk names are shifted by one compared
>>> to previous emails due a machine lockup that required a reboot and
>>> another disk butting in to a different order):
>>>
>>> trying /dev/sdd /dev/sdf /dev/sde /dev/sdg
>>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>>> (needs journal recovery) (extents) (large files) (huge files)
>>>
>>> trying /dev/sdd /dev/sdf /dev/sdg /dev/sde
>>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>>> (needs journal recovery) (extents) (large files) (huge files)
>>>
>>> trying /dev/sde /dev/sdf /dev/sdd /dev/sdg
>>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>>> (needs journal recovery) (extents) (large files) (huge files)
>>>
>>> trying /dev/sde /dev/sdf /dev/sdg /dev/sdd
>>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>>> (needs journal recovery) (extents) (large files) (huge files)
>>>
>>> trying /dev/sdg /dev/sdf /dev/sde /dev/sdd
>>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>>> (needs journal recovery) (extents) (large files) (huge files)
>>>
>>> trying /dev/sdg /dev/sdf /dev/sdd /dev/sde
>>> /dev/md111: Linux rev 1.0 ext4 filesystem data,
>>> UUID=0031565c-38dd-4445-a707-f77aef1cbf7e, volume name "oneforall"
>>> (needs journal recovery) (extents) (large files) (huge files)
>>> :
>>> So there are six out of 24 combinations that make sense, at least for
>>> the first block. I know from the pre-fail dmesg that the g-f-e-d order
>>> should be the correct one, but now I'm left wondering if there is a
>>> better way to verify this (other than manually sampling files to see
>>> if they make sense), or if the left-symmetric layout on a RAID6 simply
>>> allows some of the disk positions to be swapped without loss of data.
>
>> You script has reported all arrangements with /dev/sdf as the second
>> device.  Presumably that is where the single block you are reading
>> resides.
>
> That makes sense.
>
>> To check if a RAID6 arrangement is credible, you can try the raid6check
>> program that is include in the mdadm source release.  There is a man
>> page.
>> If the order of devices is not correct raid6check will tell you about
>> it.
>
> That's a wonderful small utility, thanks for making it known to me!
> Checking even just a small number of stripes was enough in this case,
> as the expected combination (g f e d) was the only one that produced
> no errors.
>
> Now I wonder if it it would be possible to combine this approach with
> something that simply hacked the metadata of each disk to re-establish
> the correct disk order to make it possible to reassemble this
> particular array without recreating anything. Are problems such as
> mine common enough to warrant support for this kind of verified
> reassembly from assumed-clean disks easier?.

The way I look at this sort of question is to ask "what is the root
cause?", and then "What is the best response to the consequences of that
root cause?".

In your case, I would look at the sequence of event that lead to you
needing to re-create your array, and ask "At which point could md or
mdadm done something differently?".

If you, or someone, can describe precisely how to reproduce your outcome
- so that I can reproduce it myself - then I'll happily have a look and
see at which point something different could have happened.

Until then, I think the best response to these situations is to ask for
help, and to have tools which allow details to be extract and repairs to
be made.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhdqVsACgkQOeye3VZi
gbkhwg/9GV8c99kqFEeVva+cL/8l+/KaThgjoPs/EInFNBVaeKzjDOR3A0R/1zJD
Pn+9eVDwSDrS1VxNCT5OixVtDJDg3JTkzKS34bvtwvPClNZhTd1v7Sq88E0jil3A
wKZUEynENm9LhE1uOOAQaG075ZvXfvzWA1fWv8fJWOogkzC2JlmxEERPBgkbKl7w
F5i07mDghsv/gcIdeFW/Hx4Hwsko2LNXJxiLt/zIqn+bRcZXKj4H3Wuqcz47Xm3H
26hQLF3t1jw7+RpRQnwybP6PjlhcLFiULNKVEIiNtPcDFuFqdmGExyFtq6usNHea
n4SgpkZ6F6D2vWi76TXEkosqMVwJdvv/9NthBU/MAskoiPM5l6xAN/BvewMyJSHQ
o0UoelhBIBCj963u7dwhfpwM75Jkp5ny+pfcCskK/4wV8hWHcVY+it/DmUdOpEQn
g435U0v+syCfbNPN1f4hAKNnyaIl9fXFH9MqG4f7W2l1NFmPFEoonpQ91CXz5rtW
vTjG0XIqsRGFTgnm9MHhk+o/wZDCI3cvsvcKanB9CV9mQs+ATxch4LLex1gPD22G
yLv+11MmsentFQTiBea/nUFFFBwoQPBWZtnYNSEf03w/uu2X94mbjYWu+pGpImsQ
WT1XXhy7fros7IT0/YQhgqZtLntOsG50hhu22tseiAi7UjOnXw0=
=hAo5
-----END PGP SIGNATURE-----
--=-=-=--
