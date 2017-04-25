From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 12:51:59 +0200
Message-ID: <CAHKno4BPyWf_=TXBmLDxQSpC8C880vCqiw03WXp_tWmY9HtOkQ@mail.gmail.com>
References: <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de> <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de> <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de> <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de> <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de> <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-25 12:40 GMT+02:00, Patrik Dahlstr=C3=B6m <risca@powerlamerz.org>:
> 2017-04-25 11:01 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de=
>:
>> On Tue, Apr 25, 2017 at 10:44:15AM +0200, Patrik Dahlstr=C3=B6m wrote:
>> You found multiple filesystem headers, do you know the UUID it should
>> have so you're not working with some old remnant?
> The file systems looks correct:
> $ grep storage /etc/fstab
> # commented out during recovery
> #UUID=3D345ec7b8-b523-45d3-8c2e-35cda1ab62c1 /storage        ext4
> errors=3Dremount-ro 0       1
> $ file -s /dev/md0
> /dev/md0: Linux rev 1.0 ext4 filesystem data,
> UUID=3D345ec7b8-b523-45d3-8c2e-35cda1ab62c1 (extents) (64bit) (large
> files) (huge files)
> $ file -s /dev/md1
> /dev/md1: Linux rev 1.0 ext4 filesystem data,
> UUID=3D345ec7b8-b523-45d3-8c2e-35cda1ab62c1 (extents) (64bit) (large
> files) (huge files)
This actually got me thinking. During my destructive recovery
attempts, I would either don't specify a --data-offset or use
--data-offset=3D128M. Since the correct offsets are less than 128M
(123,5 MB actually), that data would be untouched in case a
reshape/rebuild was triggered by my attempts. That must explain why
the first 4 chunks of /dev/md{0,1} were identical when using correct
offset, right?
