From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: RE: Kernel 2.6.6 does not recognise /dev/md0 automatically
Date: Mon, 12 Jul 2004 15:41:27 +1000
Message-ID: <0C8098CA7F09CE419F0C2B68EB8358761EBA8B@exchange.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-testing=debian-testing=m.gmane.org@lists.debian.org>
Content-class: urn:content-classes:message
Resent-Message-ID: <7iMx7.A.M8B.JSi8AB@murphy>
List-Post: <mailto:debian-testing@lists.debian.org>
List-Help: <mailto:debian-testing-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-testing-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-testing-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-testing/>
To: Clement <clement@ans.com.au>
Cc: debian-testing@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Clement,
>>>Trouble is, I cannot upgrade the kernel with a simple
>>>apt-get.  It will be great if the std kernel can have this=20
>>>problem fixed.
>>>
>>>   =20
>>>
>>This does work with std kernels using initrd!  You'll need to start
off=20
>>with a custom prepared initrd as explained earlier, and load such=20
>>required modules as ide_detect and others into the initrd.  Once
you've=20
>>done that you are away and running for apt upgrades.  During the deb=20
>>package kernel_image install, the install script checks to see what
the=20
>>current kernel is using and customises the initrd accordingly=20
>(brilliant work by the package maintainers & kernel team that allows=20
>>the automatic kernel upgrade).  This is where your problem is; if you=20
>>have the modules compiled into the kernel, they won't get picked up at

>>install time by the install script and thus don't make it into the=20
>>initrd.  If the modules are loaded after boot,(e.g. like Sound modules

>>etc..) they also will be missing in the initrd.

> The initrd was customed already.  In kernel 2.4.25, there is a module=20
> ide-detect  in  kernel/drivers/ide.  However, in kernel=20
> 2.6.6, there is=20
> no such module named ide-detect or ide_detect anywhere!
>=20
This makes sense when migrating from 2.4 to 2.6 series, the two are
markedly different. I honestly can't recall if I recompiled to get the
2.6 series working.
I'd suspect it may be necessary, unless you can find the initrd modules
you require for the 2.6 kernel and add these to /etc/mkinitrd/modules
before chrooting to the raid root and using mkinitrd.

Normally you can chroot & mkinitrd, but I don't think this works quite
the same way with raid, it'd be a great timesaver if you could simply
chroot mkinitrd without the need to modify /etc/mkinitrd/modules.

Herbert Xu the package maintainer for initrd-tools is the authority on
this, I'd best not spoil his hard work with too many inaccurate rubbish
statements. =20

Perhaps someone in the linux-raid mail group can shed some light on this
and as to which kernel modules are required?

Cheers,

Lew
