From: Stefan *St0fF* Huebner <st0ff@gmx.net>
Subject: Re: using dd (or dd_rescue) to salvage array
Date: Mon, 06 Feb 2012 22:37:38 +0100
Message-ID: <4F304822.8000102@gmx.net>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us> <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us> <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us> <4F2D7280.8020500@stud.tu-ilmenau.de> <8q0309x4kf.ln2@goaway.wombat.san-francisco.ca.us>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8q0309x4kf.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05.02.2012 20:10, Keith Keller wrote:
> On 2012-02-04, Stefan /*St0fF*/ H=C3=BCbner<stefan.huebner@stud.tu-il=
menau.de>  wrote:
>> actually, ddrescue is THE WAY TO GO in this case.  Don't use the old
>> ddrescue, but the GNU version.  Some distros call it gddrescue, on
>> gentoo the old one is called dd-rescue and the gnu-one ddrescue.  Ju=
st
>> check it out: http://www.gnu.org/software/ddrescue/ddrescue.html
> Thanks for the advice, Stefan.  Frustratingly enough, I will get a
> chance to try GNU ddrescue despite my impatience--I originally used
> dd_rescue to try to get an image of the failing drive, and while that
> succeeded just fine (only lost 8k), the target ended up reporting ECC
> errors during the rebuild!  So I've taken a new image with ddrescue
> to a tested drive (again, losing 8k), and am hoping that it goes bett=
er.
> (At the moment I'm just attempting a one-spare rebuild, which I'm hop=
ing
> will go faster than a two-disk build, and therefore report any proble=
ms
> sooner.)
>
> I realized after reading my initial post that I wasn't 100% clear wha=
t I
> was asking.  I knew that some sort of dd would work, but I'd only don=
e
> it before in a filesystem context, and didn't know how mdraid would
> react.  So I am curious, does anyone know what I might expect when th=
e
> rebuild gets to the part on the new image where the data was lost?  W=
ill
> it just create a problem on the filesystem, or might something worse
> happen?  Should I run a check if the rebuild completes successfully?
> And will mismatch_cnt get populated by the rebuild, or would I need a
> check to expose mismatches?
>
> --keith
>
 From the logical point of view those lost 8k would create bad data -=20
i.e. a filesystem problem OR simply corrupted data.  That depends on=20
which blocks exactly are bad.  If you were using lvm it could even be=20
worse, like broken metadata.

It would be good if those 8k were "in a row" - that way at max 3=20
fs-blocks (when using 4k fs-blocksize) would be corrupted.  If you're=20
lucky, you won't even notice - like me: my system SSD broke down=20
lately.  I ddrescued as much as I could, but around 250k are gone.  I'm=
=20
dual-booting windows and gentoo and I have not yet encountered a proble=
m=20
from the missing data.  Lucky me...

Cheers,
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
