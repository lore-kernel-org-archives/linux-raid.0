From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Fri, 29 Jun 2012 09:58:59 +0200
Message-ID: <1340956739.3461.8.camel@hoferr-desktop.hofer.rummelring>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	 <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	 <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
	 <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>
	 <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
	 <4FEA1A4F.9090605@hardwarefreak.com>
	 <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
	 <4FEAFDC5.7030205@hardwarefreak.com>
	 <20120627211931.466b83ca@hoferr-x61s.hofer.rummelring>
	 <4FECB731.100@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FECB731.100@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Don, 2012-06-28 at 14:57 -0500, Stan Hoeppner wrote:
> On 6/27/2012 2:19 PM, Ramon Hofer wrote:
> > 
> > Ok, thanks I will. And additionally I will write down what time I
> > started each command so when one of them still hasn't finished after 12
> > hours or so the disk will have to be replaced right?
> 
> That's unnecessary.  Linux retains the start time of each process:
> 
> ~$ ps -ef|grep dd
> ...
> root      4338  4307 95 14:49 pts/0    00:00:48 dd if=/dev/zero of=./test
> ...
> 
> The 5th column shows the start time.  If the process has been running
> more than 24 hours the start date will be shown instead of the start time.

Thanks for that :-)


The first drive (sdj) has finished.
I'm now dding the second (sdk). This one caused problems I think. I'll
report how it went...


Cheers
Ramon

