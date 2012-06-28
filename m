From: Krzysztof Adamski <k@adamski.org>
Subject: Re: Stacked array data recovery
Date: Thu, 28 Jun 2012 14:44:35 -0400
Message-ID: <1340909075.29964.35.camel@oxygen.netxsys.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	 <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	 <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
	 <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>
	 <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
	 <4FEA1A4F.9090605@hardwarefreak.com>
	 <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2012-06-27 at 11:07 +0200, Ramon Hofer wrote:

> I'm not sure if I didn't kille the dd command too early.
> Maybe it's better to let it run again. Maybe even each disk at once?
> Maybe this would already tell if a disk is faulty?

You can send USR1 signal to the dd command and it will print how far it
has gone, like this:
# kill -USR1 <pid of dd>

K

