From: Luca Berra <bluca@comedia.it>
Subject: Re: draft howto on making raids for surviving a disk crash
Date: Thu, 7 Feb 2008 09:05:04 +0100
Message-ID: <20080207080503.GA7665@percy.comedia.it>
References: <20080202194131.GA7875@rap.rap.dk> <20080206090557.GA19764@percy.comedia.it> <20080206154538.GC16090@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080206154538.GC16090@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 06, 2008 at 04:45:39PM +0100, Keld J=F8rn Simonsen wrote:
>On Wed, Feb 06, 2008 at 10:05:58AM +0100, Luca Berra wrote:
>> On Sat, Feb 02, 2008 at 08:41:31PM +0100, Keld J=F8rn Simonsen wrote=
:
>> >Make each of the disks bootable by lilo:
>> >
>> >  lilo -b /dev/sda /etc/lilo.conf1
>> >  lilo -b /dev/sdb /etc/lilo.conf2
>> There should be no need for that.
>> to achieve the above effect with lilo you use
>> raid-extra-boot=3Dmbr-only
>> in lilo.conf
>>=20
>> >Make each of the disks bootable by grub
>> install grub with the command
>> grub-install /dev/md0
>
>I have already changed the text on the wiki. Still I am not convinced =
it=20
>is the best advice that is described.
>
lilo -b /dev/md0 (without a raid-extra-boot line in lilo.conf) will
install lilo on the boot sector of the partitions containing /dev/md0
(and it will break with 1.1 sb)

for grub, do you have any doubt about the grub-install script not
working correctly?

L.

--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
