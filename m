From: Farkas Levente <lfarkas@bnap.hu>
Subject: 3ware 7500-8 controller, hardware or software raid, kernel crash
Date: Sun, 4 May 2003 14:26:26 +0200 (CEST)
Sender: ataraid-list-admin@redhat.com
Message-ID: <Pine.LNX.4.44.0305040947540.11386-100000@portal.bppiac.hu>
Reply-To: ataraid-list@redhat.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <ataraid-list-admin@redhat.com>
Errors-To: ataraid-list-admin@redhat.com
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Post: <mailto:ataraid-list@redhat.com>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
List-Unsubscribe: <https://listman.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/pipermail/ataraid-list/>
To: linux-raid@vger.kernel.org, ataraid-list@redhat.com, Adam Radford <aradford@3WARE.com>
List-Id: linux-raid.ids

hi,
we buy a 3ware 7500-8 ata raid controller.we download the latest from 
everything (firmware update linux module etc). we use redhat9 with 
kernel 2.4.20-9. compile the 3ware's kernel module for this kernel which 
has plus two more changelog entry than rh9. put 8 pieces of 120GB maxtor 
hd in it. first use them as independent disks for a few days. it works 
perfectly. after that we'd like to create a hardware raid5 array with 7 
disk and one sparedisk. we do it from the controller's bios, wait to 
finish the inicialization, boot into linux create one partition on 
/dev/sda and format it to ext3. my first question :

- can we use mkfs.ext3 -R stride=16 /dev/sda1 in this case (since hardware 
raid use 64K chunk-size) or this options only for software raid?

after we format it, start to copy back the data (about 250GB) from nfs. 
after about 2 minutes the kernel crash with some kind of io error on the 
3ware controller. unfortunately we don't have time to write down the 
kernel's error message since this is one of our production enviroment 
server. what's more I wouldn't like to buy more such card to play with if 
it's not  well functional. you can read the kernel log after that crash at 
the end of this mail.

- do anybody use this card with hardware raid5?
- is it better/faster... to use hardware raid5 or software raid5?
- with this card the hardware or the software raid5 is the better choise?
- is there any better way to copy the kernel crash messages then the paper 
and pen?
thank you for your help in advance.
yours.
 -- Levente


the kernel log after the crash:
May  3 01:05:09 red kernel: 3ware Storage Controller device driver for 
Linux v1.02.00.033.
May  3 01:05:10 red kernel: PCI: Found IRQ 9 for device 02:0a.0
May  3 01:05:10 red kernel: PCI: Sharing IRQ 9 with 02:02.0
May  3 01:05:10 red kernel: scsi0 : Found a 3ware Storage Controller at 
0x9400,IRQ: 9, P-chip: 1.3
May  3 01:05:10 red kernel: scsi0 : 3ware Storage Controller
May  3 01:05:10 red kernel: 3w-xxxx: scsi0: AEN: WARNING: Unclean shutdown 
detected: Unit #0.
May  3 01:05:10 red kernel: blk: queue c365da14, I/O limit 4095Mb (mask 
0xffffffff)
May  3 01:05:10 red kernel:   Vendor: 3ware     Model: Logical Disk 0    
Rev: 1.0
May  3 01:05:10 red kernel:   Type:   Direct-Access                      
ANSI SCSI revision: 00
May  3 01:05:10 red kernel: blk: queue c365dc14, I/O limit 4095Mb (mask 
0xffffffff)
May  3 01:05:10 red kernel: Attached scsi disk sda at scsi0, channel 0, id 
0, lun 0
May  3 01:05:11 red kernel: SCSI device sda: 1440718080 512-byte hdwr 
sectors (737648 MB)
May  3 01:05:11 red kernel:  sda: sda1

....

May  3 01:05:56 red kernel: 3w-xxxx: scsi0: AEN: INFO: Initialization 
started: Unit #0.
