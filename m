From: Luca Berra <bluca@comedia.it>
Subject: Re: Changing MD device partition type
Date: Fri, 6 Jun 2003 08:57:04 +0200
Sender: linux-lvm-admin@sistina.com
Message-ID: <20030606065703.GB19765@percy.comedia.it>
References: <3EDFBB67.5030504@india.hp.com>
Reply-To: linux-lvm@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-lvm-admin@sistina.com>
Content-Disposition: inline
In-Reply-To: <3EDFBB67.5030504@india.hp.com>
Errors-To: linux-lvm-admin@sistina.com
List-Help: <mailto:linux-lvm-request@sistina.com?subject=help>
List-Post: <mailto:linux-lvm@sistina.com>
List-Subscribe: <http://lists.sistina.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@sistina.com?subject=subscribe>
List-Unsubscribe: <http://lists.sistina.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@sistina.com?subject=unsubscribe>
List-Archive: <http://lists.sistina.com/pipermail/linux-lvm/>
To: prakasha@india.hp.com
Cc: linux-raid@vger.kernel.org, linux-lvm@sistina.com
List-Id: linux-raid.ids

On Thu, Jun 05, 2003 at 02:51:35PM -0700, Prakash Achuthan wrote:
>I have a software RAID volume (of four 160 GB harddisk) which is to be 
>added to a separate volume group. Now, when I do a pvcreate (pvcreate 
>/dev/md3), it fails saying "Invalid phyiscal volume". All the disks in 
>the RAID volume have their partition type set to "linux auto detect". 
>One of the mails in a mailing list says that the partition type of the 
>md0 should be "8e".

nope, you cant' change the partition type and you don't need to,
the problem lies somewhere else.
lvm1 is very picky (serverely broken) about device file names,
do a lvmdiskscan and or cat /proc/partitions and check which device name
you find.
if you have devfs compiled in the kernel and not mounted lvm user tools
will NOT work.

i cc-ed lvm list which is a better place to ask elp on lvm...
regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

_______________________________________________
linux-lvm mailing list
linux-lvm@sistina.com
http://lists.sistina.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
