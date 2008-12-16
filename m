From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: can I freeze I/O for some time to a given disk / md /
	dm device?
Date: Tue, 16 Dec 2008 13:01:27 +0100
Message-ID: <49479897.1080500@wpkg.org>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: Linux IDE <linux-ide@vger.kernel.org>, Linux-Raid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: linux-raid.ids

Is it possible to "freeze I/O" for some time to a given disk / md / dm 
device?

Say, "freeze I/O" so that userspace waits for any response for 30, 60 
seconds or more?

If not, is it possible to reset a link repeatedly, like ATA does when it 
hits certain disk problems? I.e., can I do the below manually?

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd 25/00:08:b8:c2:78/00:00:21:00:00/e0 tag 0 dma 4096 in
          res 40/00:00:bb:c2:78/40:00:21:00:00/e0 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link


I need this to trace a problem with a userspace application which 
segfaults when ATA resets the link repeatedly (i.e. one broken drive in 
a RAID array).


-- 
Tomasz Chmielewski
http://wpkg.org

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
