From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH] md: make the code more readable in the for-loop
Date: Mon, 09 May 2016 16:31:41 +1000
Message-ID: <87inynu4he.fsf@notabene.neil.brown.name>
References: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com> <572FCCD3.4070907@eyal.emu.id.au> <20160509035319.GA57828@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160509035319.GA57828@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, May 09 2016, Shaohua Li wrote:

> On Mon, May 09, 2016 at 09:33:39AM +1000, Eyal Lebedinsky wrote:
>> I do not see how this change makes it clearer. The original form is actually a very common and clear
>> 	scan an array in reverse order
>
> People always have different opinions for this stuff. When I read '--j' or
> 'j--', I always think extra time what the value of j is. So for me the change
> actually makes the code more readable :)

If the goal is to make the code more readable, you may as well make it:

  for (j = 0; i < ->raid_disk; j++)

That will be clearer to most people than the current code, which I don't
think is very much clearer than the original (maybe a little bit).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXMC7NAAoJEDnsnt1WYoG5fWMP/0pnQA0buSKwhCV8tKnQKkLY
eBAwHpm9Y3WF2NuXFS4p0PPBG+fCujTg96pLxskhuEG0F04sjf9I8EN63yAgkUav
bS6YRTM4mwNa+xjhzRVe0FZSOQ37aHdTyzWm4StZGcteP1c49by/M8KNHtP6mqg3
X+QEdfNKTQARWR76JLis38814xZ6XxzYEbdqI2K1xnffeC5g1XFEbP1LA/17oVpu
50FmOQGvOQLc+D/u/v4NDhcN93yGuBGWmKebecwMz70CZOFqVdqnbGe8iBryI85O
w1QfoCPVJzZ/wcPnnE3KYQaC5APlIyStTKxoPV5E7AROehAF9LIOCBACgNu3ucv+
jMmtl4b0/nipIZYUGhawIJ9xPDO+7HlTYF23wqntvbjudK/ML8xKwUxX+AvmTP24
+Ml9Wu9rx1P/DZIIQiVoJs01xDvrIfCAUNYiKM/yKvG2EBahPykswKdCB/O0D6h9
E+L9JE3+Er7M6+wYEJCVremhYrsq2BNqBa/u9JQ7jlkt23XPC4RZzqGc7xZ2Y6n+
todFTwqmSxuQikOCXkLB/N1kqtuHewMNKaFaiSoW+N/cQ+1a+oC4xto14HCaH3wa
rmqF32WtOGaTD2xnXHgz1xWf2pcyEQDB5cIT1IBzdsahFyzdC9jvxceOX/aw3PE7
QXbi3JMN0sV6IqK5xyKl
=9n3s
-----END PGP SIGNATURE-----
--=-=-=--
