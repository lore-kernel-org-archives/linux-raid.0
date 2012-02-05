From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: using dd (or dd_rescue) to salvage array
Date: Sun, 05 Feb 2012 11:10:32 -0800
Message-ID: <8q0309x4kf.ln2@goaway.wombat.san-francisco.ca.us>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
 <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
 <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us>
 <4F2D7280.8020500@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-02-04, Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmena=
u.de> wrote:
>
> actually, ddrescue is THE WAY TO GO in this case.  Don't use the old
> ddrescue, but the GNU version.  Some distros call it gddrescue, on
> gentoo the old one is called dd-rescue and the gnu-one ddrescue.  Jus=
t
> check it out: http://www.gnu.org/software/ddrescue/ddrescue.html

Thanks for the advice, Stefan.  Frustratingly enough, I will get a
chance to try GNU ddrescue despite my impatience--I originally used
dd_rescue to try to get an image of the failing drive, and while that
succeeded just fine (only lost 8k), the target ended up reporting ECC
errors during the rebuild!  So I've taken a new image with ddrescue
to a tested drive (again, losing 8k), and am hoping that it goes better=
=2E
(At the moment I'm just attempting a one-spare rebuild, which I'm hopin=
g
will go faster than a two-disk build, and therefore report any problems
sooner.)

I realized after reading my initial post that I wasn't 100% clear what =
I
was asking.  I knew that some sort of dd would work, but I'd only done
it before in a filesystem context, and didn't know how mdraid would
react.  So I am curious, does anyone know what I might expect when the
rebuild gets to the part on the new image where the data was lost?  Wil=
l
it just create a problem on the filesystem, or might something worse
happen?  Should I run a check if the rebuild completes successfully?
And will mismatch_cnt get populated by the rebuild, or would I need a
check to expose mismatches?

--keith

--=20
kkeller-usenet@wombat.san-francisco.ca.us


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
