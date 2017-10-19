From: "Sean R. Funk" <sfunk1x@gmail.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Thu, 19 Oct 2017 14:11:40 +0000
Message-ID: <E62B1CBC-E39C-41A2-9795-623CF4FFE95F@gmail.com>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com> <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com> <59E7AE4B.5000903@youngman.org.uk> <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com> <59E88568.6060108@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59E88568.6060108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On October 19, 2017 3:58:48 AM PDT, Wols Lists <antlists@youngman=2Eorg=2E=
uk> wrote:

>
>Okay=2E First thing I'd try is temporarily get rid of mdadm=2Econf=2E You
>don't actually need it=2E Then do "mdadm --stop /dev/md0" followed by
>"mdadm --assemble --scan"=2E
>

Ok, so doing the stop, then assemble scan gets me :

/Dev/MD/0 assembled from 5 drives - not enough to start the array=2E
No arrays found in config file or automatically=2E

This was after moving the mdadm=2Econf temporarily=2E



>If that doesn't work, then try assembling the array explicitly, ie
>listing all the drives=2E I can't remember whether order is important -
>so
>long as you don't specify --force it'll either work or fail, it won't
>do
>any damage=2E

Looks like it's failed=2E  I ran:

mdadm --assemble /dev/md0 /dev/[abcde]1 /dev/sd[fgh]=20

Due to having to use a cell phone to respond I didn't type everything out =
here, but that's the idea=2E Running that, I got:

No superblock find on sdf expected magic a92b4efc, got 00000000
No raid superblock on sdf
Sdf has no superblock assembly aborted

This is where I've been stuck=2E I read a post a couple nights ago about z=
eroing the superblock on the drives that report no superblock, but it seems=
 they are already zeroed? My lack of experience here isn't helping=2E
