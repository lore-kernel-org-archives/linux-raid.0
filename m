From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: raid1 with nbd member hangs MD on SLES10 and RHEL5
Date: Thu, 14 Jun 2007 21:01:19 -0400
Message-ID: <170fa0d20706141801u6d6effd9ub362f3ae397f3d32@mail.gmail.com>
References: <170fa0d20706121930g3b89ddeex8b31c8923d2a0ff6@mail.gmail.com>
	 <18031.22930.243723.550238@notabene.brown>
	 <170fa0d20706121959w480213bcvaba1b6881710379f@mail.gmail.com>
	 <170fa0d20706122009h5e3db54ek7487be4940a3d780@mail.gmail.com>
	 <18031.25581.353761.802283@notabene.brown>
	 <170fa0d20706122130q2c77d365tbe9261bab1a5b1b@mail.gmail.com>
	 <170fa0d20706131123q17e4fb9ehe6be25a07462cc30@mail.gmail.com>
	 <170fa0d20706131630p6cd29aa5i8f51856780a9c691@mail.gmail.com>
	 <4671AD7C.4010109@tmr.com> <4671E018.4090105@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4671E018.4090105@steeleye.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: linux-raid.ids

On 6/14/07, Paul Clements <paul.clements@steeleye.com> wrote:
> Bill Davidsen wrote:
>
> > Second, AFAIK nbd hasn't working in a while. I haven't tried it in ages,
> > but was told it wouldn't work with smp and I kind of lost interest. If
> > Neil thinks it should work in 2.6.21 or later I'll test it, since I have
> > a machine which wants a fresh install soon, and is both backed up and
> > available.
>
> Please stop this. nbd is working perfectly fine, AFAIK. I use it every
> day, and so do 100s of our customers. What exactly is it that not's
> working? If there's a problem, please send the bug report.

Paul,

This thread details what I've experienced using MD (raid1) with 2
devices; one being a local scsi device and the other is an NBD device.
 I've yet to put effort to pinpointing the problem in a kernel.org
kernel; however both SLES10 and RHEL5 kernels appear to be hanging in
either 1) nbd or 2) the socket layer.

Here are the steps to reproduce reliably on SLES10 SP1:
1) establish a raid1 mirror (md0) using one local member (sdc1) and
one remote member (nbd0)
2) power off the remote machine, whereby severing nbd0's connection
3) perform IO to the filesystem that is on the md0 device to enduce
the MD layer to mark the nbd device as "faulty"
4) cat /proc/mdstat hangs, sysrq trace was collected

To be clear, the MD superblock update hangs indefinitely on RHEL5.
But with SLES10 it eventually succeeds after ~5min (and MD marks the
nbd0 member faulty); and the other tasks that were blocking waiting
for the MD lock (e.g. 'cat /proc/mdstat') then complete immediately.

If you look back in this thread you'll see traces for md0_raid1 for
both SLES10 and RHEL5.  I hope to try to reproduce this issue on
kernel.org 2.6.16.46 (the basis for SLES10).  If I can I'll then git
bisect back to try to pinpoint the regression; I obviously need to
verify that 2.6.16 works in this situation on SMP.

Mike
