From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: monitoring multipath arrays plus inconsistent /proc/mdstat?
Date: Fri, 22 Oct 2004 11:17:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041022091719.GF3911@marowsky-bree.de>
References: <20041021165119.GU3911@marowsky-bree.de> <Pine.LNX.4.44.0410220739480.13142-100000@lajli.gau.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0410220739480.13142-100000@lajli.gau.hu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-10-22T07:41:37, Lajber Zoltan <lajbi@lajli.gau.hu> wrote:

(Your mailer is messing up the To: line. Please fix.)

> > > Whom to trust here? How do we monitor multipath arrays effectivel=
y?
> > On 2.6, use multipath-tools, which are seeing active development.
> > multipath storage is being moved to the Device-Mapper in 2.6.
> Is it stable? the version number increasing quite rapidly...

Well, it's actively being developed right now, as always.

> I woud like to use it with emc clariion, dual HBA (qlogic) environmen=
t.

EMC CLARiiON active/passive failover support is forthcoming.

> Afaik emc powerpath dont's support 2.6.x kernels, is it?

No, and as far as I know, it's not going to.

I got technical docs + a CX500 from EMC for developing the CLARiiON
support and am busy with just that (if I wasn't writing this mail ;-).

The commandline tools have already been merged upstream, so if you use
sg3_utils, you'll find that sg_inq is able to decode the EMC-specific
Unit Path Report Page and that you can manually switch
Service-Processors for a LUN using the sg_emc_trespass command.

Alasdair and I are ping-ponging patches for the dm-mpath.c, and I think
we should have it done fairly soon...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
