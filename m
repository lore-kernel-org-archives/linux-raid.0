From: Tommy Apel Hansen <tommyapeldk@gmail.com>
Subject: Re: Any risk switching mdadm to static?
Date: Wed, 26 Dec 2012 20:55:55 +0100
Message-ID: <1356551755.3016.9.camel@workstation-home>
References: <CAK2H+ee_u3bc7ZgN9z9CJbuSN+8HVyeTLwRaCn5hCP1fB3w8NQ@mail.gmail.com>
	 <1356550368.3016.3.camel@workstation-home>
	 <CAK2H+efpHB-Okn_PaitAKmLPKwmn1kNZzJpEvM-BW7fWWwrZVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efpHB-Okn_PaitAKmLPKwmn1kNZzJpEvM-BW7fWWwrZVw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Mark,
Well if you need some inspiration then try and look into the genkernel
image it might help you get along, one thing you could also do is to run
through the whole examine process and let mdadm detect things along the
way, but in case you want to include the initramfs into the kernel I
would suggest to make the separate initramfs file first and confirm that
it actually works before building it into the kernel as a full rebuild
every time you want to change something might push your patience to full
extend, just saying. 

/Tommy 

On Wed, 2012-12-26 at 11:45 -0800, Mark Knecht wrote:
> On Wed, Dec 26, 2012 at 11:32 AM, Tommy Apel Hansen
> <tommyapeldk@gmail.com> wrote:
> > Hello Mark,
> > if you use genkernel initramfs you shouldn't have any problems, just
> > make sure you mdadm.conf is up to date when you ask genkernel to make
> > the initramfs, what the initramfs does it to boot your system into a
> > ramdisk and then initialize everything from there before pivoting into
> > the real OS, worst case you'll end up in a rescure shell where you can
> > start up the md's and then ask the system to use them after you exit the
> > shell.
> >
> > /Tommy
> 
> Hi Tommy,
>    OK, that's interesting info and something I hadn't considered was the
> impact of mdadm.conf. I'm not using genkernel - again, working by hand
> as a learning experience. I'd like to build the image into my kernel and
> not have it as a separate file on disk.
> 
> The kernel documentation and help on Genoo-Users has me
> considering a config file something like the following which the kernel
> build would use to create the initramfs image it includes in the
> kernel file:
> 
> dir /bin 755 0 0
> file /bin/busybox /bin/busybox 755 0 0
> slink /bin/sh busybox 777 0 0
> 
> dir /realroot 755 0 0
> dir /etc 755 0 0
> dir /proc 755 0 0
> dir /sys 755 0 0
> 
> dir /sbin 755 0 0
> file /sbin/mdadm /sbin/mdadm 755 0 0
> 
> file /sbin/e2fsck /sbin/e2fsck 755 0 0
> dir /lib 755 0 0
> file /lib/libext2fs.so /usr/lib64/libext2fs.so 755 0 0
> 
> dir /dev 755 0 0
> nod /dev/console 600 0 0 c 5 1
> nod /dev/null 666 0 0 c 1 3
> nod /dev/tty 666 0 0 c 5 0
> nod /dev/urandom 666 0 0 c 1 9
> 
> file /init /usr/src/init.sh 755 0 0
> 
> 
> 
> It sounds like I should consider adding something like
> 
> file /etc/mdadm.conf /etc/mdadm.conf 755 0 0
> 
> to that. At least I'd have the data available in case I have to
> start them by hand.
> 
> Thanks for your input!
> 
> - Mark


