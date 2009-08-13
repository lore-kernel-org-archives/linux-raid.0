From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: raid-0 with mdadm vs lvm striping
Date: Wed, 12 Aug 2009 22:40:19 -0400
Message-ID: <687B35659F854CFF970C1AB11EF9954B@m5>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com><c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com><3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com><87vdkt4e5x.fsf@frosties.localdomain><3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com><a43edf1b0908120900u32226a01w16edc9075282ee9f@mail.gmail.com> <874osc5ut5.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874osc5ut5.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Goswin von Brederlow' <goswin-v-b@web.de>, 'Billy Crook' <billycrook@gmail.com>
Cc: "'Henry, Andrew'" <andrew.henry@logica.com>, 'Drew' <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Goswin von Brederlow
} Sent: Wednesday, August 12, 2009 10:09 PM
} To: Billy Crook
} Cc: Henry, Andrew; goswin-v-b@web.de; Drew; linux-raid@vger.kernel.or=
g
} Subject: Re: raid-0 with mdadm vs lvm striping
}=20
} Billy Crook <billycrook@gmail.com> writes:
}=20
} > On Wed, Aug 12, 2009 at 04:14, Henry, Andrew<andrew.henry@logica.co=
m>
} wrote:
} >> That's what my question was: =A0Will raid0 (striping) be faster or=
 easier
} to manage than lvm striping
} >
} > LVM striping won't change performance for small files. (That is fil=
es,
} > smaller than the extent size.)  To be fair, RAID-0 striping won't
} > accelerate file access for files smaller than the stripe size eithe=
r.
} > However, traditionally, raid0 stripe sizes are much much smaller th=
an
} > LVM extent sizes.  Both are however adjustable.
}=20
} That sucks. LVM striping really should have a setting where it stripe=
s
} chunks within a PE.
}=20
} MfG
}         Goswin

Why not use this option?

-I, --stripesize StripeSize
    Gives  the  number  of  kilobytes  for  the  granularity  of the
stripes.  StripeSize must be 2^n (n =3D 2 to 9) for metadata in LVM1 fo=
rmat.
=46or  metadata  in  LVM2  format, the stripe size may be a larger powe=
r of 2
but must not exceed the physical extent size.

I have never use lvcreate with Linux, but have with HP-UX.  Looks about=
 the
same, but maybe I am confused.

Guy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
