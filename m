From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Adding a smaller drive
Date: Tue, 30 Jun 2009 14:22:20 -0400
Message-ID: <87f94c370906301122p404c5cbcg61a8dfa81ee78594@mail.gmail.com>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>
	 <4A4A4506.1070003@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A4A4506.1070003@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 30, 2009 at 1:01 PM, Bill Davidsen<davidsen@tmr.com> wrote:
> Leslie Rhorer wrote:
>>>>
<snip>
>> =A0 =A0 =A0 =A0I may have to rethink my position on using raw drives=
=2E =A0If I
>> partition the drives, I can make the partition a bit smaller than th=
e
>> whole
>> drive, allowing for the addition of a future drive whose size is a b=
it
>> off.
>> I hate to waste space, but being stuck with an undersized or limping=
 array
>> is worse.
>>
>
> Some manufacturers use the HPA (host protected area) to reduce the si=
ze
> available to the user. You will see reference to this in the dmesg ou=
tput.
> There is a tool to let you see/set HPA, but I can't put my hand on th=
e info
> right now, the one I have is out of date, so I won't mention it.

Any recent version of hdparm can get/set HPA for LBA-48 drives.  That
feature went in a couple years ago. And it is the only tool I know
that works with LBA-48 drives.  (ie. drives larger than 128 GiB).

If your version is too old you can get a new version off of
sourceforge I believe.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
http://www.norcrossgroup.com/forms/whitepapers/Forensic%20Processing%20=
of%20Exchange%20WP%20final.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
