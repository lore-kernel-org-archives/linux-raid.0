From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Raid over USB disks and eject
Date: Mon, 12 Nov 2012 13:10:25 -0300
Message-ID: <CAGmni9qLtjyFCjQX+-tp2+fyUKAUpJcD0SGFMhTC3FEtAgtxTw@mail.gmail.com>
References: <CAGmni9rBn9V0kEqirNnLR1iGdaXc48+afuL1NbTg8R5Cr1q9hw@mail.gmail.com>
 <50A11B2C.7070902@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A11B2C.7070902@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Benjamin, thanks for the tip. I will try this later and post the
results here.

[]'s
Salatiel


On Mon, Nov 12, 2012 at 12:52 PM, Benjamin ESTRABAUD <be@mpstor.com> wrote:
> Hi!
>
> You could setup a cron job that will pause the resync by writing to sysfs:
>
> If your array if "md0":
>
> echo "idle" > /sys/block/md0/md/sync_action
>
> However, this is probably not necessary as the resynced stripes will be
> marked in the bitmap, meaning that if your rebuild fails, re-assembling the
> array should restart the resync from where it stopped.
>
> Regards,
> Ben.
>
>
> On 12/11/12 12:44, Salatiel Filho wrote:
>
> Hi guys,  i have an external USB enclosure with 4 disks  in RAID5 mode
> using mdadm. I dont know exactly why but if i use this disks for
> massive I/O for lots of hours (over 12 hours), linux usually eject
> some or all disks (causing a faulty in the raid) and remaps them: sdb
> -> sdf , sdc -> sdg , sdd -> sdh , sde -> sdi
> Well , this was never exactly a problem because most of the time those
> disks are idle (just backup), but i had a real disk failure and i will
> replace the disk. But probably the rebuild process will take a lot
> more than 12 hours so the chances are that some disk will be ejected
> and i will be in a trouble situation where a raid5 rebuilding process
> will probably be stopped by an apparently failure. So my question is:
>
> If i get into that situation , will i be able to disassemble and
> reassemble the disk using the three disks i know are 'fine' and
> restart the rebuild process from where it stopped ? I have internal
> bitmap enabled.
>
> Is it possible to somehow freeze the rebuild process ? So i could
> pause the process for a few hours after 8 hours of work for example.
>
> The raid will be assembled but umounted during the rebuild proccess.
>
> I am using kernel 3.2.30.
>
> Thanks !!!
>
>
> []'s
> Salatiel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
