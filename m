From: Theodotos Andreou <theo@ubuntucy.org>
Subject: Re: Restoring a RAID 10 disk array
Date: Mon, 23 Jun 2014 17:52:29 +0300
Message-ID: <53A83F2D.9060101@ubuntucy.org>
References: <53A833DF.8050004@ubuntucy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A833DF.8050004@ubuntucy.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/06/2014 05:04 =CE=BC=CE=BC, Theodotos Andreou wrote:
> Hi to all,
>
> I have a RAID 1 RAID 10 setup that failed. I booted with a recovery=20
> usb (grml) to try to recover the system. Let me explain the setup to =
you.
>
> This is my parted listing:
>
> http://pastebin.com/6QdyXRQN
>
> The first partitions (/dev/sd[ad]1) are for EFI. No RAID here
>
> The second partitions (/dev/sd[ad]2) are the /boot filesystem. This=20
> used to be /dev/md0 and it is a RAID 1 setup.
>
> The third partitions (/dev/sd[ad]3) is the LVM physical volume which=20
> hosts all the rest. It used to be /dev/md1 and it is a RAID 10 setup.
>
> For the parted listing it looks like there is some partition table=20
> corruption on /dev/sdd.
>
> When I try 'mdadm --verbose --assembly --scan' I get:
>
> http://pastebin.com/iqGF9En7
>
> The output of 'mdadm -Evvvvs' is:
>
> http://pastebin.com/kizjT7xE
>
> Assuming I replace the sdd disk and create the appropriate partition=20
> scheme, what is the correct methodology to restore my md devices? I=20
> don't care much about /dev/md0 but mostly for the /dev/md1 partition=20
> where there are all the data.
>
> Regards
>
> Theo
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
It turns out the sdd disk was unplugged and I mistakenly took the USB=20
drive as the internal disk. This explains why the UUIDs did not match=20
the device name.

After I plugged the sdd disk back all went back to normal.

So next time... Don't panic! :)

Sorry for the false alarm guys
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
