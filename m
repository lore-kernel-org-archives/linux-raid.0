From: Luca Berra <bluca@comedia.it>
Subject: Re: 2.6.15: mdrun, udev -- who creates nodes?
Date: Wed, 1 Feb 2006 20:44:19 +0100
Message-ID: <20060201194419.GA14438@percy.comedia.it>
References: <43DCD614.20705@pobox.com> <20060130204231.GP19465@austin.ibm.com> <20060130204743.GA13902@wonderland.linux.it> <dro3ue$ntb$1@sea.gmane.org> <20060131192643.GU19465@austin.ibm.com> <62b0912f0601311219x78cbb29dof3768c1449bc8349@mail.gmail.com> <20060131205202.GD27268@knob.reflex> <20060131211317.GB19465@austin.ibm.com> <62b0912f0601311358t5e028beeqdc61302ade37ecf0@mail.gmail.com> <20060201092758.GQ7017@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060201092758.GQ7017@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 01, 2006 at 09:27:58AM +0000, Andy Smith wrote:
>On Tue, Jan 31, 2006 at 10:58:03PM +0100, Molle Bestefich wrote:
>> Quoting Luca Berra:
>> > the in kernel auto assembly should be removed for good
>> > it should be replaced by auto assembly in user space (mdadm),
>> > which does not suffer from the problems that in-kernel has.
>> 
>> If people could start saying
>>  "we need to get rid of in-kernel autodetection"
>> instead of
>>  "we need to get rid of autodetection",
>> I think there would be much less confusion.
>
>And force us all to use initrd/initramfs :(
>
i believe that if you looked in this ml archives you'll know you can use
the kernel command line to build an array, if you don't want to use
initrd/initramfs.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
