From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Grub vs Lilo
Date: Wed, 26 Jul 2006 22:00:06 +0400
Message-ID: <44C7ADA6.7020200@tls.msk.ru>
References: <200607261943.24828.mylists@blue-matrix.org> <ea865p$7o0$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ea865p$7o0$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Lunz <lunz@falooley.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jason Lunz wrote:
> mylists@blue-matrix.org said:
>> Wondering if anyone can comment on an easy way to get grub to update
>> all components in a raid1 array.  I have a raid1 /boot with a raid10
>> /root and have previously used lilo with the raid-extra-boot option to
>> install to boot sectors of all component devices.  With grub it
>> appears that you can only update non default devices via the command
>> line.  I like the ability to be able to type lilo and have all updated
>> in one hit.  Is there a way to do this with grub?  
> 
> assuming your /boot is made of hda1 and hdc1:
> 
> grub-install /dev/hda1
> grub-install /dev/hdc1

Don't do that.
Because if your hda dies, and you will try to boot off hdc instead (which
will be hda in this case), grub will try to read hdc which is gone, and
will fail.

Most of the time (unless the bootloader is really smart and understands
mirroring in full - lilo and grub does not) you want to have THE SAME
boot code on both (or more, in case of 3 or 4 disks mirrors) your disks,
including bios disk codes.  after the above two commands, grub will write
code to boot from disk 0x80 to hda, and from disk 0x81 (or 0x82) to hdc.
So when your hdc becomes hda, it will not boot.

In order to solve this all, you have to write diskmap file and run grub-install
twice.  Both times, diskmap should list 0x80 for the device to which you're
installing grub.

I don't remember the syntax of the diskmap file (or even if it's really
called 'diskmap'), but assuming hda and hdc notation, I mean the following:

  echo /dev/hda 0x80 > /boot/grub/diskmap
  grub-install /dev/hda1

  echo /dev/hdc 0x80 > /boot/grub/diskmap # overwrite it!
  grub-install /dev/hdc1

The thing with all this "my RAID devices works, it is really simple!" thing is:
for too many people it indeed works, so they think it's good and correct way.
But it works up to the actual failure, which, in most setups, isn't tested.
But once something failed, umm...  Jason, try to remove your hda (pretend it
is failed) and boot off hdc to see what I mean ;)  (Well yes, rescue disk will
help in that case... hopefully.  But not RAID, which, when installed properly,
will really make disk failure transparent).

/mjt
