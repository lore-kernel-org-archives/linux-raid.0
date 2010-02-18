From: Luca Berra <bluca@comedia.it>
Subject: Re: Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 08:51:30 +0100
Message-ID: <20100218075130.GB12592@maude.comedia.it>
References: <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com> <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com> <20100217130103.3ca65ef3@notabene.brown> <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com> <4B7BB927.5000305@grumpydevil.homelinux.org> <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com> <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm> <20100217181016.GA14983@emergent.ellipticsemi.com> <87sk8z9q0h.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87sk8z9q0h.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 18, 2010 at 04:33:34AM +0100, Goswin von Brederlow wrote:
>Nick Bowler <nbowler@elliptictech.com> writes:
>Also at least Debian doesn't (yet) support a common initramfs for their
>kernel packaging. You either build a kernel without need for one or you
>have a per kernel initramfs that is automatically build and updated
>whenever anything in the initrmafs changes. Not often, but still too
>often, the initramfs then doesn't work.
>
>Does any other distribution allow building kernel image rpms that will
>use a common initramfs for all kernels?

you can do something like this with dracut
actually you need two initrds, one kernel independant that contains
scripts and binaries
the other one, kernel dependant that contains modules (you can skip it
if you don't need modules to mount root)
then use grub commandline to load both

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
