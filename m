From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 09:54:38 +0200
Message-ID: <20090418075436.GA2124@maude.comedia.it>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090417183952.GA6090@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 17, 2009 at 08:40:14PM +0200, Piergiorgio Sartor wrote:
>My two cents on this.
>One puzzling thing of mdadm.conf is how it is created.
>In order to get it, either "mdadm --detail --scan" or
>"mdadm --examine --scan" is required.
>If I understand it correctly, the latter uses information
>from the underlining disks directly.
exactly
>Now, why this command should be run manually?
because people might want control over what is happening.
otherwise we'll might as well be running windows

>Can the "system" does it automatically on boot or on hotplug?
on hotplug udev already tries to assemble raid arrays, this is the topic
of the discussion, how to make it just work on your desktop/laptop pc,
and how to make it not break the carefully tuned setup on my server,
where i will probably never connect usb/esata array.

>The problem is that when something is changed in the array,
>the file needs to be recreated.
no, unless you misconfigure mdadm.conf

>For example, this happened to me, after growing the array it
>was not possibile anymore to restart it without rerunning
>the "--examin --scan" thing.
probably because you left some component device name in the mdadm.conf
file, don't.

>It seems to me that the usage of mdadm.conf is a bit
>fragile and looping.
>To start the array I need mdadm.conf, to create it I
not really
>need the array... (maybe alread started).
i dont see the problem

L.
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
