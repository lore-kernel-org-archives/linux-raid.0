From: Tim Small <tim@buttersideup.com>
Subject: Re: RAID 5 questions
Date: Wed, 04 Aug 2004 09:52:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4110A3B4.8020009@buttersideup.com>
References: <1091325475.2374.11.camel@localhost> <20040801033109.GA23032@jim.sh> <410DD8AA.6060609@softers.net> <20040802060939.GA12472@jim.sh> <410DECC6.6040403@softers.net> <20040803202334.GB5148@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040803202334.GB5148@janus>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Frank van Maarseveen wrote:

>try running lilo with -v -v -v
>
>Then you might see the BIOS drive number, geometry it assumes etc. You
>will probably see only _one_ disk and in that case your system boots
>by sheer luck.
>
>With -v -v -v I discovered why my system refused to boot from raid 1.
>It appears to actually boot from the first disk in the raid set, e.g:
>
>	md1 : active raid1 hdg1[1] hda1[0]
>				   ^^^^^^^
>
>This is mounted on /boot and lilo will boot from hda1 (bios disk 0x80).
>I had to reassemble the raid set in opposite order to get this because
>hdg is unbootable (lilo assumed bios drive 0x81). But maybe my lilo is
>old (21.4-4).
>
>  
>
You can do this sort of thing to override lilo's idea of which linux 
device maps to which BIOS disk number e.g. I use this on one box:

disk=/dev/hda
        bios=0x80
boot=/dev/hda

#disk=/dev/hdf
#       bios=0x80
#boot=/dev/hdf

# Specifies the device that should be mounted as root. (`/')
#
root=/dev/md3


I run lilo twice (once with the hda lines uncommented, and once with the 
hdf lines uncommented) - so that the system will still boot with hda 
pulled from the machine - with hda broken, the machine still won't boot, 
but at least you can disconnect hda at that point, or disable it in the 
BIOS (so that hdf becomes 0x80)...

You can do a similar thing with grub, but with the advantage that you 
don't have to play around with the config file every time you upgrade 
the kernel (you could use two different lilo.conf's I suppose)...

I'm not sure if this has already been stated (Frank just implied it), 
but a simple workaround to the original problem is to make a small RAID1 
/boot partition on a couple of the disks, and have the rest of the 
drives carved up as RAID5, and I think that if you're using lilo to load 
the kernel off RAID5, then you're being lucky (AFAIK).

e.g. I sometimes do this:

drive1   drive2  drive3   drive4
[ boot(raid1) ]  [ swap(raid1) ]
[     more-swap (raid5)        ]
[        /root  (raid5)        ]
[        /other (raid5)        ]


Tim.

