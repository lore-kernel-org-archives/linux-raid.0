From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Tue, 1 Sep 2009 08:20:09 -0400
Message-ID: <7d86ddb90909010520h545caca1o3895f47709c65d64@mail.gmail.com>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anil Raj <anil.calvin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would start by installing the Dell OpenManage Server Administrator
software, which will provide you with a web gui on
https://yourserver:1311 From here you can monitor the internals of the
server, check firmware versions, and perform RAID tasks on the PERC
controller, if it has one. You should be able to download the Red Hat
version of the Open Manage software from the Dell support site. Last
time I checked the latest version was 6.1.0.

Ryan

On Mon, Aug 31, 2009 at 8:53 PM, Anil Raj<anil.calvin@gmail.com> wrote:
> Hi all,
> =A0I have a dell PowerEdge 1850 server with 146gb HDs setup using (I
> think) hardware RAID.
>
> 1. Is there anyway that I can confirm if the HDs are indeed setup
> using hardware RAID? (hopefully without rebooting the system) And if
> so, how do I determine the tech details of the RAID setup?
>
> 2. I'm planning on buying additional dell drives and was wondering ho=
w
> I could go about growing/expanding the current RAID setup to include
> the new drives. Is there any documentation on expanding hardware RAID=
?
> ( I found doc on growing software RAID on the mailing list's wiki but
> none on hardware RAID.)
>
> I really really hope someone can help me with these questions, please=
=2E
> Also, if this is not the right forum (and there is a more relevant
> forum) for these questions, please do let me know.
>
> Thanks much in advance!
>
> Best,
> Anil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
