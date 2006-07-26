From: Luca Berra <bluca@comedia.it>
Subject: Re: host based mirror distance in a fc-based SAN environment
Date: Wed, 26 Jul 2006 22:31:14 +0200
Message-ID: <20060726203114.GD2775@percy.comedia.it>
References: <45063.212.34.68.17.1153893489.squirrel@extern.x-cellent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45063.212.34.68.17.1153893489.squirrel@extern.x-cellent.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 26, 2006 at 07:58:09AM +0200, Stefan Majer wrote:
>Hi,
>
>im curious if there are some numbers out up to which distance its possible
>to mirror (raid1) 2 FC-LUNs. We have 2 datacenters with a effective
>distance of 11km. The fabrics in one datacenter are connected to the
>fabrics in the other datacenter with 5 dark fibre both about 11km in
>distance.

as you probably already know with LX (1310nm) GBICS and single-mode fiber you can
reach up to a theoretical limit of 50Km, and you can double that using 1550 nm lasers (ZX?)

>I want to set up servers wich mirrors their LUNs across the SAN-boxen in
>both datacenters. On top of this mirrored LUN i put lvm2.
>
>So the question is does anybody have some numbers up to which distance
>this method works ?
>
the method is independent of the distance, if your FC hardware can do
that, then you can.
the only thing you should consider (and that is not directly related to
distance) is the bandwith you have between the two sites (i mean the
number of systems that might be using those 5 fibers)


Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
