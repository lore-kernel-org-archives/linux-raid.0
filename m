From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Thu, 28 Jun 2012 14:57:37 -0500
Message-ID: <4FECB731.100@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org> <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org> <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com> <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com> <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring> <4FEA1A4F.9090605@hardwarefreak.com> <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring> <4FEAFDC5.7030205@hardwarefreak.com> <20120627211931.466b83ca@hoferr-x61s.hofer.rummelring>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120627211931.466b83ca@hoferr-x61s.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/27/2012 2:19 PM, Ramon Hofer wrote:
> 
> Ok, thanks I will. And additionally I will write down what time I
> started each command so when one of them still hasn't finished after 12
> hours or so the disk will have to be replaced right?

That's unnecessary.  Linux retains the start time of each process:

~$ ps -ef|grep dd
...
root      4338  4307 95 14:49 pts/0    00:00:48 dd if=/dev/zero of=./test
...

The 5th column shows the start time.  If the process has been running
more than 24 hours the start date will be shown instead of the start time.

> GRUB_CMDLINE_LINUX_DEFAULT="quiet elevator=deadline"
> 
> and ran
> ~# update-grub
> 
> I checked if the right scheduler is running:
> 
> ~$ cat /sys/block/sdk/queue/scheduler
> noop [deadline] cfq 
> 
> Is this correct what I did?

Yep.  The brackets surrounding deadline show it is enabled.

> And I can see if one of them behaves strangely :-)

Yep.

-- 
Stan

