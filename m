From: Justin Maggard <jmaggard10@gmail.com>
Subject: Fwd: Mdadm 3.3 reshape issue
Date: Tue, 17 Sep 2013 12:38:42 -0700
Message-ID: <CAKgsxVRKq_ycu=EnfreJUEPUbUxu+jgsULi-NX24VoWiWvsZGg@mail.gmail.com>
References: <CAKgsxVTVBC7pf3--vAoxwa1LMr7E5OyGnhhwQS=-CD0FYQPUQQ@mail.gmail.com>
	<20130918011224.7840cecf@natsu>
	<CAKgsxVR26q+8CRzsZBTM5y5V1q1f5Pq8LqM82WtCpy9fp70MZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKgsxVR26q+8CRzsZBTM5y5V1q1f5Pq8LqM82WtCpy9fp70MZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 17, 2013 at 12:12 PM, Roman Mamedov <rm@romanrm.net> wrote:
>
> On Tue, 17 Sep 2013 11:56:06 -0700
> Justin Maggard <jmaggard10@gmail.com> wrote:
>
> > I'm running a SUSE SLE11-SP3 kernel
>
> Or you could have mentioned which actual kernel version you are running...
> Anyways to save people some googling and sifting through useless release
> notes, this seems to be based on Linux 3.0.76.
> Personally I'd suggest upgrading to 3.10 or 3.11.

 The version I'm running is based on 3.0.82, with lots of patches from
SUSE.  The 3.0.82 source from kernel.org doesn't have any data-offset
changing capabilities at all, and thus does not have this problem.  I
am well aware that this issue is probably specific to the SUSE SLE11
kernel, and I am positive that 3.10 or 3.11 would work fine.

-Justin
