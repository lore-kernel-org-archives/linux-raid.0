From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Is mdadm.conf needed?
Date: Fri, 7 Mar 2014 13:00:43 -0700
Message-ID: <B13575D2-B437-4C38-9A31-E58CCE72F189@colorremedies.com>
References: <CAJx5YvG5sA9GcPEd2D59ekg+QrRj7YGTKW=a8MMmLUWwkMo8fA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvG5sA9GcPEd2D59ekg+QrRj7YGTKW=a8MMmLUWwkMo8fA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 6, 2014, at 7:13 PM, Martin T <m4rtntns@gmail.com> wrote:

> Hi,
> 
> while most of the Linux software-RAID related tutorials suggest to
> have the mdadm.conf file up to date, then is it actually needed or
> used any more? I mean all the data needed by kernel for creating the
> RAID arrays should be stored in the superblocks, shouldn't it? Or in
> which situation the mdadm.conf is needed?

Good question. mdadm.conf is baked into the initramfs by dracut, along with mdadm, on Fedora systems. I haven't tried to willfully break it by deleting mdadm.conf and rebuilding the initramfs to see if it still works. 

I'm pretty sure it happens within the initramfs prior to the kernel even attempting to mount root. On systemd systems this could be better learned by passing systemd.log_level=debug systemd.log_target=console. The initramfs contains systemd, mdadm, mdadm.conf - and I'm pretty sure systemd activates that service, and then mdadm uses the mdadm.conf that's in the initramfs to assemble the array, and then systemd mounts it per the kernel command line which specifies root as an mduuid.


Chris Murphy

