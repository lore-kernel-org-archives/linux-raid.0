From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: mdadm raid1 read performance
Date: Thu, 05 May 2011 11:06:09 +0300
Message-ID: <4DC25A71.6090705@oldum.net>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>	<20110504105822.21e23bc3@notabene.brown>	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>	<4DC0F2B6.9050708@fnarfbargle.com>	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com> <20110505100610.66c93e08@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110505100610.66c93e08@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Liam Kurmos <quantum.leaf@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
It seems like he is reading directly from the raid device and not through the filesystem. So there are no filesystem
caches in this way.

Cheers,
- -Nik

On 05/05/2011 07:06 AM, Roman Mamedov wrote:
> On Thu, 5 May 2011 00:08:59 +0100
> Liam Kurmos <quantum.leaf@gmail.com> wrote:
> 
>> in my tests i read 1GB and throw away the data.
>> dd if=/dev/md0 of=/dev/null bs=1M count=1000
> 
> If you have enough RAM for disk cache, on the second and further consecutive
> invocations of this you will be reading mostly from the cache, giving you an
> incorrect inflated result. So either don't forget to drop filesystem caches
> between runs, or just test read performance with "hdparm -t /dev/mdX" instead.
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJNwlpxAAoJEDFLYVOGGjgXHS0IAJAVFwR0Y0SD6G4CTaViqNCv
32s/VCZWTZMzXiLOrY5xCGFiuqPurmGLy/+aW+HeEYShMndkZQ8H8ZHlSx5L3OoH
SQnWS7gP5hUn2w9qamhtFk9iPWpx18ZzVqN/k9WyAWhY4Ro20G8PWI3/T4Q3+zam
WYJ6KglllX+BuQYVhmhwB1KGVFhmpQXBXKWVrcGIB7vyGnM5K9fWLbxd6VvghZvd
qpfrmPO2WvuqpxCS+YcZTqEg7osbzNB+W/6DMJ7BpxyUcxIEyXwBwZSUxsZe3WWo
oTfj0XUaVc17TPfKMCyLfgm+K6f+IJfKky5e5mJyFCjesDhqFngkpilft9xNxq0=
=qsmJ
-----END PGP SIGNATURE-----
