From: Technomage <technomage-hawke@cox.net>
Subject: Re: addendum: was Re: recovering data on a failed raid-0 installation
Date: Fri, 31 Mar 2006 19:07:13 -0700
Message-ID: <200603311907.14138.technomage-hawke@cox.net>
References: <200603290526.k2T5Qmp14592@www.watkins-home.com> <200603311458.54083.technomage-hawke@cox.net> <442DB358.1010402@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442DB358.1010402@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mike,
yeah.... coaxing the FS into trying to recover seems to be the sticky bit. :(

I have tried all that I know, which is not much considering that this is not 
my specialty (I am a unix security admin <unemployed on disability>).

we still have the original drives and we have a drive imaging device arriving 
(should have been here today). I can only hope that it will be able to 
overcome the problems I have seen with that particular laptop and its "flaky" 
IDE subsystem.

only problem with the backups, there were none (no spare drives and the person 
that did the setup hadn't realized until too late that there was an incipient 
problem with the hardware. :(

if the drive imager is successful in recovering the entire contents of the 
drive (he is a forensics specialist and I am retraining to be one) then we 
are in business. however, if not. call it a write off and move on I guess. :(

thanks for responding though.....


On Friday 31 March 2006 15:55, you wrote:
> You were in the right spot, I think raid-0 is just a data-lossy format
> and my first impression of your post was "well, don't pick raid-0, duh"
> - not in a rude way just that you got the defined behavior of the
> system, data loss on any failure
>
> I can't imagine how to coax a filesystem to work when it's missing half
> it's contents, but maybe a combination of forcing a start on the raid
> and read-only FS mounts could make it hobble along.
>
> I'd restore from backup and be done with it though
>
> -Mike
>
> Technomage wrote:
> > well? are you guys tapped out on this or should I be looking elsewhere?
> >
> > The *was* the recommended place to seek out help.
> >
> > still waiting........
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
