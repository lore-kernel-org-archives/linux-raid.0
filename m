From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Tue, 28 Oct 2003 12:00:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031028110034.GG30725@marowsky-bree.de>
References: <3F9D82F0.4000307@mvista.com> <20031027210054.GR24286@marowsky-bree.de> <3F9D8AAA.7010308@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3F9D8AAA.7010308@mvista.com>
To: Mark Bellon <mbellon@mvista.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-27T14:14:18,
   Mark Bellon <mbellon@mvista.com> said:

> The uSDE and udev are simlar in some respects. The uSDE allows for=20
> complete control of the policy handling a device - not just its namin=
g.=20

Well, so could udev in theory, and I had this plan to enhance it to do
so for the specific case of multipathing one day in the not too distant
future (ie, before q1/04).

In as far as I can see, udev and uSDE really do not have too different
goals. Competition is good, but only if they explore distinct approache=
s
;-)

> >How does this integrate with DM, md, EVMS, LVM...?
> As devices appear in sysfs the uSDE reacts to them via their hotplug=20
> events. The policy for each device handles any device issues includin=
g=20
> dealing with any device nodes.  It is possible to track and maintain=20
> multiported devices and automatically provide multipath devices nodes=
=20
> for instance.

Yes, I know that, I was asking whether you had done any discussion with
the EVMS2 folks for example to have a policy plugin to interact with
EVMS2 accordingly and do the magic.



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
