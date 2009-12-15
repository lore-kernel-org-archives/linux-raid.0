From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: RAID-5 Degraded, Seemed to have lost files? Please help!
Date: Tue, 15 Dec 2009 09:32:57 -0500
Message-ID: <7d86ddb90912150632m3dce373au2803b49c4ee0fcdd@mail.gmail.com>
References: <26792453.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26792453.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: stuart-b-uk <stuart.buckell@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 15, 2009 at 5:26 AM, stuart-b-uk
<stuart.buckell@googlemail.com> wrote:
>
> Hello,
>
> We have a RAID-5 =A04x 250GB SATA running on an Intel SATA Hardware R=
aid
> controller.
>
> Yesterday a drive failed, which was replaced, however we did not have
> another matching drive, therefore it didn't like what it saw and woul=
dn't
> rebuild.
>
> Someone accessed files over HTTP and for some reason the filesystem w=
ent
> into readonly mode.
>
> The system is now degradding to 3 drives Raid-5, and is at 20% after =
12
> hours.
>
> The problem we have is a critical folder exists but has nothing insid=
e it,
> except a few question marks when the directory is listed via bash.
>
> My question is:-
>
> 1) Is it likely after the raid has gone from 750GB to 495GB that we w=
ill
> ever see these files again?
> 2) Can you recommend any recovery software which might be able to get=
 these
> files back?
> 3) Has anyone experienced random loss of files from a rebuild of RAID=
-5
> before?
>
> I appreciate the importance of backing up, unfortunately, this is the=
 only
> folder in the system that wasn't set up in the backup routine properl=
y, and
> yes, Murphy struck again...
>
> Thanks to anyone who can help,
>
> Regards,
>
> Stuart
> --
> View this message in context: http://old.nabble.com/RAID-5-Degraded%2=
C-Seemed-to-have-lost-files--Please-help%21-tp26792453p26792453.html
> Sent from the linux-raid mailing list archive at Nabble.com.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

1. A 4 x 250GB drive array is 750GB to begin with as one drive is used
for parity. Thus when it degrades it is still 750GB in size. When only
one drive is lost the performance of the array goes down, but all data
should be accessible.

3. If using the onboard Intel Matrix fake RAID controller then yes I
have heard of them loosing arrays and not rebuilding correctly. For
critical data either a hardware RAID controller with battery backed
cache or software RAID (mdadm).

Supposedly new versions of mdadm support the Intel Matrix metadata.
You might be able to reassemble the array using mdadm to recovery the
data.

I would probably start by shutting down the system and making a dd
copy of each drive in another system so you have a copy of the data.

Of course if the data is highly important you might just send the
drives off to be recovered.

Ryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
