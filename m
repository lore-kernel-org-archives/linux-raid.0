From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 13:36:13 -0700
Message-ID: <j2q5bdc1c8b1004211336h8199f471wb8597803680878dc@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAF8185.9040307@gmx.net>
	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>
	 <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com>
	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
	 <4BCF4693.3020101@buttersideup.com>
	 <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com>
	 <4BCF52ED.3000607@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCF52ED.3000607@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Tim Small <tim@buttersideup.com>, Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 21, 2010 at 12:33 PM, Phillip Susi <psusi@cfl.rr.com> wrote=
:
> On 4/21/2010 3:01 PM, Mark Knecht wrote:
>> It's unfortunate that this drive doesn't respond to APM commands eit=
her.
>
> Yes it is.... would be nice if they made it respond to the standard A=
PM
> command meant to configure this kind of behavior instead of creating =
a
> proprietary command and dos utility to invoke it. =C2=A0It's also a s=
hame the
> drive lies about its physical sector size and has no way to turn that
> off. =C2=A0Might be a nice project to reverse engineer this utility o=
n
> windows to figure out the command it sends down and add it to hdparm.

I thought the same thing so I worked with the hdparm developer (Mark
Lord) and gave him data two months back. There was a command he had me
run (hdparm --istdout /dev/sda) that extracts firmware tables or
something and he spent time looking at the tables only to decide that
WD simply isn't identifying anywhere in the tables that the drive is
4K/ physical sector. With that it doesn't seem that hdparm could ever
do anything automatic that would be safe.

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
