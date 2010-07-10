From: Jeff Garzik <jeff@garzik.org>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Sat, 10 Jul 2010 15:23:41 -0400
Message-ID: <4C38C8BD.4050604@garzik.org>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se> <4C35A2FC.5080402@buttersideup.com> <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se> <20100708104422.GA32564@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se> <20100708232631.014a5ade@atak.bl.pg.gda.pl> <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se> <4C37FA32.8020008@wasp.net.au> <4C381BC4.9040903@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C381BC4.9040903@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Brad Campbell <brad@wasp.net.au>, Mikael Abrahamsson <swmike@swm.pp.se>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On 07/10/2010 03:05 AM, Rudy Zijlstra wrote:
> Judging from my dmesg and lsscsi on a system with both scsi and SATA,
> ataX translates into scsi X:0:0:0


There is no translation.

It is random, based on driver load order.

	Jeff



