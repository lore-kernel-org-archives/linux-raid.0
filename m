From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Fri, 29 Jun 2012 13:19:47 +0200
Message-ID: <1340968787.3472.12.camel@hoferr-desktop.hofer.rummelring>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	  <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	  <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
	  <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>
	  <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
	  <4FEA1A4F.9090605@hardwarefreak.com>
	  <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
	  <1340909075.29964.35.camel@oxygen.netxsys.com>
	 <1340955849.3461.0.camel@hoferr-desktop.hofer.rummelring>
	 <4FED805E.2010904@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FED805E.2010904@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Krzysztof Adamski <k@adamski.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fre, 2012-06-29 at 11:15 +0100, John Robinson wrote:
> On 29/06/2012 08:44, Ramon Hofer wrote:
> > On Don, 2012-06-28 at 14:44 -0400, Krzysztof Adamski wrote:
> >> You can send USR1 signal to the dd command and it will print how far it
> >> has gone, like this:
> >> # kill -USR1 <pid of dd>
> >
> > Great!
> > Thanks for that :-)
> 
> When running dd on whole discs, I usually run:
> 
> while p=`pidof dd` ; do kill -USR1 $p ; sleep 30 ; done
> 
> so I have a continuous progress monitor.

Very cool!
Thanks too :-)

