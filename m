From: "Ian Brown" <ianbrn@gmail.com>
Subject: Re: Stopping and starting a RAID1 :Invalid argument
Date: Mon, 9 Oct 2006 09:40:20 +0200
Message-ID: <d0383f90610090040v2d0ab905ka5d4607037dd6e17@mail.gmail.com>
References: <d0383f90610080305x4d06d307yfc497f39761f073c@mail.gmail.com>
	 <Pine.LNX.4.56.0610081115440.20412@lion.drogon.net>
	 <d0383f90610080608x77fbfb80qb1e89fa8840f9d0a@mail.gmail.com>
	 <20061008132537.M34804@contactbda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061008132537.M34804@contactbda.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: jim@contactbda.com
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Well, assemble looks like it does the job

mdadm --stop /dev/md0

mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdb2

mdadm: /dev/md0 has been started with 2 drives.

#cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[0] sdb2[1]
      16000 blocks [2/2] [UU]

unused devices: <none>


In the kernel log I see:
"md0: raid array is not clean -- starting background reconstruction"


What is the meaning of "raid array is not clean" ?

Should it appear in a normal stop and assemble action on a raid 1 ?

I hope that this message does not indicate that something
was not done as it should be.


Regards,
IB



On 10/8/06, Jim Buttafuoco <jim@contactbda.com> wrote:
> try to assemble the array instead, --run is trying to start a partially built array, --stop deactivated the array and
> released all resources, so --run will NOT work, use --assemble (-A) instead.
>
> Good luck
> Jim
>
>
> ---------- Original Message -----------
> From: "Ian Brown" <ianbrn@gmail.com>
> To: "Gordon Henderson" <gordon@drogon.net>
> Cc: linux-raid@vger.kernel.org
> Sent: Sun, 8 Oct 2006 15:08:56 +0200
> Subject: Re: Stopping and starting a RAID1 :Invalid argument
>
> > Hello,
> >
> > >There is a case under RAID-1 where you can mount the >underlying devices,
> > >but that's only in an emergency,
> >
> > Ok , thnks, this point is clear now.
> >
> > So I made another test. This time without mkfs.
> >
> > Now , I deleted the partitions and created them anew and did
> > evertyhing else the same ,only
> >  this time without mkfs.
> >
> > Still:
> >
> > stop succeeds :
> >
> > mdadm --stop /dev/md0
> >
> > cat /proc/mdstat
> >
> >  Personalities : [raid1]
> > unused devices: <none>
> >
> > but mdadm --run : give an error:
> >
> > mdadm --run /dev/md0
> >
> > mdadm: failed to run array /dev/md0: Invalid argument
> >
> > Any idea why is it so ? can't I start an array after it was stopped ?
> >
> > Regards,
> > Ian
> >
> > On 10/8/06, Gordon Henderson <gordon@drogon.net> wrote:
> > > On Sun, 8 Oct 2006, Ian Brown wrote:
> > >
> > >
> > > > Then I created a RAID1 by running:
> > > >
> > > > mdadm --create /dev/md0 --level=raid1 --raid-devices=2 /dev/sdb1 /dev/sdb2
> > > >
> > > > I got : mdadm: array /dev/md0 started
> > > >
> > > > cat /proc/mdstat shows:
> > > >
> > > > Personalities : [raid1]
> > > > md0 : active raid1 sdb2[1] sdb1[0]
> > > >       16000 blocks [2/2] [UU]
> > > >       [==>..................]  resync = 12.5% (2112/16000)
> > > > finish=0.7min speed=301K/sec
> > > > unused devices: <none>
> > >
> > > So far so good. Nothing out of the ordinary here for your testing
> > > environment.
> > >
> > > > I created ext3 fs on /dev/md0 and /dev/sdb1 and /dev/sdb2.
> > >
> > > Eeek!
> > >
> > > You have created a filesystem on md0, which uses /dev/sdb1 and /dev/sdb2,
> > > THEN you fiddled with the underlying devices, /dev/sdb1 and /dev/sdb2...
> > >
> > > What you have done is effectively corrup the filesystem on /dev/md0, and
> > > possibly even wiped out the superblock on the /dev/md0 device. (which may
> > > be why you can't start it again)
> > >
> > > Once you have created a RAID array, you only ever deal with the mdX
> > > device. Leave the underlying devices well alone. They are now owned by the
> > > md device driver.
> > >
> > > Start again, and don't fiddle with the underlying /dev/sdbX devices. Do
> > > not mkfs them, and do not mount them.
> > >
> > > All you need to do is this:
> > >
> > >   mdadm --create /dev/md0 -l1 -n2 /dev/sdb{1,2}
> > >   mkfs -t ext3 /dev/md0
> > >   mount /dev/md0 /mnt
> > >
> > > and there you have it.
> > >
> > > Use
> > >         df -h /mnt
> > > to let you see the size of your new mounted volume - it'll be 30MB or so.
> > >
> > >
> > > There is a case under RAID-1 where you can mount the underlying devices,
> > > but thats only in an emergency, with the mdX drivers stopped, and you need
> > > to make absulutely sure you know what you are doing if you do this, and if
> > > you mount then read-write, the you must not re-enable and mount the
> > > overlying mdX device as it won't know which of the 2 mirrors is the
> > > current one and you might get old data. ie. it's a one-way process in an
> > > emergency, mount the underlying device, get the data off and re-create
> > > from scratch, and you can only do this with RAID-1 devices.
> > >
> > > Gordon
> > >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ------- End of Original Message -------
>
>
