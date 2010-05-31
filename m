From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: recovering from a controller failure
Date: Mon, 31 May 2010 03:50:41 -0500
Message-ID: <89.69.28437.068730C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTike1slvwFahh4hkD2xiFngoBQrzxeoZ5Y8Fu6kK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTike1slvwFahh4hkD2xiFngoBQrzxeoZ5Y8Fu6kK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'CoolCold' <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Once the array is assembled, the repair function will re-establish =
the
> > redundancy within the array. =A0Any stripes whose data does not mat=
ch the
> > calculated value required to produce the upper layer information ar=
e
> > re-written.
> That's it - as you can see there are 15 drives in raid6 array. Examin=
e
> on disks from sda to sdh shows drives active and event count is 0.159=
,
> sdi to sdp events count is 0.168 and show that sd[a-i] are faulty. So
> I'm guessing there is no way to know which part of array is "right"
> and i guess they are desynced.

	I deleted the original e-mails while cleaning out my in box a few
hours ago, so I can't look at your original response, but I've never se=
en
fractional event counts.  Some of mine are in the millions.

	In any case, if the corruption is bad enough, you may indeed lose
some data.  Remember, however, that unless this was a brand new array, =
or
the data on the array was undergoing a truly phenomenal amount of thras=
hing,
most of the data on the drives is probably consistent, or at least
consistent enough to allow recovery.  Some, however, possibly even a la=
rge
amount, may be toast.  That's on reason why you have backups.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
