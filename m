From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 13:11:28 +0200
Message-ID: <20071027111128.GE12053@percy.comedia.it>
References: <18200.63987.514073.184865@stoffel.org> <471E7DC6.7050206@tmr.com> <1193184555.10336.3.camel@firewall.xsintricity.com> <18207.56169.769976.512617@notabene.brown> <471FDEB1.8040401@garzik.org> <47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown> <4721F742.1090301@tmr.com> <1193424116.10336.281.camel@firewall.xsintricity.com> <20071026222012.GA8210@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071026222012.GA8210@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 27, 2007 at 12:20:12AM +0200, Gabor Gombas wrote:
>On Fri, Oct 26, 2007 at 02:41:56PM -0400, Doug Ledford wrote:
>
>> * When using lilo to boot from a raid device, it automatically installs
>> itself to the mbr, not to the partition.  This can not be changed.  Only
>> 0.90 and 1.0 superblock types are supported because lilo doesn't
>> understand the offset to the beginning of the fs otherwise.
>
>Huh? I have several machines that boot with LILO and the root is on
>RAID1. All install LILO to the boot sector of the mdX device (having
>"boot=/dev/mdX" in lilo.conf), while the MBR is installed by
>install-mbr. Since install-mbr has its own prompt that is displayed
>before LILO's prompt on boot, I can be pretty sure that LILO did not
>write anything to the MBR...

the behaviour is documented in lilo man page, for the
raid-extra-boot option.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
