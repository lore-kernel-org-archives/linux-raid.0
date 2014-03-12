From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Wed, 12 Mar 2014 11:38:02 -0400
Message-ID: <CAK_KU4Zmi4jUO9tfMVk-c-GXBqDUZOWd1LoBx_+isT96O6Kz9Q@mail.gmail.com>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
	<53202503.10901@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53202503.10901@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Step 1 in all this is, of course, to take a backup.  And step 2 is to
> check that your backup is good.

Everything important was backed up recently.  :-)

>
> It is also a good idea to practice on fake arrays made from loopback
> "disks" - they work fine for md raid, and let you practice re-shaping=
,
> re-sizing, etc., without any risk to your real disks.

I also recommend this for things I am not sure about,
and I imagine it is critical for development testing.
In fact, when I like to give a demo to folks:
--I'll first create a RAID array with loop devices.
--Ill then copy over a movie and start watching the movie.
--I'll then fail a disk and delete the file
--Then I'll create a new file, add it to the array
and watch it recover, all the while the movie doesn't skip a beat. :-)

>
>
> If you want to safely replace the disks in a raid5 array, the easiest
> way is to add a new disk (this can be an external USB disk if necessa=
ry)
> and re-shape to an asymmetric raid6 with parity Q on the new disk.  N=
ow
> you have an extra redundancy for safety.  (Use asymmetric raid6 to av=
oid
> re-striping the existing disks.)
>
I would disagree with your assertion that it is the 'easiest' way.
I tried to do this on my system, but you didn't specify which parity
method to use.
RTFMing I found...
              These  same  layouts  are available for RAID6.  There are=
 also 4
              layouts that will provide an intermediate stage  for  con=
verting
              between  RAID5 and RAID6.  These provide a layout which i=
s iden=E2=80=90
              tical to  the  corresponding  RAID5  layout  on  the  fir=
st  N-1
              devices,  and  has  the  'Q' syndrome (the second 'parity=
' block
              used by RAID6) on the last device.  These layouts are: le=
ft-sym=E2=80=90
              metric-6,  right-symmetric-6,  left-asymmetric-6, right-a=
symmet=E2=80=90
              ric-6, and parity-first-6.
Regardless, attempting to use any of these layouts were countered with
 "that parity mode isn't available for that level raid." or something s=
imilar.

It was much 'easier' to compile the latest mdadm and use --replace
(Thanks Mikael):
  apt-get install git
  git clone git://neil.brown.name/mdadm
  make install
  mdadm --add /dev/md5 /dev/sdX
  mdadm --replace /dev/md5 /dev/sdY

Recovery has been the same >100MB/sec and it is reading from one disk
'Y', writing to another 'X' without a full resync

Thanks again everyone your awesome ideas!

Now, time to see how many of these Linux raid options exist in my new
Lenovo/Iomega ix4 NAS unit.
http://www.amazon.com/s/ref=3Dnb_sb_noss?url=3Dsearch-alias%3Daps&field=
-keywords=3Dlenovo%20ix4
Apparently it runs a flavor of Debian for ARM.  I suspect I'll be
cross compiling some modern versions of our favorite tool :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
