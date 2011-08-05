From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Fri, 5 Aug 2011 13:28:41 +0200
Message-ID: <CADz4AWGrsP8tJ7U_YPa8Bs7rxUcW40-wTEtRmSykaBpQ0=V9ug@mail.gmail.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
 <20110802163907.29fc40b4@notabene.brown> <CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
 <20110803150108.58f5c70b@notabene.brown> <CADz4AWFekPKreuiwzYBvTnbXZnDGRH7nQ1WKEaeOdn7_6M5eQg@mail.gmail.com>
 <20110803192054.6097d2c0@notabene.brown> <CADz4AWE20OdL4VecVOrOH5X-UqdB4BA00AW33YbYEtD1z30acA@mail.gmail.com>
 <4E3BC6B9.8050803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3BC6B9.8050803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Wish I could have helped you recover the array. =A0When a patient come=
s
through emergency with 3 GSWs to the forehead and no pulse, there's
nothing that can be done. =A0:("

Quite an analogy :P . Is it really that hopeless ? And of interest
have you been in that situation ? I have the order of the array... so
it should just be a case of reconstructing it in the same way it was
created. Only one device was partitioned (as can be seen from the
dmesg logs) and that device is known.

Most of the array was backed up to another array, but there are some
photos I'd like to recover. The array doesn't need to be functional
any time soon (I'm happy to keep working on it for another 3 months if
necessary).

Besides, it's a good learning experience.

I "re-created" the array using the drive order I specified in the
previous e-mail, but replacing drive 9 with "missing". I then ran
xfs_check on the md device and it failed (as it did with every other
re-create attempt). I'll give your suggestion of xfs_repair -n a go :)
=2E

I'll have a look at the start of the md device with a hex editor and
see if there's anything interesting there.

On Fri, Aug 5, 2011 at 12:32 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 8/5/2011 5:04 AM, Aaron Scheiner wrote:
>> I followed your advice and ran a scalpel instance for every drive in
>> the array. The scanning process finished this morning yay (and
>> obviously went a lot faster).
>
> Glad I could help.
>
> ...
>> So now the next step would have been to re-create the array and chec=
k
>
> Unless Neil has some hex editor (or other similar) trick up his sleev=
e
> that would allow you to manually recreate the sectors you hosed
> installing grub..
>
>> if a file system check finds something... but because of the offsets
>> that probably won't work ?
>
> If you are able to use the Force to assemble the disks in the correct
> order, getting the raid device back up and running, then run 'xfs_rep=
air
> -n /dev/md0' to do the check. =A0The '-n' means "no modify". =A0xfs_r=
epair
> is better than xfs_check in many aspects. =A0They are two separate co=
de
> paths that serve the same function, but they behave a little differen=
tly
> under the hood.
>
>> Thanks again :)
>
> Wish I could have helped you recover the array. =A0When a patient com=
es
> through emergency with 3 GSWs to the forehead and no pulse, there's
> nothing that can be done. =A0:(
>
> --
> Stan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
