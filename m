From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Multipath
Date: Tue, 26 Jul 2005 19:31:00 +0200
Message-ID: <20050726173100.GZ16649@marowsky-bree.de>
References: <d01c0b6205072608305de15a6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d01c0b6205072608305de15a6f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Selim Daoud <selim.daoud@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-07-26T16:30:13, Selim Daoud <selim.daoud@gmail.com> wrote:

> I am trying to configure multipath on a Sun SE3510FC (fibre channel)
> the configuration wiht mdadm works fine and I can see or manipulat bo=
th path.
> unfortunately as soon as I mount the md device, md_multipathd process
> takes 99% of CPU and at some point, server is not accessible anymore
> it's SUSE9SP2, with qlogic 2342 HBAs

In 2.6, work has shifted to Device-Mapper multipath.

In particular if you're running SLES9 SP2, please refer to the article
on multipathing at portal.suse.com (SDB). And if you have issues which
concern your production servers, you're going to be more happy with
asking them via your support contract instead of posting to public
mailing lists where people will tell you to try a vanilla kernel instea=
d
;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
