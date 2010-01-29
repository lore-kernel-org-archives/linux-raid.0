From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 1 usage in a lab
Date: Fri, 29 Jan 2010 21:10:25 +1100
Message-ID: <20100129211025.41ea737a@notabene>
References: <CA5A491E9DEFBE4CB777DE97E21575E90BFAF8@prato.activenetwerx.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA5A491E9DEFBE4CB777DE97E21575E90BFAF8@prato.activenetwerx.local>
Sender: linux-raid-owner@vger.kernel.org
To: "Joseph L. Casale" <jcasale@activenetwerx.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 28 Jan 2010 04:09:11 +0000
"Joseph L. Casale" <jcasale@activenetwerx.com> wrote:

> I have a box with a two discs mirrored. Suppose I want to remove the primary
> and boot off the secondary alone to test, then roll back to the primary after
> the test.
> 
> I have been doing this by:
> 
> 1. Removing sda, booting off the sdb and running:
>      # mdadm --grow /dev/md[0|1] --raid-devices=1 --force
>      Then test away, shutdown...
> 
> 2. Remove sdb, install sda only and run:
>      # mdadm --grow /dev/md[0|1] --raid-devices=1 --force
>      shutdown...
> 
> 3. Install sdb and reboot, the run:
>     # mdadm --manage /dev/md0 --add /dev/sdb1
>     # mdadm --grow /dev/md0 --raid-devices=2
>  
>     # mdadm --manage /dev/md1 --add /dev/sdb2
>     # mdadm --grow /dev/md1 --raid-devices=2
> 
> 
> Is there a simpler way with less reboots? What criteria does md use to
> determine which disc is most recent, even a solo reboot with sda, after
> which attaching sdb causes the system to prefer sdb, even though the solo
> boot off sda should have made timestamps prove sda most current.

It uses the event count to choose the most recent, not the timestamp.
sda has seen the most events so it is the most recent.

Is your root filesystem on the mirrored pair?
If not, then you don't need any reboots at all.
If it is you should be able to get away with just 1.

1/  mdadm /dev/md[0|1] --fail /dev/sda[1|2]

 now you are running on sdb, sda is untouched.

2a/ if root is not on mirrored pair:
   mdadm -S /dev/md1
   mdadm --zero /dev/sdb2
   mdadm -A /dev/md1 /dev/sda1

2b/ if root is on mirrored pair:
   sync ; sync ; mdadm --zero /dev/sdb1 ; reboot -f -n

   should boot up and assemble /dev/md0 from /dev/sda1

3/ mdadm /dev/md0 --add /dev/sdb1
   mdadm /dev/md1 --add /dev/sdb2


NeilBrown
