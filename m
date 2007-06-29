From: David Greaves <david@dgreaves.com>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 09:20:45 +0100
Message-ID: <4684C0DD.4080702@dgreaves.com>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <4677A596.7090404@gmail.com> <4677E496.3080506@dgreaves.com> <4678DF56.1020903@gmail.com> <467ABE25.7060303@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467ABE25.7060303@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>
Cc: David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids

David Greaves wrote:
> been away, back now...
again...

David Greaves wrote:
> When I move the swap/resume partition to a different controller (ie when 
> I broke the / mirror and used the freed space) the problem seems to go 
> away.
No, it's not gone away - but it's taking longer to show up.
I can try and put together a test loop that does work, hibernates, resumes and 
repeats but since I know it crashes at some point there doesn't seem much point 
unless I'm looking for something.
There's not much in the logs - is there any other instrumentation that people 
could suggest?
DaveC, given this is happening without (obvious) libata errors do you think it 
may be something in the XFS/md/hibernate area?

If there's anything to be tried then I'll also move to 2.6.22-rc6.


 > Tejun Heo wrote:
 >> It's really weird tho.  The PHY RDY status changed events are coming
 >> from the device which is NOT used while resuming

There is an obvious problem there though Tejun (the errors even when sda isn't 
involved in the OS boot) - can I start another thread about that issue/bug 
later? I need to reshuffle partitions so I'd rather get the hibernate working 
first and then go back to it if that's OK?

David

