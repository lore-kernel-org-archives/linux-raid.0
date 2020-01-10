From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Last scrub date and result
Date: Fri, 10 Jan 2020 19:17:03 +0100
Message-ID: <20200110181703.GA7028@lazy.lzy>
References: <CAJH6TXjryixcArdcu_oVzmkEyktpMSb62YaUJvUv_Nd7k3mbDg@mail.gmail.com>
 <CAJH6TXgvvgg3w096PJ+wKT==ixxH8VTzzoRjTTcMhTJ_SDf2xQ@mail.gmail.com>
 <20200110173114.GA3701@lazy.lzy>
 <CAJH6TXgByNnaWkFo25SrkbR15XgN47b5VhzgWLX=LvMhH-A1VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJH6TXgByNnaWkFo25SrkbR15XgN47b5VhzgWLX=LvMhH-A1VQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

On Fri, Jan 10, 2020 at 07:07:30PM +0100, Gandalf Corvotempesta wrote:
> Is triggered by a cron but is MD that does the scrub
> 
> As the scrub procedure is async, is not easy to log the scrub result,
> that's why i'm asking for something "native" that mdadm -D could show.

well, the time is available at script
level and this can be logged.
About the result, I guess it is possible
to log as well.
One option to investigate would be the
"--wait" of mdadm.

bye,

pg

> Il ven 10 gen 2020, 18:31 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
> ha scritto:
> 
> > Hi,
> >
> > On Fri, Jan 10, 2020 at 12:17:21PM +0100, Gandalf Corvotempesta wrote:
> > > Any thought ? Is this a stupid suggestion ?
> > >
> > > Il giorno lun 6 gen 2020 alle ore 12:49 Gandalf Corvotempesta
> > > <gandalf.corvotempesta@gmail.com> ha scritto:
> > > >
> > > > Would be possible to add, in mdadm --detail output, the date of last
> > > > scrub and it's result ?
> > > > Looking through logs is not always possible (and much more harder to
> > > > script something), having something like:
> > > >
> > > > Update Time : Mon Jan  6 12:47:29 2020
> > > >           State : clean
> > > > Last scrub Time: Mon Jan  4 12:47:29 2020
> > > > Last scrub result: success
> > > >
> > > > would be great!
> >
> > as far as I know, the scrub is triggered by
> > a cron job, so, very likely, the logging of
> > time and result could / should be done there.
> >
> > I do not think mdadm is the right place to
> > keep this information, but I might be wrong.
> >
> > bye,
> >
> > --
> >
> > piergiorgio
> >

-- 

piergiorgio
