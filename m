From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Thu, 02 Dec 2010 22:15:55 -0500
Message-ID: <4CF860EB.7010005@cfl.rr.com>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>	<4CF55680.5010703@cfl.rr.com>	<20101201092508.7023f974@notabene.brown>	<4CF81A16.2010606@cfl.rr.com>
	<20101203123615.6edce071@notabene.brown>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
In-Reply-To: <20101203123615.6edce071@notabene.brown>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/archive/html/grub-devel>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Sender: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, The development of GNU GRUB <grub-devel@gnu.org>, John Sheu <john.sheu@gmail.com>
List-Id: linux-raid.ids

On 12/02/2010 08:36 PM, Neil Brown wrote:
> If the array uses 0.90 or 1.0 metadata and comprises whole-disks (not
> partitions), and if the array is RAID1, then each device (except for the very
> end) contains exactly the same data as the whole array.
> If you install grub to the array, then it will be installed onto all of the
> (active) devices in the array.  And that is certainly the easiest way to
> write to all device.
>
> It won't write to 'spares', so if you want to be able to boot from spares as
> well .... but I'm not sure that makes sense anyway.

Yes, for a raid1 with no spares, installing to the array is equivalent 
to installing to each individual disk, but it helps avoid confusion to 
ignore this fact and remain thinking in terms of the physical disks, at 
least as they appear to the bios.

> Completely agree.  As I said, there are only some cases where you can boot
> from an array which uses whole-disks.
> One case if in the bios understands the array, such as Intel bios's with IMSM
> metadata, or possibly some bioses with DDF metadata.
> Another case is RAID1 which starts at the beginning of the device, where the
> bios doesn't need to know about the RAID.

So how do we tell the difference?  Right now grub uses the rule of 
dmraid = bios aware, so install to the raid device, and mdadm = software 
raid, so install to the component devices individually.  You have noted 
that in same cases both methods will produce the same results, but grub 
needs to be certain that whichever method it chooses will work, whether 
or not either one will.  To do this, it needs to install to the raid 
device if and only if it is a bios recognized fakeraid.
