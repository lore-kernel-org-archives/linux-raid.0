From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Tue, 02 Apr 2013 09:15:29 +0800
Message-ID: <515A3131.2020809@fnarfbargle.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra> <51534450.8050905@hardwarefreak.com> <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com> <51535252.2080105@hardwarefreak.com> <CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com> <51536DDD.5010800@hardwarefreak.com> <CAK2H+edehoVSrEbD_Hh_rE79V0MvgHPcrxNJiOh7_suhGdAXSA@mail.gmail.com> <51585CB9.5020208@hardwarefreak.com> <CAK2H+efkcjobknaWBupLQpxPkM+m_9JMDGwY1sH9UWw4tc=Czw@mail.gmail.com> <51587548.3060306@hardwarefreak.com> <CAK2H+efkGPNGbhRAgg8HabUL4fsioDTL0uUkrx2rrKxxQ=ZXGQ@mail.gmail.com> <5158D4BB.6070801@hardwarefreak.com> <CAK2H+eeV_VDDHRYJDNQB8K5tz2pw+JMb154FgA8BoJgFTDdWrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eeV_VDDHRYJDNQB8K5tz2pw+JMb154FgA8BoJgFTDdWrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/13 00:46, Mark Knecht wrote:
> On Sun, Mar 31, 2013 at 5:28 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> So maybe the idea I had awhile back about moving the VMs to the SSD -
> the VMs are about 90GB, the SSD is 128GB - and then at the end of
> every day just copying the VMs over to the RAID as a backup - would be
> a better way to run?

I do this using rsync to give me 5 days of rotating VM backup. I don't 
use snapshotting or any other data-consistency measures, and I routinely 
restore the backups onto a test machine and have (probably luckily) not 
encountered any consistency issues a quick fsck won't fix up.

As a double backup, I also use either Windows backup or rsync inside the 
virtual guests to perform full system backups.

