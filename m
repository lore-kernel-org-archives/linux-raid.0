From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Adding a mirror to a RAID1 Device
Date: 21 Dec 2003 00:23:21 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bs3l9p$8c1$1@cesium.transmeta.com>
References: <S262074AbTKYGHX/20031125060723Z+10693@vger.kernel.org> <63168.209.233.26.53.1069741184.squirrel@sampson.crome.org> <16323.732.390200.935640@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <16323.732.390200.935640@notabene.cse.unsw.edu.au>
By author:    Neil Brown <neilb@cse.unsw.edu.au>
In newsgroup: linux.dev.raid
> 
> What you should have done is make a raid1 with 2 drives, one of which
> was missing/failed.  With mdadm, the command would be:
> 
>   mdadm -C /dev/md0 --level=raid1 --disks=2 /dev/hda3 missing
> 
> then you can hot-add the extra drive when it arrives.
> 
> What you have to do now is recreate the raid1 with two drives.  You
> will have to have the filesystem unmounted and the raid stopped, but
> you will not lose any data.
> 

For the case of RAID-1 in particular, it would be nice to be able to
hotadd drives "ad infinitum"... after all they're all the same.

	-hpa
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
