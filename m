From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: raid10,f2 degraded read speed
Date: Wed, 25 Jun 2008 12:31:25 -0500
Message-ID: <cccedfc60806251031q536dd88bg3cbeae703558318b@mail.gmail.com>
References: <20080617143745.GA9148@rap.rap.dk>
	 <20080625172516.GA21707@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080625172516.GA21707@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yep that's me.


On Wed, Jun 25, 2008 at 12:25 PM, Keld J=F8rn Simonsen <keld@dkuug.dk> =
wrote:
> On Tue, Jun 17, 2008 at 04:37:45PM +0200, Keld J=F8rn Simonsen wrote:
>>
>> I think I once found some benchmark (from Jon?) maybe on a Suse page
>> including various degraded raid10 arrays, even expressed in percenta=
ges
>> of normal one-disk performance. Can sombody provide a link?
>
> I found the link:
> http://pycurious.blogspot.com/2007/12/some-raid10-performance-numbers=
=2Ehtml
>
> Is this Jon Nelson writing this?
>
> I added the link + some benchmark from Bill Davidsen to the wiki page=
s
> on performance.

Neat! I'll probably be going through a rather more extensive set of tes=
ts soon.
The problem for me is that I have to test on a deployed system.
The load is insanely low, but I can't exactly try "now do it without
the LVM layer.".

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
