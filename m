From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Raid-1 on top of multipath
Date: Tue, 8 May 2007 11:52:07 +0200
Message-ID: <20070508095207.GF7053@marowsky-bree.de>
References: <2282.68.254.47.243.1177099055.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2282.68.254.47.243.1177099055.squirrel@bymeinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rob Bray <raid@bymeinc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2007-04-20T15:57:35, Rob Bray <raid@bymeinc.com> wrote:

> I'm attempting to do host-based mirroring with one LUN on each of two=
 EMC
> CX storage units, each with two service processors. Connection is via
> Emulex LP9802, using lpfc driver, and sg.

Use dm-multipath (multipath-tools package), not md multipath. And then
md-raid1 on top. That works.


Sincerely,
    Lars

--=20
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wil=
de

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
