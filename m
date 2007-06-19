From: Tejun Heo <htejun@gmail.com>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after
	hibernate/resume
Date: Tue, 19 Jun 2007 18:44:54 +0900
Message-ID: <4677A596.7090404@gmail.com>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com>
	<46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com>
	<20070618145007.GE85884050@sgi.com>
	<4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <4677A0C7.4000306@dgreaves.com>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>
List-Id: linux-raid.ids

Hello,

David Greaves wrote:
>> Good :)
> Now, not so good :)

Oh, crap.  :-)

> So I hibernated last night and resumed this morning.
> Before hibernating I froze and sync'ed. After resume I thawed it. (Sorry
> Dave)
> 
> Here are some photos of the screen during resume. This is not 100%
> reproducable - it seems to occur only if the system is shutdown for
> 30mins or so.
> 
> Tejun, I wonder if error handling during resume is problematic? I got
> the same errors in 2.6.21. I have never seen these (or any other libata)
> errors other than during resume.
> 
> http://www.dgreaves.com/pub/2.6.22-rc5-resume-failure.jpg
> (hard to read, here's one from 2.6.21
> http://www.dgreaves.com/pub/2.6.21-resume-failure.jpg

Your controller is repeatedly reporting PHY readiness changed exception.
 Are you reading the system image from the device attached to the first
SATA port?

> I _think_ I've only seen the xfs problem when a resume shows these errors.

The error handling itself tries very hard to ensure that there is no
data corruption in case of errors.  All commands which experience
exceptions are retried but if the drive itself is doing something
stupid, there's only so much the driver can do.

How reproducible is the problem?  Does the problem go away or occur more
often if you change the drive you write the memory image to?

-- 
tejun
