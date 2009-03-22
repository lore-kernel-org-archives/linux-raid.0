From: Erik Boettcher <tehfoo@gmail.com>
Subject: Re: Raid 5 Recovery
Date: Sun, 22 Mar 2009 05:05:47 -0400
Message-ID: <125ed8800903220205l6c3efa1boecad13161de1754b@mail.gmail.com>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
	 <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
	 <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
	 <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
	 <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com>
	 <20081228183921.GA5815@csy.ca>
	 <alpine.DEB.1.10.0812281714080.23996@p34.internal.lan>
	 <125ed8800903212015g4987fca9lbb8f42cfb2333a0d@mail.gmail.com>
	 <FCCA5C2A-C9B5-40CF-8DB7-5DDAC1663384@lambdalifting.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FCCA5C2A-C9B5-40CF-8DB7-5DDAC1663384@lambdalifting.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Amanshauser <linux-raid@lambdalifting.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 22, 2009 at 3:15 AM, Max Amanshauser
<linux-raid@lambdalifting.org> wrote:
>
> On Mar 22, 2009, at 4:15 AM, Erik Boettcher wrote:
>
>> Indeed recreating seems like my only option now. =A0I'd like to ensu=
re
>> the right creation order, so I'd like to ask for some help. =A0Attac=
hed
>> is the output of 'mdadm -Evvvv /dev/sd{a,b,c,d,e}3' =A0Any help
>> restoring this array is greatly appreciated!
>> <mdadmEout>
>
>
>
> I had the same problem recently and solved it relatively pain-free.
>
>
> Basically what I did was:
>
> *) Find out where the old superblocks are located and backup them wit=
h dd,
> just in case. Ideally you should backup all of the disks entirely (if=
 they
> have errors, use dd_rescue and do the following on healthy disks).
Hmm, I can't back up the disks but I'm trying to get the superblocks.
I can't find where they're located to copy them!

>
> *) Recreate with mdadm and the same options that were used when creat=
ing the
> raid in the first place, with one device declared missing.
> "mdadm --create /dev/md0 -e 0.90 -c 32 -p left-asymmetric -l 5 -n 5
> /dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdb3 missing" sounds about right i=
n your
> case. I'd find out what the difference between 0.88 and 0.90 superblo=
cks is,
> though. If you have devices with errors you should declare the most b=
roken
> one missing, of course. And make absolutely sure that the options are
> correct or you will overwrite innocent data. The device order is not =
so
> important, since you can change it in subsequent recreate attempts wi=
thout
> breaking anything.
Is the order that mdadm --query provides more correct? I guess I'll fin=
d out....

>
> *) Try to read-only mount the array, and/or use dumpe2fs (if you have
> ext2/3). If it works, hurray. If not, recreate again with a different=
 device
> order. Ultimately you will probably have to e2fsck to correct the dam=
age.
LLVM is being used here, so I'll have to make sure vgscan etc don't wri=
te...

>
>
> I got the correct device order on the second attempt and lost only 15=
0kB due
> to hard disk errors. Guess I was lucky.
>
> --
> Good luck,
Thanks, I need it.
> Max.

Erik
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
