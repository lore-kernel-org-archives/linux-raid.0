From: Peter Jonsson <dal01pjn@mds.mdh.se>
Subject: Re: Invalid superblock on drives in array
Date: Thu, 25 Dec 2003 18:27:00 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.44L.0312251811450.3919-100000@legolas.mdh.se>
References: <1072371527.3636.1.camel@binkley>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1072371527.3636.1.camel@binkley>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Dec 2003, seth vidal wrote:

> if this was running on a sparc then you might want to look at:
>
> mdadm --update=3Dsparc2.2

I wasn't clear enough. I got into problems when I moved the array from =
the
sparc to the PC so I backed up all the data and then I recreated the ar=
ray
and formatted the drive (ext3) before moving all the data back.

But I tried it anyway with this result :

[root@colossus mdadm-1.4.0]# ./mdadm --update=3Dsparc2.2 /dev/md0
--update does not set the mode, and so cannot be first.


I just tried to use mkraid to upgrade the superblocks (if that was the
problem) but it seems that something else is wrong.

[root@colossus mdadm-1.4.0]# mkraid --upgrade /dev/md0
handling MD device /dev/md0
analyzing super-block
cannot upgrade magic-less superblock on /dev/sda1 ...
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as
well
 for potential clues.)

> Oh and I'm also the yum author and I assure you, yum doesn't touch
> ANYTHING related to raid arrays, it just updates packages :)
>
Well, I wasn't implying that yum would do anything to the array. It was
just to explain that the machine was newly installed. :)

It had been running for about 1=BD days before something happend. I act=
ually
don't have any idea what might have happend. Something is wrong with th=
e
superblocks but I have idea how that happend. Act of God? ;)

// peter
--=20
If God is real, s/he might be integer (e.g. 0). If God is complex, then=
 s/he might be imaginary.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
