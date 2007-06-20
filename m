From: Tejun Heo <htejun@gmail.com>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Date: Wed, 20 Jun 2007 17:03:34 +0900
Message-ID: <4678DF56.1020903@gmail.com>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <4677A596.7090404@gmail.com> <4677E496.3080506@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4677E496.3080506@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids

David Greaves wrote:
> Tejun Heo wrote:
>> Your controller is repeatedly reporting PHY readiness changed exception.
>>  Are you reading the system image from the device attached to the first
>> SATA port?
> 
> Yes if you mean 1st as in the one after the zero-th ...

I meant the first first (0th).

>> How reproducible is the problem?  Does the problem go away or occur more
>> often if you change the drive you write the memory image to?
> 
> I don't think there should be activity on the sda drive during resume
> itself.
> 
> [I broke my / md mirror and am using some of that for swap/resume for now]
> 
> I did change the swap/resume device to sdd2 (different controller,
> onboard sata_via) and there was no EH during resume. The system seemed
> OK, wrote a few Gb of video and did a kernel compile.
> I repeated this test, no EH during resume, no problems.
> I even ran xfs_fsr, the defragment utility, to stress the fs.
> 
> I retain this configuration and try again tonight but it looks like
> there _may_ be a link between EH during resume and my problems...
> 
> Of course, I don't understand why it *should* EH during resume, it
> doesn't during boot or normal operation...

EH occurs during boot, suspend and resume all the time.  It just runs in
quiet mode to avoid disturbing the users too much.  In your case, EH is
kicking in due to actual exception conditions so it's being verbose to
give clue about what's going on.

It's really weird tho.  The PHY RDY status changed events are coming
from the device which is NOT used while resuming and it's before any
actual PM events are triggered.  Your kernel just boots, swsusp realizes
it's resuming and tries to read memory image from the swap device.
While reading, the disk controller raises consecutive PHY readiness
changed interrupts.  EH recovers them alright but the end result seems
to indicate that the loaded image is corrupt.

So, there's no device suspend/resume code involved at all.  The kernel
just booted and is trying to read data from the drive.  Please try with
only the first drive attached and see what happens.

Thanks.

-- 
tejun
