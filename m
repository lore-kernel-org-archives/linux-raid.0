From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: monitoring multipath arrays plus inconsistent /proc/mdstat?
Date: Fri, 22 Oct 2004 07:41:37 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0410220739480.13142-100000@lajli.gau.hu>
References: <20041021165119.GU3911@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041021165119.GU3911@marowsky-bree.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Oct 2004, Lars Marowsky-Bree wrote:

> On 2004-10-21T12:16:17, Anu Matthew <anu.matthew@bms.com> wrote:
>
> > Whom to trust here? How do we monitor multipath arrays effectively?
>
> On 2.6, use multipath-tools, which are seeing active development.
> multipath storage is being moved to the Device-Mapper in 2.6.

Is it stable? the version number increasing quite rapidly...
I woud like to use it with emc clariion, dual HBA (qlogic) environment.
Afaik emc powerpath dont's support 2.6.x kernels, is it?

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
             optimism is having a ups on a win95 box

