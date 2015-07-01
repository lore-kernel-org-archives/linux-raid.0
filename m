From: NeilBrown <neilb@suse.com>
Subject: Re: Raid Recovery
Date: Wed, 1 Jul 2015 11:01:46 +1000
Message-ID: <20150701110146.55a8aad1@noble>
References: <CADaa48=k9OE_MOmFgkdKZhkrUOfrRnJjEWeEVFfx6T7kQkRQ9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADaa48=k9OE_MOmFgkdKZhkrUOfrRnJjEWeEVFfx6T7kQkRQ9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Carter J. Castor" <cjcastor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Jun 2015 17:05:17 -0400 "Carter J. Castor"
<cjcastor@gmail.com> wrote:

> I have an ubuntu RAID 10 server using mdadm. It has six drives and a
> hot spare. The eSATA cables to the box holding the harddrives got
> disconnected from the server. When I plugged them back, it immediately
> saw only three of the drives and my hotspare and started rebuilding
> the array. Not wanting to screw it up, I let it finish, and then I
> rebooted. On start up, the array was inactive. When I tried to
> assemble it, it told me that there was only one disk(!?) so I tried to
> assemble it with the --force command. It then assembled, but the
> logical volume that I use to mount the RAID partition was gone. I have
> backups, but I'd like to save the data if at all possible. What's my
> best course of action from here?
> 
> Here's the /proc/mdstat after rebooting:
> md127 : active (auto-read-only) raid10 sdg1[5] sdd1[1] sdh1[6] sde1[7]
> sdf1[4] sdc1[2]
>       2929890816 blocks super 1.2 256K chunks 2 far-copies [6/6] [UUUUUU]
> 
> 
> Blkid output:
> 
> /dev/sda1: LABEL="KINGSTON" UUID="C3D4-FB34" TYPE="vfat"
> /dev/sdb1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="f858b034-29ab-4d59-02d3-775b9b2139cd" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sdc1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="90675a7f-bf95-1514-4e54-e38ef61d5943" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sdd1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="eaa50f1c-e1cd-d1a2-b10b-da77f2c0d5d7" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sde1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="0b8210f9-cd73-a70d-bba7-01231bf9c578" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sdf1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="fe58a109-7ec1-37d6-ee10-76197ffb4c67" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sdg1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="726e7104-835c-adcc-32c4-952699b3b030" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sdh1: UUID="dedc8d6c-8155-f88d-b035-c8cf66d4e561"
> UUID_SUB="91095954-1368-ba5e-592a-b3d245904cb8" LABEL="Pangolin:0"
> TYPE="linux_raid_member"
> /dev/sdi1: UUID="d24a5068-14fb-4cec-831a-4b6d3bdba44d" TYPE="ext4"
> /dev/sdi5: UUID="ab5617d1-58e1-4013-9690-64679982b2cf" TYPE="swap"
> /dev/md127: UUID="S2atdF-aFUn-hmKm-yzsr-iqYW-DX3W-ioWjnl" TYPE="LVM2_member"
> 

"mdadm --examine" output of each drive is usually a good idea.
Also kernel logs from the time of the failure can help.

However blkid is reporting that "md127" is an "LVM2_member", which is
encouraging.  Why do you think that the logical volume is gone?
What does
  pvdisplay /dev/md127
report?
What about
  pvck /dev/md127
??


NeilBrown

