From: Luca Berra <bluca@comedia.it>
Subject: Re: software for making initrd's with raid support
Date: Sat, 15 Mar 2008 12:49:13 +0100
Message-ID: <20080315114912.GA11426@percy.comedia.it>
References: <20080312235641.GA7109@rap.rap.dk> <20080313111538.GB4229@percy.comedia.it> <20080313130042.GA11858@rap.rap.dk> <20080314081516.GB12274@percy.comedia.it> <20080314133045.GB13616@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080314133045.GB13616@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 14, 2008 at 02:30:45PM +0100, Keld J=F8rn Simonsen wrote:
>> >Good!  I was working on a mandriva professional 2006 system 2.6.12
>> 2006.0 is EOL
>
>2006.0 professional is maintained to 2011

you mean cd4?

>> >kernel, and I hacked the mkinitrd to have it generate mdadm.conf et=
c
>> >- it did not at all look at this. I can send you my patches, but th=
ey
>> > are in no way clean.
>> mkinitrd in 2006.0 did generate mdadm.conf and use it, so i don't kn=
ow
>> what your patches were doing.
>
>the code to generate mdadm.conf was not activated. I made some patches
>to force raid code generation.

really?
if this is the case you should have submitted a bug report.

>> >There was no mention of raid10 in the code either.
>> yes support for raid10 was added after 2006.0 release
>>=20
>> >I thied to contact Erik Troan - the main author of mkinitrd (and lo=
ts of
>> >other stuff:-) - but got a bouncing message for his redhat address.
>> i think Erik does not maintain mkinitrd any more, it is quite an old
>> software.
>
>OK, who maintains it now, and is mkinitrd still a viable - perhaps the
>best - way to make initrd's?
mkinitrd is maintained by RedHat (http://www.redhat.com/)
afaik the person responsible for that package is Peter Jones.
Mandriva up to 2008.0 used a version derived from mkinitrd 4.2.17 codeb=
ase, maintained by me.
the upcoming 2008.1 will use a version derived from mkinitrd 6 codebase=
,
maintained by Olivier Blin.

>Where is the latest mkinitrd available from?
the redhat version is avaliable from any rawhide mirror
http://mirrors.fedoraproject.org/publiclist/Fedora/development/
The mandriva version from any cooker mirror
http://wiki.mandriva.com/en/CookerMirrors

>Could I use the latest mkinitrd with my 2006.0 system?
i don't think so

>> >And I was about to report this om qa.mandriva.com - but it seems th=
at I
>> >already made contact!
>> if you want a bug fixed on mandriva please send a bug report on
>> qa.mandriva.com, same applies for redhat/fedora.
>> If you have questions to ask, feel free.
>
>Is raid10,f2 supported under the latest haddrake2?

No.


--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
