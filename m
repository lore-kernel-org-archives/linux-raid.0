From: Jim <jim@fayettedigital.com>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Mon, 07 Jan 2008 09:26:12 -0500
Message-ID: <47823684.80501@fayettedigital.com>
References: <477FAAAC.2090107@fayettedigital.com> <18305.22361.482483.331552@notabene.brown>
Reply-To: jim@fayettedigital.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18305.22361.482483.331552@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday January 5, jim@fayettedigital.com wrote:
>   
>> root@chinaberry:~# mdadm /dev/md0 --add /dev/hdb5
>> mdadm: Cannot open /dev/hdb5: Device or resource busy
>>
>> All the solutions I've been able to google fail with the busy.  There is 
>> nothing that I can find that might be  using /dev/hdb5 except the raid 
>> device and it appears it's not either.
>>     
>
> Very odd. But something must be using it.
>
> What does
>    ls -l /sys/block/hdb/hdb5/holders
> show?
> What about
>    cat /proc/mounts
>    cat /proc/swaps
>    lsof /dev/hdb5
>   
> ??
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
I agree but for the life of me I can't figure out what, other than some 
raid daemon.

root@chinaberry:~# ls -l /sys/block/hdb/hdb5/holders
total 0
root@chinaberry:~# cat /proc/mounts
none /sys sysfs rw,nosuid,nodev,noexec 0 0
none /proc proc rw,nosuid,nodev,noexec 0 0
udev /dev tmpfs rw 0 0
/dev/disk/by-uuid/4f67dae8-cdcb-460e-86cd-a5f0e4009422 / ext3 
rw,data=ordered 0 0
/dev/disk/by-uuid/4f67dae8-cdcb-460e-86cd-a5f0e4009422 /dev/.static/dev 
ext3 rw,data=ordered 0 0
tmpfs /var/run tmpfs rw,nosuid,nodev,noexec 0 0
tmpfs /var/lock tmpfs rw,nosuid,nodev,noexec 0 0
tmpfs /dev/shm tmpfs rw 0 0
devpts /dev/pts devpts rw 0 0
usbfs /dev/bus/usb/.usbfs usbfs rw 0 0
udev /proc/bus/usb tmpfs rw 0 0
usbfs /proc/bus/usb/.usbfs usbfs rw 0 0
tmpfs /var/run tmpfs rw,nosuid,nodev,noexec 0 0
tmpfs /var/lock tmpfs rw,nosuid,nodev,noexec 0 0
/dev/sda5 /home ext3 rw,data=ordered 0 0
/dev/md0 /backupmirror ext3 rw,data=ordered 0 0
/dev/hda1 /vz ext3 rw,data=ordered 0 0
/vz/private/225 /vz/root/225 simfs rw 0 0
/vz/private/300 /vz/root/300 simfs rw 0 0
/proc /vz/root/225/proc proc rw 0 0
/sys /vz/root/225/sys sysfs rw 0 0
none /vz/root/225/dev/pts devpts rw 0 0
/proc /vz/root/300/proc proc rw 0 0
/sys /vz/root/300/sys sysfs rw 0 0
none /vz/root/300/dev/pts devpts rw 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
root@chinaberry:~# cat /proc/mounts | grep hdb
root@chinaberry:~# cat /proc/swaps
root@chinaberry:~# lsof /dev/hdb5

