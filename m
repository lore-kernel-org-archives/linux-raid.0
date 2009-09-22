From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Full use of varying drive sizes?
Date: Tue, 22 Sep 2009 13:58:01 +0100
Message-ID: <4AB8C9D9.6060406@anonymous.org.uk>
References: <697034.10751.qm@web51302.mail.re2.yahoo.com> <73e903670909220452r2c4098c5w321f65c103b68a83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670909220452r2c4098c5w321f65c103b68a83@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/2009 12:52, Kristleifur Da=F0ason wrote:
> On Tue, Sep 22, 2009 at 11:24 AM, Jon Hardcastle
> <jd_hardcastle@yahoo.com> wrote:
>> Hey guys,
>>
>> I have an array made of many drive sizes ranging from 500GB to 1TB a=
nd I appreciate that the array can only be a multiple of the smallest -=
 I use the differing sizes as i just buy the best value drive at the ti=
me and hope that as i phase out the old drives I can '--grow' the array=
=2E That is all fine and dandy.
>>
>> But could someone tell me, did I dream that there might one day be s=
upport to allow you to actually use that unused space in the array? Bec=
ause that would be awesome! (if a little hairy re: spare drives - have =
to be the size of the largest drive in the array atleast..?) I have 3x5=
00GB 2x750GB 1x1TB so I have 1TB of completely unused space!
>=20
> Here's a thought:
> Imaginary case: Say you have a 500, a 1000 and a 1500 GB drive. You
> could JBOD the 500 and the 1000 together and mirror that against the
> 1500GB.
>=20
> Disclaimer:
> I don't know if it makes any sense to do this. I haven't seen this
> method mentioned before, IIRC. It may be too esoteric to get any
> press, or it may be simply stupid.

Sure you can do that. In Jon's case, a RAID-5 across all 6 discs using=20
the first 500GB, leaving 2 x 250GB and 1x 500GB free. The 2 x 250GB=20
could be JBOD'ed together and mirrored against the 500GB, giving anothe=
r=20
500GB of usable storage. The two md arrays can in turn be JBOD'ed or=20
perhaps better LVM'ed together.

Another approach would be to have another RAID-5 across the 3 larger=20
drives, again providing an additional 500GB of usable storage, this tim=
e=20
leaving 1 x 250GB wasted, but available if another 1TB drive was added.=
=20
I think this may be the approach Netgear's X-RAID 2 takes to using=20
mixed-size discs: http://www.readynas.com/?p=3D656

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
