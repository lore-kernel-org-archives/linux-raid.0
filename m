From: "Lars Michael Jogback" <lm@swip.net>
Subject: How does PE-size,
	RAID chunk-size and FS block-size affect eachother?
Date: Sat, 20 Mar 2004 18:48:17 +0100
Sender: linux-lvm-bounces@redhat.com
Message-ID: <a87711be70ff4540a7d61c051308528b@mail.jogback.se>
Reply-To: "lm@swip.net" <lm@swip.net>,
	LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: </archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Errors-To: linux-lvm-bounces@redhat.com
To: "linux-lvm@redhat.com" <linux-lvm@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I intend to run LVM on top on a software RAID5 on top of
8 IDE-disks (with 2MB cache) on 4 IDE-controllers (yes, I
know it's not a reliable...)

Kernel 2.4.25 is used.

I'm going to use ReiserFS as filesystem, which uses a block
size of 4k.

If I've understand this correctly I'll need to use a PE-size of
at least 32MB to be able to support LVs up to 2TB.

How do I calculate the most optimal chunk-size on this system?

Thanks in advance,
/LM




_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
