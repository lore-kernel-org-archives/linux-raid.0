From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Tue, 26 Jun 2012 10:37:19 +0200
Message-ID: <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	 <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	 <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
	 <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FE91619.4020709@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2012-06-25 at 20:53 -0500, Stan Hoeppner wrote:
> On 6/25/2012 5:31 AM, Ramon Hofer wrote:
> > On Sun, 24 Jun 2012 22:51:32 -0500, Stan Hoeppner wrote:
> > 
> >> On 6/24/2012 9:12 AM, Stan Hoeppner wrote:
> >>
> >>> That's premature.  If you don't have any irreplaceable data on md9 yet,
> >>> I'd recommend erasing all 4 EARS drives with the dd command so you have
> >>> a "fresh start".
> >>
> >> Sorry Ramon, I meant the Samsungs here, not EARS.  You probably
> >> understood.
> > 
> > No, sorry I'm a bit confused.
> 
> I'm confused as well.  The error you pasted was on md9, which I thought
> was the old Samsung array.

Sorry, I should have been more precise.

After I was able to recover md1 (WD blacks) I created md2 with the
Samungs.

Then I wanted to test the WD greens by creating md9 and copying the
mythtv recordings onto it. (I wanted to do that because I wanted to
switch to xfs as well for the recordings drive.)


> [61142.466334] md/raid:md9: read error not correctable (sector 3758190680
> on sdk).
> [61142.466338] md/raid:md9: Disk failure on sdk, disabling device.
> 
> Which disk is /dev/sdk?  WD20EARS or Samsung?

All the disks from md9 now are WD20EARS.

Sorry again for the confusion!


> > The Samsung drives worked fine so far. I already have used the linear 
> > array and don't know what is written to md2 through md0.
> > But I could remove one Samsung disk from md2, dd it, re add it and do 
> > this procedure for the other three Samsungs.
> 
> Ok, so md1 are the Blacks, md2 are the Samsungs.  You tried to create
> another array, md9, using the WD20EARS, and one, /dev/sdk, generated the
> error above.  Is this correct?

Exactly.


> > What about the WD green?
> 
> Ok, so currently the WD20EARS drives are not part of an array, correct?
>  And you're following the procedure I posted to dd the four drives, correct?

No, they're not.
And yes, I did. But the server behaved very strangely. Sometimes I
couldn't ssh into it anymore. Sometimes I could and the connection
froze.


> > I tried to dd them yesterday 
> 
> There is no "try" here.  Once you start the dd commands they run until
> complete.  You didn't kill the processes did you?

I wanted to watch a movie that evening. It streamed fine until about 15
min to the end but I really had to see the end before going to bed.


> > but when I wanted to stream a movie from the 
> > server it stopped. 
> 
> What do you mean "it stopped"?  What stopped?  The playback in the
> client app?

Yes.
I first thought it was because of the client app. But after I couldn't
ssh into the server and freezings of the ssh connection I thought I'd
reboot it.

I thought it couldn't be very hard to write a lot of zeros...


> > Sometimes I couldn't even ssh into the server and when 
> > I could the remote shell froze after a very short time.
> 
> You had 4 dd processes writing zeros to 4 drives at full bandwidth,
> consuming something like 480MB/s at the beginning and around 200MB/s at
> the end as the platter diameter gets smaller.  The controller chip on
> the LSI HBA is seeing tens of thousands of write IOPS.  Not to mention
> the four dd processes are generating a good deal of CPU load.  And it
> you're not running irqbalance, which you're surely not, interrupts from
> the controller are only going to 1 CPU core.
> 
> My point is, running these 4 dd's in parallel is going to be very taxing
> on your system.  I guess I should have added a caveat/warning in my 'dd'
> email that you should not do any other work on the system while it's
> dd'ing the 4 drives.  Sorry for failing to mention this.

I ran top to see if the system is busy. And I saw that the cpu isn't.
But the system load was as high as never before (around 10).
Now I see that the movie couldn't be streamed because the LSI controller
didn't have any bandwidth left for the movie.

So maybe I can just rerun the four dd commands when the server isn't
busy? Or even take out the drives and run the command on another
machine?


> > Should I try to dd them again but one after the other so that I know 
> > which one makes problems?
> 
> You first need to explain what you mean by "try again".  Unless you
> killed the processes, or rebooted or power cycled the machine, the dd
> processes would have run to completion.  I get the feeling you've
> omitted some important details.

Sorry, I didn't explain properly what I did.

When the dd command was running for some time I wanted to watch that
movie in the evening. Unfortunately it stopped about 15 minutes before
it was finished and it was very thrilling ;-)

So I rebooted the frontend machine because I thought it was because I
use a xbmc version with mythtv pvr support which is alpha or beta.

But the movie stopped after some seconds. It's really strange because
ite ran fine for about 1 hour 50 mins. Only the last 15 or 20 minutes
made problems.

When I first ssh-ed into the server the connection froze like if the
network connection had gone. But I could still ping it. I tried several
times. Sometimes I couldn't login sometimes I could.

Btw I ran the four dd commands within a screen session if this is of any
importance?


> Oh, please reply-to-all Ramon so these hit my inbox.  List mail goes to
> separate folders, and I don't check them in a timely manner.

Sorry the last time I used pan to reply. It's not possible to reply to
the list and you at the same time with it.
But evolution can :-)


Best regards
Ramon

