From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Re: Online resize
Date: Tue, 29 Apr 2008 09:30:19 +0200
Message-ID: <200804290930.19645.wayne@flashmedia.co.za>
References: <200803111119.56015.wayne@flashmedia.co.za> <18454.29469.343413.701176@notabene.brown>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18454.29469.343413.701176@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 29 April 2008 03:00:13 Neil Brown wrote:
> On Tuesday March 11, wayne@flashmedia.co.za wrote:
> > Hi all
> >
> > I'd like to do an online resize for my RAID5 drives now that I've
> > upgraded them to 500GB drives. Now I'm a bit stuck. I assume the st=
eps
> > would be the following.
>
> What exactly do you mean by "now that I've upgraded them to 500GB
> drives".
> Don't tell my you got new 500GB drives, created little partitions on
> them to match the old drives, and added those to the array. =A0That i=
s
> the wrong way around.

That sounds about the way I did it. Since the hdd were so much bigger t=
han the=20
original drives I managed tho fit all 6 partitions on 2 hdd. Then creat=
ed a=20
new raid and copied everything across. Deleted the 6 partitions and gre=
w the=20
raid to fit the next 2 hdd.=20

Your way sounds easier....


--=20
Regards
Wayne=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
