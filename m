From: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Subject: Re: Renaming MD devices (metadata=1.1) [SOLVED]
Date: Wed, 11 Jan 2012 01:23:56 -0500
Message-ID: <4F0D2AFC.6050107@grm.polymtl.ca>
References: <4F0BD6EA.8010007@grm.polymtl.ca> <4F0C33F6.4050705@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0C33F6.4050705@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

my reply is below.


>> I have since redone these steps saving the changes in the 
>> /etc/mdadm.conf file, but after a reboot the same thing happens 
>> (despite the /etc/mdadm.conf file saying otherwise).
> 
>> So, I've run out of ideas... help?
> 
> You might just need to update your initramfs.  It needs to have its
> own copy of mdadm.conf for use before the root filesystem is 
> mounted.
> 
> I don't use CentOS or its upstream, so I'm not sure what command 
> will do this for you, but I suspect it is well documented. :-)

So what I did is:

1.- reassemble all drive updating the metadata as I explained before.
2.- re-generating a /etc/mdadm.conf file
3.- update the initramfs for my current kernel.

For CentOS, the command would be (if anyone else ever needs this):

   dracut --force

It seems to have worked!

Thanks again, I don't think I would have guessed this, and I didn't
find it written anywhere I looked (maybe it's there, but I managed to
overlook it!).

Well, I learned a whole bunch of cool things!
(between this and the udev explanation of Michal Soltys).

Have a nice week,

Gilbert
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (Darwin)
Comment: digital signature
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8NKvsACgkQOYVp1RpLsmWRoACglzwSiQbt5495OLVaiSQ+82oJ
8yAAn0VoFUu8waP33dDgFpV4/CSr65cJ
=cEbA
-----END PGP SIGNATURE-----
