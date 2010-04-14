From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: grow fails with 2.6.34 git
Date: Wed, 14 Apr 2010 16:38:09 -0700
Message-ID: <m2u4877c76c1004141638m5b81d5c4rf27549535e1d08f0@mail.gmail.com>
References: <hq5efu$mqb$1@dough.gmane.org>
	 <v2p4877c76c1004141548m6d3da932hd14543da1b730af9@mail.gmail.com>
	 <hq5j1n$3os$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hq5j1n$3os$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: James Braid <jamesb@loreland.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 14, 2010 at 4:27 PM, James Braid <jamesb@loreland.org> wrot=
e:
> Michael Evans wrote:
>>
>> Yes, that /extremely/ slow growth progress is normal for this
>> conversion. =A0Every critical section must be backed up synced, and =
only
>> then will it proceed. =A0You may notice an incorrect number of disks
>> relative to the expected number. =A0That will go away the next time =
the
>> array is assembled.
>
> Thanks. I'm not concerned about the speed; the fact that I had to sto=
p and
> restart the array before the reshape would begin is what concerns me,=
 as
> well as the odd sysfs errors.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Probably some minor bug relating to sysfs entry creation; it looks
like it saw a duplicate entry, so probably just one flow control
statement and test off of valid.  It looks like that would have been
ancillary to the actual critical work anyway.  Presuming your data
doesn't read as garbage at the moment it should be intact when the
reshape completes as well.

As for what caused the error, you'd have to ask someone that currently
writes/tests the git version.  The system I use software raid on is
more or less 'production' in that it's the main file-server for the
house, so I tend to only use stable kernel versions.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
