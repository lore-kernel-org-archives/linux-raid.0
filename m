From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 08:38:34 -0800
Message-ID: <7bc80d500911160838r2c21448eyefd788e6c84c780@mail.gmail.com>
References: <1258381745.31633.35.camel@localhost>
	 <878we61oev.fsf@frosties.localdomain>
	 <20091116163102.GB28577@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091116163102.GB28577@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 16, 2009 at 8:31 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Mon Nov 16, 2009 at 04:26:32PM +0100, Goswin von Brederlow wrote:
>
>> What I'm aiming at is that offset might better fit into erase blocks=
,
>> cause less internal fragmentation on the disk and give better wear
>> leveling. Might improve speed and lifetime. But that is just a
>> thought. Maybe test and do ask Intel (or other vendors) about it.
>>
> I very much doubt this will make any difference. =A0With SSDs you hav=
e to
> throw out any preconceptions of internal layout you may have. =A0You =
have
> absolutely no idea (or control of) where two consecutive blocks will
> actually get written. =A0Fragmentation and seek time are thus irrelev=
ant
> (or uncontrollable anyway).
>
> I don't see how any RAID-10 layout would perform better than another
> with SSDs, unless there's internal optimisations/constraints which
> affect sequential reading from multiple devices. =A0I'm not aware of =
any
> though - RAID-10 n2 may be the same layout as RAID-1 but it's an
> entirely separate piece of code.

Don't forget that RAID-1 also does balanced reads.

--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
