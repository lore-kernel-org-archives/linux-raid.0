From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 02:06:05 -0700
Message-ID: <201301140206.05052.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301111151.44384.thomas@fjellstrom.ca> <24DE0AA3-FAEF-4FF1-BAA5-B3A6B041C2B9@colorremedies.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24DE0AA3-FAEF-4FF1-BAA5-B3A6B041C2B9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun Jan 13, 2013, Chris Murphy wrote:
> On Jan 11, 2013, at 11:51 AM, Thomas Fjellstrom <thomas@fjellstrom.ca=
>=20
wrote:
> > On Fri Jan 11, 2013, you wrote:
> >> OK fair enough, and as asked earlier, what's the chunk size?
> >=20
> > Ah, sorry, I missed that bit. I didn't tweak the chunk size, so I h=
ave
> > the default 512K.
>=20
> OK now that the subject has been sufficiently detoured=85
>=20
> Benchmarking can perhaps help you isolate causes for problems you're
> having, but you haven't said what problems you're having.  You're usi=
ng
> benchmarking data to go looking for a problem. This is a GigE network=
 to
> the NAS? If it's wireless, who cares, all of these array numbers are
> better than wireless bandwidth and latency. If it's GigE, all of your
> sequential read write numbers exceed the bandwidth of wired. So what'=
s the
> problem? You want better random read writes? Rebuild the array with a=
 32KB
> or 64KB chunk size, knowing you may take a small hit on the larger
> sequential read/writes.

I did the "just ignore it" with my last array. This time around I figur=
ed it=20
would be a good idea to make sure everything is setup as correctly as i=
s=20
possible given the hardware I have, because once its setup, It's too la=
te to=20
fix any issues found that need changes to the lower level settings.

To me, the write performance shown so far seems quite low, which hints =
at a=20
problem that could be solved with some config change before I put it in=
to=20
"production". I would like to get it right (as I can), and learn a litt=
le in=20
the process.

> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Thomas Fjellstrom
thomas@fjellstrom.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
