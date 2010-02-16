From: Luca Berra <bluca@comedia.it>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 20:38:07 +0100
Message-ID: <20100216193806.GA873@maude.comedia.it>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002142013.24922.volkerarmin@googlemail.com> <4B7AAB8D.9030009@anonymous.org.uk> <201002161537.08487.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201002161537.08487.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 16, 2010 at 03:37:08PM +0100, Volker Armin Hemmann wrote:
>so assume you have an initrd and metadata 1.x without auto assembling.
>
>You do some changes to the raid and screw up something else. Next boot nothing 
>works. Mostly because the mdadm.conf in your initrd is not correct.
>
>You whip out your trusty usb stick with a resuce system - and you are stuck. 
>If autoassembling would work, you would have working md devices you could 
>mount and edit the files you have to. But you don't and the mdadm.conf in the 
>initrd is outdated.
>
>Sounds like 'you are screwed'.

did you ever try this?
mdadm is able to activate an array without need of any configuration
file.
The reason a configuration file is copied in initrd is solely to
preserve non-default activation parameters (i.e. array name) and such.

>And that because ...? Is there any good reason not to have autoassmbling in 
>the kernel?

about the same reason why the X server is not in the kernel as well.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
