From: "Nick" <Nick@pie.ie>
Subject: Re: hello
Date: Fri, 23 May 2003 13:53:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <007b01c3212a$40c37440$1c640abe@nigel>
References: <200305231100.h4NB0u029539@jwblack.patel.sh>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, Dhaval Patel <dhaval@patel.sh>
List-Id: linux-raid.ids

Hi Dhaval,
Yes, the shutdowns when using 3Ware controllers can take some time,
particularly when you have been dealing with large files,  doing unclean
shutdown will indeed put the array in to a degraded state.

The 3DM web based manager has all the functionality of the CLI and is much
easier on the eye, to use it point your browser to http://localhost:1080 You
will also find access to the controller logs and alarms from here, much
nicer that the CLI.

Hope this helped.
Kind Regards,

Nick Gleeson
3Ware Applications Engineer
Technical Support (Europe)
Nick@pie.ie
www.3ware.com
Phone +353 61 702045

----- Original Message -----
From: Dhaval Patel <dhaval@patel.sh>
To: <linux-raid@vger.kernel.org>
Sent: Friday, May 23, 2003 12:00 PM
Subject: Re: hello


> Sorry, I should have provided this information in the first email. I am
using RAID 5 and
> I downloaded the latest firmware. I think I found the problem though.
Currently the box
> is in my bedroom since I am testing it before I put it in its permanent
location. And
> since I actually want to get some sleep at night I turn the box off. Well
I realized
> that it just so happens that it shuts down the raid card at the very end.
If you turn it
> off too quickly the raid card cannot shutdown cleanly and the array is
degraded. I wasnt
> checking the array and assuming that everything was fine. There are no
errors reported
> in messages or syslog. I ran the CLI from 3ware and saw that the array is
in fact
> degraded. I rebuilt it and ran the tests again and everything seems fine.
Here is the
> information about the controller from the CLI
>
> Driver:   1.02.00.033
> Model:    7500-4
> FW:       FE7X 1.05.00.049
> BIOS:     BE7X 1.08.00.046
> Monitor:  ME7X 1.01.00.035
> PCB:      Rev3
> PCHIP:    V1.30
> ACHIP:    V3.20
>
> I am actually running Slackware so I downloaded the driver for suse or
redhat kernel I
> dont remember which, and compiled it with the vanilla kernel that I
download when I
> install any box.
>
> I did install the 3dm and launched it with 3dmd. But I cannot get to the
web interface.
> How can I do that. Does it offer the same features that the CLI offers?
>
> Thanks,
> Dhaval
>
> Nick <Nick@pie.ie> said:
>
> > Hi Dhaval,
> > Did you download the source code for the driver and build it your self?
What
> > RAID level are you using?
> > and what revision of firmware did you download. One common problem that
> > causes this type of failure is a loose connection to one of your drives,
> > either the parallel cable or the power cable, if can recheck these first
it
> > might help.
> > Are you using 3DM, the web based management tool for 3Ware controllers,
this
> > will give you very detailed information on what is happening with your
> > array.
> >
> > Kind Regards,
> >
> > Nick Gleeson
> > 3Ware Applications Engineer
> > Technical Support (Europe)
> > Nick@pie.ie
> > www.3ware.com
> > Phone +353 61 702045
> >
> > ----- Original Message -----
> > From: Dhaval Patel <dhaval@patel.sh>
> > To: <linux-raid@vger.kernel.org>
> > Sent: Thursday, May 22, 2003 6:26 PM
> > Subject: hello
> >
> >
> > > Hi, everyone. I am new to this list. Currently I am trying to get IDE
raid
> > working with
> > > the 3ware 7500-4 controller, using Western Digital 120GB drives. I am
> > using Slackware
> > > with 2.4.20 kernel. I have the OS installed and am using the latest
driver
> > (1.02.00.033)
> > > that you can download from 3ware's website. I also applied the latest
> > firmware that came
> > > along with the driver. The bootup is fine, its just that when I try to
> > move huge files
> > > that the box freezes. Yesterday I was copying 50 550+MB files from one
> > directory to
> > > another and everything went well. This morning I am copying the same
files
> > to another
> > > directory and it froze on the second file. After it freezes I can
> > sometimes ping it and
> > > sometimes I cannot. I havent seen anything in /var/log/messages. After
a
> > restart
> > > everything seems fine.
> > >
> > > Thanks in advanced for your help,
> > > Dhaval
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
>
>
>
> --
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

