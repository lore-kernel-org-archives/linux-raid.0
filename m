From: Luca Berra <bluca@comedia.it>
Subject: Re: software for making initrd's with raid support
Date: Fri, 14 Mar 2008 09:15:16 +0100
Message-ID: <20080314081516.GB12274@percy.comedia.it>
References: <20080312235641.GA7109@rap.rap.dk> <20080313111538.GB4229@percy.comedia.it> <20080313130042.GA11858@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080313130042.GA11858@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 13, 2008 at 02:00:42PM +0100, Keld J=F8rn Simonsen wrote:
>On Thu, Mar 13, 2008 at 12:15:39PM +0100, Luca Berra wrote:
>> On Thu, Mar 13, 2008 at 12:56:41AM +0100, Keld J=F8rn Simonsen wrote=
:
>> >Hi
>> >
>> >I have been looking at making my system working with raid, and boot=
ing
>> >from raid. I succeded, but I had to hack a number of things, includ=
ing
>> >making a new initrd by hand.
>> >
>> >I used mkinitrd, but it did not treat sw raid, only in the md sense=
=2E
>> >this is a redhat/mandriva/pclinuxos(keldix thing, I wonder if it al=
so
>> >used in the dbian/ubuntu world.
>>=20
>> could you please explain what you mean in the above sentence,
>> i have being maintaining mandriva mkinitrd packages for some years, =
and
>> would really love to know.
>
>Good!  I was working on a mandriva professional 2006 system 2.6.12
2006.0 is EOL
>kernel, and I hacked the mkinitrd to have it generate mdadm.conf etc
>- it did not at all look at this. I can send you my patches, but they
>  are in no way clean.
mkinitrd in 2006.0 did generate mdadm.conf and use it, so i don't know
what your patches were doing.
>There was no mention of raid10 in the code either.
yes support for raid10 was added after 2006.0 release

>I thied to contact Erik Troan - the main author of mkinitrd (and lots =
of
>other stuff:-) - but got a bouncing message for his redhat address.
i think Erik does not maintain mkinitrd any more, it is quite an old
software.

>And I was about to report this om qa.mandriva.com - but it seems that =
I
>already made contact!
if you want a bug fixed on mandriva please send a bug report on
qa.mandriva.com, same applies for redhat/fedora.
If you have questions to ask, feel free.

L.

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
