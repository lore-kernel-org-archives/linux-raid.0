From: "Joshua Johnson" <enigma2175@gmail.com>
Subject: Re: HELP! New disks being dropped from RAID 6 array on every reboot
Date: Sat, 24 Nov 2007 17:53:21 -0700
Message-ID: <e59c37290711241653n69664fd2kf39279fa9acdb086@mail.gmail.com>
References: <e59c37290711231019v3c20ea71od906bca6e5cab724@mail.gmail.com>
	 <47487976.7060201@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47487976.7060201@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Nov 24, 2007 12:20 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>
> Does that match what's in the init files used at boot? By any chance
> does the information there explicitly list partitions by name? If you
> change to "PARTITIONS" in /etc/mdadm.conf it won't bite you until you
> change the detected partitions so they no longer match what was correct
> at install time.

According to the man page, using 'partitions' as your DEVICE should
cause mdadm to read /proc/partitions and scan all partitions listed
there.  The sda*/sdb* partitions were in /proc/partitions (at least
after the machine fully booted) but for some reason when mdadm
assembled the array it was not adding those partitions.  Changing the
DEVICE to '/dev/hd* /dev/sd*' rather than 'partitions' resolved the
issue.
