From: Santiago DIEZ <santiago.diez@caoba.fr>
Subject: Re: How to fix mistake on raid: mdadm create instead of assemble?
Date: Fri, 21 Oct 2016 10:45:10 +0200
Message-ID: <CAJh8RqU7kcTrp_1Rgorx02OR5H5bm-a8=DSvQz-Bkrg7S3357w@mail.gmail.com>
References: <CAJh8RqUaT_D3GEkj9dWGY5d4e4icUKzyidV2JTVToKN=MpCRyQ@mail.gmail.com>
 <20161008123040.GA4603@metamorpher.de> <57FAC73A.6020603@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57FAC73A.6020603@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Thanks Andreas,

Yes apparently, 3/4 of the original disks seem to be safe. But I'm
terrified at the idea of doing something wrong assembling them.
Incidentally, I indeed did a mistake trying to assemble the ddrescue
images of the 3 safe disks. I tried to create again with proper
metadata and chunck but it did not work. I'm still scared at the idea
of restarting the original raid. I'm currently ddrescuing again the 3
partitions to then try and *assemble* them rather than *create*.


Thanks Wol,

I use loop devices because I work on partition images, not on actual partitions:
I use ddrescue to copy data from /dev/sd[abc]10 to
some.other.server:/home/sd[abc].img
Then I go to some.other.server and turn the images into loop devices :
losetup /dev/loop0 /home/sda10.img
losetup /dev/loop1 /home/sdb10.img
losetup /dev/loop2 /home/sdc10.img
Then I tried to created the raid, it worked but as I said, the
filesystem was unreadable.
I know the idea of using loop devices works because I tested it before.
I'm doing the whole procedure all over again (takes 5 days to ddrescue
the 3 partitions to another server) and then I will use the command
you recommended :
mdadm --assemble /dev/md0 /dev/loop0 /dev/loop1 /dev/loop2 --force


Will keep you posted

-------------------------
Santiago DIEZ
Quark Systems & CAOBA
23 rue du Buisson Saint-Louis, 75010 Paris
-------------------------

On Mon, Oct 10, 2016 at 12:39 AM, Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 08/10/16 13:30, Andreas Klauer wrote:
> > On Fri, Oct 07, 2016 at 05:37:32PM +0200, Santiago DIEZ wrote:
> >> > First thing I did is ddrescue the remaining partitions sd[abc]10 .
> >> > ddrescue did not stumble into any read error so I assume all remaining
> >> > partitions are perfectly safe.
> > So ... don't you still have a good copy?
> >
> > You only killed one of them, right? Did not make same mistake twice?
> >
> >> > There comes my mistake: I ran the --create command instead of --assemble :
> >> >
> >> > ================================================================================
> >> > # mdadm --create --verbose /dev/md1 --raid-devices=4 --level=raid5
> >> > --run --readonly /dev/loop0 /dev/loop1 /dev/loop2 missing
>
> One oddity I've noticed. You've created the array using loop devices.
> What are these?
>
> The reason I ask is that using loopback devices is a standard technique
> for rebuilding a damaged array, specifically to prevent md from actually
> writing to the drive. So is it possible that "mdadm --create" only wrote
> to ram, and a reboot will recover your ddrescue copies untouched?
>
> My raid-fu isn't enough to tell me whether I'm right or not ... :-)
>
> If necessary you'll have to do another ddrescue from the original
> drives, and you should then be able to assemble the array from the
> copies. Don't use "missing", use "--force" and you should get a working,
> degraded, array to which you can add a new drive and rebuild the array.
>
> mdadm --assemble /dev/md0 /dev/sd[efg]10 --force
>
> if I'm right ... so long as it's the copies, you can always recover
> again from the original disks, and if there's a problem with the copies
> mdadm should complain when it assembles the array.
>
> Cheers,
> Wol
