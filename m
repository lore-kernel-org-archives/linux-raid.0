From: Phil Turmel <philip@turmel.org>
Subject: Re: Is this RAID recoverable???
Date: Tue, 03 Jan 2012 08:26:08 -0500
Message-ID: <4F0301F0.40206@turmel.org>
References: <CAHw_BJ3fGd2ZN5ORs4+DSxz57AhT6jq7oL+cs_4MaztZX0sgUQ@mail.gmail.com> <20120103153757.5487e6fa@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120103153757.5487e6fa@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Paul Richter <iamcomcy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Paul, Roman,

On 01/03/2012 04:37 AM, Roman Mamedov wrote:
> On Tue, 3 Jan 2012 10:41:04 +0400
> Paul Richter <iamcomcy@gmail.com> wrote:
> 
>> Researched the net as much as possible, added this to wiki page:
>> http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superblock
> 
> Oh, so it was you who originally wrote those instructions? :)
> See http://permalink.gmane.org/gmane.linux.raid/35538

I was going to cite myself ...

> And also you probably mean http://en.wikipedia.org/w/index.php?title=Mdadm&oldid=468952888#Recovering_from_a_loss_of_raid_superblock
> because that part was nuked from the wikipedia page already.

As to the original question:  The odds are poor, but not zero.  If you
read my advice to Marcin, you know that some information from your
original array is needed.  Do you have any of it?

The array size error that mount reports suggests that you are close
to correct.  I suspect the original array was created with a different
data offset from the new array.  The default for that changed around
mdadm v2.6.9.

HTH,

Phil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8DAe4ACgkQBP+iHzflm3Ad+QCeJa7af9gammN2kGDFd+7qGMsM
rX0An0A0GXfJR3W4J0odv4LE8/rgsa+M
=8TYC
-----END PGP SIGNATURE-----
