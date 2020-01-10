From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Last scrub date and result
Date: Fri, 10 Jan 2020 18:31:14 +0100
Message-ID: <20200110173114.GA3701@lazy.lzy>
References: <CAJH6TXjryixcArdcu_oVzmkEyktpMSb62YaUJvUv_Nd7k3mbDg@mail.gmail.com>
 <CAJH6TXgvvgg3w096PJ+wKT==ixxH8VTzzoRjTTcMhTJ_SDf2xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJH6TXgvvgg3w096PJ+wKT==ixxH8VTzzoRjTTcMhTJ_SDf2xQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

On Fri, Jan 10, 2020 at 12:17:21PM +0100, Gandalf Corvotempesta wrote:
> Any thought ? Is this a stupid suggestion ?
> 
> Il giorno lun 6 gen 2020 alle ore 12:49 Gandalf Corvotempesta
> <gandalf.corvotempesta@gmail.com> ha scritto:
> >
> > Would be possible to add, in mdadm --detail output, the date of last
> > scrub and it's result ?
> > Looking through logs is not always possible (and much more harder to
> > script something), having something like:
> >
> > Update Time : Mon Jan  6 12:47:29 2020
> >           State : clean
> > Last scrub Time: Mon Jan  4 12:47:29 2020
> > Last scrub result: success
> >
> > would be great!

as far as I know, the scrub is triggered by
a cron job, so, very likely, the logging of
time and result could / should be done there.

I do not think mdadm is the right place to
keep this information, but I might be wrong.

bye,

-- 

piergiorgio
