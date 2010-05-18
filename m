From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: failed devices become spares!
Date: Tue, 18 May 2010 11:30:16 +1000
Message-ID: <20100518113016.1981a08c@notabene.brown>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
	<201005172010.36157.pierre@vigneras.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201005172010.36157.pierre@vigneras.name>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre =?UTF-8?B?VmlnbsOpcmFz?= <pierre@vigneras.name>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 17 May 2010 20:10:36 +0200
Pierre Vign=C3=A9ras <pierre@vigneras.name> wrote:

> Did I miss something, or is there something really strange happening =
there?

Something strange...
I cannot explain the 'SpareActive' messages.
Most of the rest makes sense.

You had a RAID10 - 4 drives in near=3D2 mode.  So the first two disks c=
ontain
identical data, and the second two are also identical and contain the r=
est.
The second device failed due to a write error.
Why it seemed to become a spare I'm not sure.  I'm not all sure it did
become a spare immediately- your logs aren't conclusive on that point.
It did eventually become a spare, but that could be because you "remove=
d and
added the devices" which would have changed them from 'fail' to 'spares=
'.

Then the first device in the array reported an error and so was failed.
After this you would not be able to read or write to the even chunks of=
 the
array, xfs noticed and complained.

By this time sdf1 seemed to be a spare so it gave recovery a try.  The
recovery process discovered there was nowhere to read good data from an=
d
immediately gave up.

However if the devices really are OK, then sdf1 and sdc1 should contain
identical data (except the superblock would be slightly different.
You could check this with "cmp -l", though that might not be very effic=
ient.
Also sdd1 and sde1 should be identical.

I suggest that you try:

 mdadm -S /dev/md2
 mdadm -C /dev/md2 -l 10 -n 4 -c 64 -e 0.90 /dev/sdc1 missing /dev/sdd1=
 missing  --assume-clean

and then see what the data on md2 looks like.
You could equally try sdf1 in place of sdc1, or sde1 in place of sdd1
(make sure you double check the device names, don't assume I got then r=
ight).

Once you have a combination that look good, you can add the other two d=
evices
an they will recover and you should have your data back.

BUT be warned.  Something cause some errors to be reported.  Unless you=
 find
out what that was and fix it, errors will occur again.  I have no idea =
what
might have caused those errors.  Bad media? bad controller ? bad usb
controller? bad luck?

I wouldn't write new data, or even perform a recovery until you are qui=
te
confident of the devices.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
