From: Omri Schwarz <ocschwar@MIT.EDU>
Subject: Re: Using the md driver to look at a bad hardware RAID.
Date: Tue, 01 Mar 2005 20:10:28 -0500
Message-ID: <200503020110.j221ASfj018044@bart-savagewood.mit.edu>
References: <4225056F.7040405@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: Your message of "Tue, 01 Mar 2005 16:14:39 PST."
             <4225056F.7040405@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Omri Schwarz <ocschwar@MIT.EDU>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.orgocschwar@MIT.EDU
List-Id: linux-raid.ids

> 
> I posted a shell script a couple weeks back that 
> creates/starts/stops/deletes a raid array from loopback mounted files
> 
> I mention that not because it helps you solve your problem directly, but 
> its certainly a tool you could use to verify your commands, for instance 
> if you made the files read only, and/or took md5sums to see if they were 
> modified, etc.
> 
> Screwing up test files while learning beats destroying data any day
> 
Amen. 

So I hacked up an awful user-space raid reading tool that
just reads the drives and spews out to stdout. I'll post it later 
and will try your script, once I have found enough scratch space.

Thanks!


> -Mike
> 
> Omri Schwarz wrote:
> 
> > 
> > Instead, if I were to insert this raidtab, would it do the right thing?
> > 


