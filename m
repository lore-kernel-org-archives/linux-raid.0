From: "Hiren Joshi" <josh@moonfruit.com>
Subject: RE: Q: Online resizing ext3 FS
Date: Wed, 12 Sep 2007 15:40:11 +0100
Message-ID: <37238624DE95654997C360CA6CD36F8403B5BA13@mimas.greekattic.local>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been fine with it, so long as you have done the ext2prepare before
hand. Otherwise you will only be able to go up to the next 16G boundary.

I asked it to skip the fsck check but I've been told this is not a good
idea....=20

-----Original Message-----
From: linux-lvm-bounces@redhat.com [mailto:linux-lvm-bounces@redhat.com]
On Behalf Of Chris Osicki
Sent: 12 September 2007 15:36
To: linux-raid@vger.kernel.org; linux-lvm@redhat.com
Subject: [linux-lvm] Q: Online resizing ext3 FS


Hi

I apologize in advance for asking a question not really appropriate for
this mailing list, but I couldn't find a better place with lots of
people managing lots of disk space.=20

The question:
Has anyone of you been using ext2online to resize (large) ext3
filesystems?
I have to do it going from 500GB to 1TB on a productive system I was
wondering if you have some horror/success stories.
I'm using RHEL4/U4 (kernel 2.6.9) on this system.

Thanks for your time.

Regards,
Chris

UNIX System Engineer
Swisscom Mobile Ltd.
Switzerland

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
