From: "Stuart D. Gathman" <stuart@bmsi.com>
Subject: RE: Q: Online resizing ext3 FS
Date: Wed, 12 Sep 2007 16:04:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0709121600080.1583-100000@bmsred.bmsi.com>
References: <37238624DE95654997C360CA6CD36F8403B5BA13@mimas.greekattic.local>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <37238624DE95654997C360CA6CD36F8403B5BA13@mimas.greekattic.local>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 Sep 2007, Hiren Joshi wrote:

> Has anyone of you been using ext2online to resize (large) ext3
> filesystems?
> I have to do it going from 500GB to 1TB on a productive system I was
> wondering if you have some horror/success stories.
> I'm using RHEL4/U4 (kernel 2.6.9) on this system.

This brings up an LVM related question I've had.  Can I do this:

  1) take snapshot of 500GB LV
  2) resize source LV to 1TB
  3) run ext2online
  4a) resize succeeds - remove shapshot
  4b) resize fails horribly - copy shapshot to LV and restart
    4b.1) is there a way to "revert" the source LV to the snapshot?
    	(without allocating snapshot as big as source LV)

-- 
	      Stuart D. Gathman <stuart@bmsi.com>
    Business Management Systems Inc.  Phone: 703 591-0911 Fax: 703 591-6154
"Confutatis maledictis, flammis acribus addictis" - background song for
a Microsoft sponsored "Where do you want to go from here?" commercial.

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
