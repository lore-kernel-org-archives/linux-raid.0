From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: data corruption after rebuid
Date: Thu, 14 May 2015 16:00:20 +1000
Message-ID: <555439F4.4020200@websitemanagers.com.au>
References: <CAC6SzHKo8kUOJoC+eaZU1mQCzW+WdB6ACRkrM30yUCA7CodLCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC6SzHKo8kUOJoC+eaZU1mQCzW+WdB6ACRkrM30yUCA7CodLCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d tbsky <tbskyd@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/05/15 14:54, d tbsky wrote:
> Hi:
>      I think I did something wrong and cause mdadm data corruption.
> but I am curious which steps brings me down. hope someone can told me
> about it.
>
>        I have two hosts forms a vm HA cluster. each one is a 2TB * 2
> mdadm raid 1. I need to test something but lack of disks, so I pull
> one disk of each hosts.  after testing, I put the disk back and let
> mdadm rebuild. host B took several hours to rebuild and looks fine.
> host A took only 5 min to rebuild. after completing rebuild, the
> virtual machines stand  above the raid crashed one by one. since I
> know I have write many data  bytes during the testing, host A should
> not took only 5 min to recover. I must do something wrong to confuse
> mdadm.  below is what I done:
>
> 1. I test a 3 disk mdadm raid 5: sda (hostA sdb), sdb (hostB sdb), sdc
> (new disk). I wrote about 5G data for system restore testing.
>
> 2. then I test a 4 disk mdadm raid10: sda (hostA sdb), sdb(hostB
> sdb),sdc(new disk),sdd (new disk). I wrote about 5G data for system
> restore testing.
>
> 3. then I test again a  4 disk mdadm rai10, but wrote about 120G data
> for system restore testing.
>
> then I put back the disk to hostA and hostB (hot plugin, HOST A and B
> are still running). at hostA I issue command blow:
>    mdadm --stop /dev/md126; mdadm --stop /dev/md127 (the plugged disk
> has raid data on it and udev seems found it)
>    dd if=/dev/sda of=/dev/sdb bs=1k count=1000  (to recreate mbr
> partition table).

My guess is this is where you went wrong.
Instead use a tool that will do this intelligently, quick google shows this:
sgdisk -R=/dev/sdb /dev/sda
sgdisk -G /dev/sdb
Taken from:
http://unix.stackexchange.com/questions/12986/how-to-copy-the-partition-layout-of-a-whole-disk-using-standard-tools

My guess is you copied some data as well as the partition table, and
that you are using a mdadm label which is stored at the beginning of the
disk, and possibly are using bitmap on one server and not the other.

Maybe if you could show some details from each of the raid arrays then
more people can make more informed comments.

My suggestion is to create *just* the partitions, and then add them to
the array.

Hope that helps.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

