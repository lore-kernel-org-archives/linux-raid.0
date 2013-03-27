From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 12:23:46 -0700
Message-ID: <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra>
	<51534450.8050905@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51534450.8050905@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 27, 2013 at 12:11 PM, Stan Hoeppner <stan@hardwarefreak.com=
> wrote:
> On 3/27/2013 11:01 AM, Roy Sigurd Karlsbakk wrote:
>> From the manual
>>
>>        -c, --chunk=3D
>>               Specify  chunk size of kibibytes.  The default when cr=
eating an array is 512KB.  To ensure compatibility with ear=E2=80=90
>>               lier versions, the default when Building and array wit=
h no persistent metadata is 64KB.  This is  only  meaningful
>>               for RAID0, RAID4, RAID5, RAID6, and RAID10.
>>
>> meaning - chunk size isn't relevant to a mirror
>
> The man page should be changed to explicitly state that --chunk does =
not
> apply to RAID1 or --linear arrays.  Far too many people are having
> trouble with this.  For those people the current docs are apparently =
too
> subtle.
>
> --
> Stan


'Subtle' is probably a good work. For me it took a few times reading
the man page after looking at what I have here where it tells me
nothing about chunk size on the RAID1.

Note that another level of understanding (which I don't have) has to
do with getting chunk sizes that work well for my needs. That's a
whole other kettle of fish...

Cheers,
Mark

mark@c2stable ~ $ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md6 : active raid5 sdc6[1] sdd6[2] sdb6[0]
      494833664 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] =
[UUU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md3 : active raid6 sdd3[2] sdc3[1] sdb3[0] sde3[3] sdf3[5]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] =
[UUUUU]

md7 : active raid6 sdd7[2] sdc7[1] sdb7[0] sde2[3] sdf2[4]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] =
[UUUUU]

md126 : active raid1 sdb5[0] sdd5[2] sdc5[1]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
mark@c2stable ~ $
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
